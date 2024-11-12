const historyApiFallback = require("connect-history-api-fallback");

const browserSync = require("browser-sync").create();

browserSync.init({
    port: 11923,
    watch: true,
    server: "./RDWP-exe.jsexe",
    files: "./RDWP-exe.jsexe/all.js",
    middleware: [historyApiFallback()]
});



