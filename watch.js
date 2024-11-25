const express = require('express')
const historyApiFallback = require("connect-history-api-fallback")
const proxy = require('http-proxy-middleware')
const ws = require('ws');
const chokidar = require('chokidar')

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

function chokidarCommon (wsServer) {
    chokidar.watch('frontend').on('change', () => {
        wsServer.clients.forEach(client => {
            if (client.readyState === WebSocket.OPEN) {
                if ( process.env.SERVER_MODE === 'WARP' ) {
                    client.send("RELOAD-- NOW");
                } else if ( process.env.SERVER_MODE === 'WEBKIT' ) {
                    client.send("SHUTDOWN NOW");
                }
            }
        })
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
} else if ( process.env.SERVER_MODE === 'WARP' ) {
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
    const wsServer = wsCommon(server)
    chokidarCommon(wsServer)
} else if ( process.env.SERVER_MODE === 'WEBKIT' ) {
    const app = express()
    const server = app.listen(11923)
    const wsServer = wsCommon(server)
    chokidarCommon(wsServer)
}