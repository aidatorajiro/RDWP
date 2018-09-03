/*
|--------------------------------------------------------------------------
| Browser-sync config file
|--------------------------------------------------------------------------
|
| For up-to-date information about the options:
|   http://www.browsersync.io/docs/options/
|
| There are more options than you see here, these are just the ones that are
| set internally. See the website for more info.
|
|
*/

/*
|===============================================================================================================
| BELOW CODES ARE COPIED FROM https://github.com/bripkens/connect-history-api-fallback/blob/master/lib/index.js
| COPYRIGHT (c) 2012 Ben Ripkens http://bripkens.de
|===============================================================================================================
*/

var url = require('url');

function historyApiFallback(options) {
    options = options || {};
    var logger = getLogger(options);
    
    return function(req, res, next) {
        var headers = req.headers;
        if (req.method !== 'GET') {
            logger(
                'Not rewriting',
                req.method,
                req.url,
                'because the method is not GET.'
            );
            return next();
        } else if (!headers || typeof headers.accept !== 'string') {
            logger(
                'Not rewriting',
                req.method,
                req.url,
                'because the client did not send an HTTP accept header.'
            );
            return next();
        } else if (headers.accept.indexOf('application/json') === 0) {
            logger(
                'Not rewriting',
                req.method,
                req.url,
                'because the client prefers JSON.'
            );
            return next();
        } else if (!acceptsHtml(headers.accept, options)) {
            logger(
                'Not rewriting',
                req.method,
                req.url,
                'because the client does not accept HTML.'
            );
            return next();
        }
        
        var parsedUrl = url.parse(req.url);
        var rewriteTarget;
        options.rewrites = options.rewrites || [];
        for (var i = 0; i < options.rewrites.length; i++) {
            var rewrite = options.rewrites[i];
            var match = parsedUrl.pathname.match(rewrite.from);
            if (match !== null) {
                rewriteTarget = evaluateRewriteRule(parsedUrl, match, rewrite.to, req);
                logger('Rewriting', req.method, req.url, 'to', rewriteTarget);
                req.url = rewriteTarget;
                return next();
            }
        }
        
        var pathname = parsedUrl.pathname;
        if (pathname.lastIndexOf('.') > pathname.lastIndexOf('/') &&
        options.disableDotRule !== true) {
            logger(
                'Not rewriting',
                req.method,
                req.url,
                'because the path includes a dot (.) character.'
            );
            return next();
        }
        
        rewriteTarget = options.index || '/index.html';
        logger('Rewriting', req.method, req.url, 'to', rewriteTarget);
        req.url = rewriteTarget;
        next();
    };
};

function evaluateRewriteRule(parsedUrl, match, rule, req) {
    if (typeof rule === 'string') {
        return rule;
    } else if (typeof rule !== 'function') {
        throw new Error('Rewrite rule can only be of type string or function.');
    }
    
    return rule({
        parsedUrl: parsedUrl,
        match: match,
        request: req
    });
}

function acceptsHtml(header, options) {
    options.htmlAcceptHeaders = options.htmlAcceptHeaders || ['text/html', '*/*'];
    for (var i = 0; i < options.htmlAcceptHeaders.length; i++) {
        if (header.indexOf(options.htmlAcceptHeaders[i]) !== -1) {
            return true;
        }
    }
    return false;
}

function getLogger(options) {
    if (options && options.logger) {
        return options.logger;
    } else if (options && options.verbose) {
        return console.log.bind(console);
    }
    return function(){};
}

/*
|==============
| END CLIPPING
|==============
*/

let base = __dirname + "/result/ghcjs/frontend/bin/RDWP-exe.jsexe/"

module.exports = {
    "ui": {
        "port": 3001,
        "weinre": {
            "port": 8080
        }
    },
    "files": [__dirname + "/results"],
    "watchEvents": [
        "change"
    ],
    "watchOptions": {
        "ignoreInitial": true
    },
    "server": {
        "baseDir": base,
        "index": "index.html",
        "middleware": [ historyApiFallback() ],
    },
    "proxy": false,
    "port": 3000,
    "middleware": false,
    "serveStatic": [],
    "ghostMode": {
        "clicks": true,
        "scroll": true,
        "location": true,
        "forms": {
            "submit": true,
            "inputs": true,
            "toggles": true
        }
    },
    "logLevel": "info",
    "logPrefix": "Browsersync",
    "logConnections": false,
    "logFileChanges": true,
    "logSnippet": true,
    "rewriteRules": [],
    "open": "local",
    "browser": "default",
    "cors": false,
    "xip": false,
    "hostnameSuffix": false,
    "reloadOnRestart": false,
    "notify": true,
    "scrollProportionally": true,
    "scrollThrottle": 0,
    "scrollRestoreTechnique": "window.name",
    "scrollElements": [],
    "scrollElementMapping": [],
    "reloadDelay": 0,
    "reloadDebounce": 0,
    "reloadThrottle": 0,
    "plugins": [],
    "injectChanges": true,
    "startPath": null,
    "minify": true,
    "host": null,
    "localOnly": false,
    "codeSync": true,
    "timestamps": true,
    "clientEvents": [
        "scroll",
        "scroll:element",
        "input:text",
        "input:toggles",
        "form:submit",
        "form:reset",
        "click"
    ],
    "socket": {
        "socketIoOptions": {
            "log": false
        },
        "socketIoClientConfig": {
            "reconnectionAttempts": 50
        },
        "path": "/browser-sync/socket.io",
        "clientPath": "/browser-sync",
        "namespace": "/browser-sync",
        "clients": {
            "heartbeatTimeout": 5000
        }
    },
    "tagNames": {
        "less": "link",
        "scss": "link",
        "css": "link",
        "jpg": "img",
        "jpeg": "img",
        "png": "img",
        "svg": "img",
        "gif": "img",
        "js": "script"
    }
};
