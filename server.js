const express = require('express');
const path = require('path');
const port = process.env.PORT || 8080;
const app = express();
const fs = require('fs');

app.get('*', function (request, response) {
  // TODO: if no file found, use index.html. otherwise, use the file.
  console.log(request.path)
  let p = path.join(__dirname, 'RDWP-exe.jsexe', request.path);
  console.log(p)
  if (!fs.existsSync(p)) {
    response.sendFile(path.join(__dirname, 'RDWP-exe.jsexe', 'index.html'))
  } else {
    response.sendFile(p)
  }
});

app.listen(port);
console.log('server started on port ' + port);

