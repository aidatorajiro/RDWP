const express = require('express');
const historyApiFallback = require("connect-history-api-fallback");
const proxy = require('http-proxy-middleware');
const ws = require('ws');
const chokidar = require('chokidar');
const { execFile, spawn } = require('node:child_process');
const winston = require('winston');

(async () => {

const chalk = (await import('chalk')).default;

const labelColors = {
  meta: chalk.hex('#FFA000'),
  exec: chalk.hex('#00A0FF'),
  net: chalk.hex('#D02000'),
  info: chalk.bgHex('#102080').white,
  error: chalk.bgRed.white
}

const defaultFormat = winston.format.combine(
    winston.format.printf(({ level, label, message }) => {
        label = labelColors[label](label.padStart(5, ' '))
        level = labelColors[level](level.padStart(5, ' '))
        let x = "";
        let l = message.split("\n")
        for (let i = 0; i < l.length; i++) {
            if (i === l.length - 1) {
                x += `${label}|${level}|${l[i]}`
            } else {
                x += `${label}|${level}|${l[i]}\n`
            }
        }
        return x;
    })
)

const defaultLoggerOptions = {
    transports: [ new winston.transports.Console() ]
}

const logger_meta = winston.createLogger({
    ...defaultLoggerOptions,
    format: winston.format.combine(
        winston.format.label({label: ('meta')}),
        defaultFormat
    )
});

const logger_exec = winston.createLogger({
    ...defaultLoggerOptions,
    format: winston.format.combine(
        winston.format.label({label: ('exec')}),
        defaultFormat
    )
});

const logger_net = winston.createLogger({
    ...defaultLoggerOptions,
    format: winston.format.combine(
        winston.format.label({label: ('net')}),
        defaultFormat
    )
});



function getYaml () {
    let yaml;
    if ( process.env.SERVER_MODE === 'WARP' ) {
        yaml = "./stack.linux.warp.yaml"
    } else if ( process.env.SERVER_MODE === 'WEBKIT' ) {
        yaml = "./stack.linux.webkit.yaml"
    }
    return yaml;
}

function makeExecError ({error, stderr}) {
    return {type: "ExecError", error, stderr}
}

function doBuild () {
    return new Promise((res, rej) => {
        execFile("stack", ["build", "--stack-yaml=" + getYaml()], (error, stdout, stderr) => {
            if (error === null) {
                res(stdout)
            } else {
                rej(makeExecError({error, stderr}))
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
        logger_exec.info(`${data}`);
    });
    
    s.stderr.on('data', (data) => {
        logger_exec.error(`${data}`);
    });
    
    s.on('close', (code, signal) => {
        logger_exec.info(`child process exited with code ${code} signal ${signal}`);
    });

    return s
}

function getExecutablePath () {
    return new Promise((res, rej) => {
        execFile("stack", ["exec", "--stack-yaml=" + getYaml(), "--", "which", "RDWP-exe"], (error, stdout, stderr) => {
            if (error === null) {
                res(stdout.replace("\n", ""))
            } else {
                rej(makeExecError({error, stderr}))
            }
        })
    })
}

function getHostname () {
  if ( process.env.SERVER_HOST === undefined ) {
    return "localhost"
  } else {
    return process.env.SERVER_HOST
  }
}

function appCommon () {
    if ( process.env.SERVER_MODE === 'WARP' ) {
        const app = express()
        // existing static files
        app.use(express.static('./frontend/assets'))
        // requests that has no dots AND its contents type is html -> /index-warp.html
        app.use(historyApiFallback({
            index: '/index-warp.html'
        }))
        // /index-warp.html
        app.use(express.static('./index-warp'))
        // all other requests that is not /wsapi (eg. /jsaddle.js, websocket /, sync xhr requests) -> proxy
        app.use(proxy.createProxyMiddleware({
            target: 'http://' + getHostname() + ':11924/',
            changeOrigin: true,
            pathFilter: function (x) {
                return !(x.match(/^\/wsapi$/))
            },
            ws: true
        }))
        const server = app.listen(11923, getHostname())
        // /wsapi : custom websocket server
        return app, server
    } else if ( process.env.SERVER_MODE === 'WEBKIT' ) {
        const app = express()
        const server = app.listen(11923, getHostname())
        return app, server
    }
}

function wsCommon (server) {
    const wsServer = new ws.Server({ noServer: true });
    wsServer.on('connection', socket => {
      socket.on('error', logger_net.error);
      socket.on('message', logger_net.info);
    });
    server.on('upgrade', (request, socket, head) => {
        if (request.url === '/wsapi') {
            logger_net.info('client connected...')
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

const chokidarState = {
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
    // TODO: implement for webkit
    chokidar.watch('frontend').on('change', async () => {
        if (chokidarState.isLocked()) { return; }
        chokidarState.lock()
        try {
            logger_meta.info("Start Build...")
            const stdout = await doBuild()
            logger_exec.info(stdout)
            logger_meta.info("Build Complete! Running Executable...")
            const execpath = await getExecutablePath()

            if (chokidarState.mainProcess !== null) {
                logger_meta.info("Terminating Previous Process...")
                // broadcast reload script (takes 3 seconds to invoke location.reload())
                broadcastReload(wsServer)
                // 3 second left
                await sleep(1000) // send location.reload() here
                // 2 second left
                await killMainProcess()
            }

            logger_meta.info('Launching New Process...')
            chokidarState.mainProcess = doExec(execpath)
            // 0 second left
            chokidarState.unlock()
        } catch (e) {
            if (e.type === "ExecError") {
                logger_exec.error(e.error)
                logger_exec.error(e.stderr)
            } else {
                logger_meta.error(e)
            }
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

})();
