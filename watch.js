const express = require('express')
const historyApiFallback = require("connect-history-api-fallback")
const proxy = require('http-proxy-middleware')

if ( process.env.SERVER_MODE === 'GHCJS' ){
    const app = express()
    app.use(historyApiFallback())
    app.use(express.static('./RDWP-exe.jsexe'))
    app.listen(11923)
} else if ( process.env.SERVER_MODE === 'WARP' ) {
    const app = express()
    app.use(express.static('./frontend/assets'))
    app.use(historyApiFallback({
        verbose: true,
        index: '/'
    }))
    app.use(proxy.createProxyMiddleware({
        target: 'http://localhost:11924/',
        changeOrigin: true,
        ws: true
    }))
    app.listen(11923)
} else if ( process.env.SERVER_MODE === 'WEBKIT' ) {

}