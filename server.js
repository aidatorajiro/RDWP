const express = require('express');
const path = require('path');
const port = process.env.PORT || 8080;
const app = express();

app.get('*', function (request, response) {
  // TODO: if no file found, use index.html. otherwise, use the file.
  response.sendFile(path.join(__dirname, 'result/ghcjs/frontend/bin/RDWP-exe.jsexe', 'index.html'));
});

app.listen(port);
console.log('server started on port ' + port);

