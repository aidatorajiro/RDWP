const express = require('express')
const historyApiFallback = require("connect-history-api-fallback")
const proxy = require('http-proxy-middleware')
const ws = require('ws');
const chokidar = require('chokidar')
const { execFile, spawn } = require('node:child_process');

function getYaml () {
    let yaml;
    if ( process.env.SERVER_MODE === 'WARP' ) {
        yaml = "./stack.linux.warp.yaml"
    } else if ( process.env.SERVER_MODE === 'WEBKIT' ) {
        yaml = "./stack.linux.webkit.yaml"
    }
    return yaml;
}

function doBuild () {
    return new Promise((res, rej) => {
        execFile("stack", ["build", "--stack-yaml=" + getYaml()], (error, stdout, stderr) => {
            if (error === null) {
                res(stdout)
            } else {
                rej({error, stderr})
            }
        })
    })
}

function doExec (path) {
    let s = spawn(path, {
        cwd: './frontend/assets',
        env: {
            JSADDLE_WARP_PORT: 11924
        }
    })

    s.stdout.on('data', (data) => {
        console.log(`stdout: ${data}`);
    });
    
    s.stderr.on('data', (data) => {
        console.error(`stderr: ${data}`);
    });
    
    s.on('close', (code) => {
        console.log(`child process exited with code ${code}`);
    });

    return s
}

function getExecutablePath () {
    return new Promise((res, rej) => {
        execFile("stack", ["exec", "--stack-yaml=" + getYaml(), "--", "which", "RDWP-exe"], (error, stdout, stderr) => {
            if (error === null) {
                res(stdout.replace("\n", ""))
            } else {
                rej({error, stderr})
            }
        })
    })
}

function appCommon () {
    if ( process.env.SERVER_MODE === 'WARP' ) {
        const app = express()
        app.use(express.static('./frontend/assets'))
        app.use(historyApiFallback({
            index: '/'
        }))
        app.use(proxy.createProxyMiddleware({
            target: 'http://localhost:11924/',
            changeOrigin: true,
            pathFilter: function (x) {
                return !(x.match(/^\/wsapi$/))
            },
            ws: true
        }))
        const server = app.listen(11923)
        return app, server
    } else if ( process.env.SERVER_MODE === 'WEBKIT' ) {
        const app = express()
        const server = app.listen(11923)
        return app, server
    }
}

function wsCommon (server) {
    const wsServer = new ws.Server({ noServer: true });
    wsServer.on('connection', socket => {
      socket.on('error', console.error);
      socket.on('message', console.log);
    });
    server.on('upgrade', (request, socket, head) => {
        if (request.url === '/wsapi') {
            console.log('/wsapi connected...')
            wsServer.handleUpgrade(request, socket, head, socket => {
                socket.send('CONNECT- HELLO')
                wsServer.emit('connection', socket, request);
            });
        }
    });
    return wsServer
}

function broadcastReload (wsServer) {
    wsServer.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
            if ( process.env.SERVER_MODE === 'WARP' ) {
                client.send("RELOAD-- NOW");
            } else if ( process.env.SERVER_MODE === 'WEBKIT' ) {
                client.send("SHUTDOWN NOW");
            }
        }
    })
}

let chokidarState = {
    __inner_main: false,
    __inner_timeouts: new Set(),
    lock: function () {
        this.__inner_main = true
        this.__inner_timeouts.forEach((x) => {
            clearTimeout(x)
            this.__inner_timeouts.delete(x)
        })
    },
    unlock: function () {
        let to = setTimeout(() => {
            this.__inner_main = false
            this.__inner_timeouts.delete(to)
        }, 1000)
        this.__inner_timeouts.add(to)
    },
    isLocked: function () {
        return this.__inner_main === true
    },
    mainProcess: null
};

function killMainProcess () {
    return new Promise((res, rej) => {
        chokidarState.mainProcess.on('close', (code, signal) => {
            console.log(`child process terminated due to receipt of signal ${signal} code ${code}`);
            res()
        })
        chokidarState.mainProcess.kill()
    })
}

function sleep (time) {
    return new Promise((res, rej) => {
        setTimeout(res, time)
    })
}

function chokidarCommon (wsServer) {
    chokidar.watch('frontend').on('change', async () => {
        if (chokidarState.isLocked()) { return; }
        chokidarState.lock()
        try {
            const stdout = await doBuild()
            console.log(stdout)

            if (chokidarState.mainProcess !== null) {
                broadcastReload(wsServer)
                await sleep(1000)
                await killMainProcess()
            }

            const execpath = await getExecutablePath()
            chokidarState.mainProcess = doExec(execpath)
            chokidarState.unlock()
        } catch (e) {
            console.error("ERRORCODE: ", e.error)
            console.error(e.stderr)
            chokidarState.unlock()
        }
    })
}

if ( process.env.SERVER_MODE === 'GHCJS' ){
    const browserSync = require("browser-sync").create();

    browserSync.init({
        port: 11923,
        watch: true,
        server: "./RDWP-exe.jsexe",
        files: "./RDWP-exe.jsexe/all.js",
        middleware: [historyApiFallback()]
    });
} else if ( process.env.SERVER_MODE === 'WARP' || process.env.SERVER_MODE === 'WEBKIT' ) {
    let app, server = appCommon()
    const wsServer = wsCommon(server)
    chokidarCommon(wsServer)
}