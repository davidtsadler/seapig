module.exports = function(grunt) {
    var fs = require('fs');
    var path = require('path');
    var http = require('http');
    var url = require('url');
    var async = grunt.util.async;

    grunt.registerTask('download', 'Download the eBay API WSDLs.', function () {
        grunt.config.requires('download.dest');

        var done = this.async();
        var destDirectory = path.resolve(grunt.config('download.dest'));
        var jsonFilePath = path.resolve('tasks/json/wsdls.json');
        var wsdls = grunt.file.readJSON(jsonFilePath);

        grunt.file.mkdir(destDirectory);

        async.forEachSeries(wsdls.files, async.apply(processWSDL, destDirectory), function (err) {
            if (err) {
                grunt.log.error(err.message);
                done(false);
            } else {
                done(true);
            }
        });
    });
    
    function processWSDL(destDirectory, wsdl, callback) {
        grunt.log.writeln('Processing ' + wsdl.src + '...');
        grunt.log.writeln('Downloading as ' + wsdl.dest + '...');
        http.get(wsdl.src, function (res) {
            res.pipe(fs.createWriteStream(path.join(destDirectory,wsdl.dest)));
            res.on('end', function () {
                callback();
            });
        }).on('error', function (err) {
            callback(err); 
        });
    }
};
