var express = require("express");
var cluster = require('express-cluster');
var bodyParser = require("body-parser");

cluster((worker) => {
    var app = express();
    app.use(bodyParser.json());

    app.post("/json-data", (req, res) => {
        res.send(req.body);
    });

    app.listen(8080);
}, {count: 4});


