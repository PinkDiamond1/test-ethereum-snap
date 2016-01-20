#!/usr/bin/env node

var sys = require("sys"),
var http = require("http"),
var url = require("url"),
var path = require("path"),
var fs = require("fs");
var jsdom = require("jsdom");
var Web3 = require('web3');
var web3 = new Web3();
web3.setProvider(
    new web3.providers.IpcProvider(
	"/var/lib/apps/ethereum/current/.ethereum/geth.ipc",
	require('net')
    )
);

http.createServer(function(request, response) {
    var uri = url.parse(request.url).pathname;
    var filename = path.join(process.cwd(), "other_index.html");
    web3.eth.getBlockNumber(function (error, result) {
	if (error) {
	    console.log(error)
	    return;
	}
	var htmlSource = fs.readFileSync(filename, "utf8");
	call_jsdom(htmlSource, function (window) {
	    var $ = window.$;
	    var title = "Block Number: " + result;
	    $("h1").text(title);
	    console.log("Title should be" + title);
	    console.log(documentToSource(window.document));
	    // send the changed DOM as the response
	    response.writeHead(200);
            response.write(window.document.documentElement.outerHTML);
            response.end();
	});
    });
}).listen(8080);


function documentToSource(doc) {
    // The non-standard window.document.outerHTML also exists,
    // but currently does not preserve source code structure as well

    // The following two operations are non-standard
    return doc.doctype.toString()+doc.innerHTML;
}

function call_jsdom(source, callback) {
    jsdom.env(
        source,
        [ 'jquery-1.7.1.min.js' ],
        function(errors, window) {
            process.nextTick(
                function () {
                    if (errors) {
                        throw new Error("There were errors: "+errors);
                    }
                    callback(window);
                }
            );
        }
    );
}

sys.puts("Server running at http://localhost:8080/");
