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

        if (!grunt.file.exists(destDirectory) || !grunt.file.isDir(destDirectory)) {
            grunt.log.error('Downloads directory ' + destDirectory +' does not exist.');
            done(false);
        } else {
            var jsonFilePath = path.resolve('tasks/json/wsdls.json');
            var wsdls = grunt.file.readJSON(jsonFilePath);
            var cacheInfoFilePath = path.resolve('tasks/json/cache.json');
            var cacheInfo = loadCacheInfo(cacheInfoFilePath, wsdls); 

            async.forEachSeries(wsdls.files, async.apply(processWSDL, cacheInfo, destDirectory), function () {
                grunt.verbose.writeln('Updating JSON file ' + cacheInfoFilePath);
                fs.writeFile(cacheInfoFilePath, JSON.stringify(cacheInfo, null, 4), function (err) {
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
    
    function loadCacheInfo(cacheInfoFilePath, wsdls)
    {
        var cacheInfo = {};

        if(!grunt.file.exists(cacheInfoFilePath)) {
            grunt.verbose.writeln('Creating cache information.');
            wsdls.files.forEach(function (wsdl) {
                cacheInfo[wsdl.src] = {
                    "last_etag_downloaded" : ""
                };
            });
        }
        else {
            cacheInfo = grunt.file.readJSON(cacheInfoFilePath);
        }
    
        return cacheInfo;
    }

    function processWSDL(cacheInfo, destDirectory, wsdl, callback) {
        grunt.log.writeln('Processing ' + wsdl.src + '...');
        async.waterfall([
            async.apply(downloadRequired, cacheInfo, wsdl, destDirectory),
            async.apply(downloadWSDL, wsdl, destDirectory)
        ], function(err, results) { 
            if (err) {
                grunt.log.error(err);
            }
            callback();
        });
    }

    function downloadRequired(cacheInfo, wsdl, destDirectory, callback) {
        if (!grunt.file.exists(destDirectory, wsdl.dest)) {
            callback(null, true);
        } else {    
            checkETAG(cacheInfo, wsdl, function (err, noMatch) { 
                if(err) {
                   callback(err); 
                }
                else {
                    callback(null, noMatch);
                }
            });
        }
    }

    function checkETAG(cacheInfo, wsdl, callback) {
        var parsedEndpoint = url.parse(wsdl.src);
        var cache = cacheInfo[wsdl.src];
		var options = {
			hostname : parsedEndpoint.hostname,
			path : parsedEndpoint.path,
			method: 'HEAD'
        };

        var req = http.request(options, function (res) {
            grunt.log.debug('res.headers.etag:           ' + res.headers.etag);
            grunt.log.debug('cache.last_etag_downloaded: ' + cache.last_etag_downloaded);
            var noMatch = res.headers.etag !== cache.last_etag_downloaded;
            cache.last_etag_downloaded = res.headers.etag;
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
