module.exports = function(grunt) {
    var fs = require('fs');
    var path = require('path');
    var http = require('http');
    var url = require('url');
    var async = grunt.util.async;

    grunt.registerTask('download', 'Intelligently download the eBay API WSDLs.', function () {
        grunt.config.requires('download.dest');

        var done = this.async();
        var destDirectory = path.resolve(grunt.config('download.dest'));

        if (!fs.existsSync(destDirectory) && fs.statSync(destDirectory).isDirectory()) {
            grunt.log.error('Downloads directory ' + destDirectory +' does not exist.');
            done(false);
        } else {
            var jsonFilePath = path.resolve('tasks/json/wsdls.json');
            var wsdls = require(jsonFilePath);
            async.forEachSeries(wsdls.files, async.apply(processWSDL, destDirectory), function () {
                grunt.verbose.writeln('Updating JSON file ' + jsonFilePath);
                fs.writeFile(jsonFilePath, JSON.stringify(wsdls, null, 4), function (err) {
                    if (err) {
                        grunt.log.error(err.message);
                        done(false);
                    } else {
                        done(true);
                    }
                });
            });
        }
    });

    function processWSDL(destDirectory, wsdl, callback) {
        grunt.log.writeln('Processing ' + wsdl.src + '...');
        async.waterfall([
            async.apply(downloadRequired, wsdl, destDirectory),
            async.apply(downloadWSDL, wsdl, destDirectory)
        ], function(err, results) { 
            if (err) {
                grunt.log.error(err);
            }
            callback();
        });
    }

    function downloadRequired(wsdl, destDirectory, callback) {
        if (!fs.existsSync(path.join(destDirectory, wsdl.dest))) {
            callback(null, true);
        } else {    
            checkETAG(wsdl, function (err, noMatch) { 
                if(err) {
                   callback(err); 
                }
                else {
                    callback(null, noMatch);
                }
            });
        }
    }

    function checkETAG(wsdl, callback) {
        var parsedEndpoint = url.parse(wsdl.src);
		var options = {
			hostname : parsedEndpoint.hostname,
			path : parsedEndpoint.path,
			method: 'HEAD'
        };

        var req = http.request(options, function (res) {
            grunt.log.debug('res.headers.etag: ' + res.headers.etag);
            grunt.log.debug('wsdl.etag:        ' + wsdl.etag);
            var noMatch = res.headers.etag !== wsdl.etag;
            wsdl.etag = res.headers.etag;
            callback(null, noMatch);
        });
        req.on('error', function (err) {
            callback(err.message);
        });
        req.end();
    }

    function downloadWSDL(wsdl, destDirectory, downloadRequired, callback) {
        if (! downloadRequired) {
            grunt.log.writeln('Do not need to download.');
            callback();
        } else {
            grunt.log.writeln('Downloading as ' + wsdl.dest + '...');
            http.get(wsdl.src, function (res) {
                res.pipe(fs.createWriteStream(path.join(destDirectory,wsdl.dest)));
                res.on('end', function () {
                    callback();
                });
            }).on('error', function (err) {
                callback(err.message); 
            });
        }
    }
};
