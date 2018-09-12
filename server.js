const express = require('express');
const path = require('path');
const port = process.env.PORT || 8080;
const app = express();

app.get('/:filename.js', function (request, response) {
  response.sendFile(path.join(__dirname, 'result/ghcjs/frontend/bin/RDWP-exe.jsexe', request.params.filename + '.js'));
});

app.get('*', function (request, response) {
  response.sendFile(path.join(__dirname, 'result/ghcjs/frontend/bin/RDWP-exe.jsexe', 'index.html'));
});

app.listen(port);
console.log('server started on port ' + port);

