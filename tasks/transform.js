module.exports = function(grunt) {
    var path = require('path');
    var exec = require('child_process').exec;
    var async = grunt.util.async;

    grunt.registerTask('transform', 'Transform the downloaded eBay API WSDLs into HTML.', function () {
        grunt.config.requires('transform.wsdls');
        grunt.config.requires('transform.dest');

        var done = this.async();
        var wsdlDirectory = path.resolve(grunt.config('transform.wsdls'));
        var destDirectory = path.resolve(grunt.config('transform.dest'));

        grunt.file.mkdir(destDirectory);

        async.series([
            async.apply(transformServices, destDirectory),
            async.apply(transformCallReference, wsdlDirectory, destDirectory),
            async.apply(transformRequestResponse, wsdlDirectory, destDirectory)
        ], function(err) { 
            if (err) {
                grunt.log.error(err.message);
                done(false);
            } else {
                done(true);
            }
        });
    });

    function transformServices(destDirectory, callback) {
        saxonb('xml/services.xml', 'xsl/services.xsl', '', destDirectory, callback);
    }

    function transformCallReference(wsdlDirectory, destDirectory, callback) {
        saxonb('xml/services.xml', 'xsl/call_reference.xsl', wsdlDirectory, destDirectory, callback);
    }

    function transformRequestResponse(wsdlDirectory, destDirectory, callback) {
        saxonb('xml/services.xml', 'xsl/request_response.xsl', wsdlDirectory, destDirectory, callback);
    }

    function saxonb(xml, xsl, wsdlDirectory, destDirectory, callback) {
        var cmd = 'saxonb-xslt ' + [
            '-ext:on',
            '-s:' + path.resolve(xml),
            '-xsl:' + path.resolve(xsl),
            'wsdlDirectory=' + wsdlDirectory,
            'destDirectory=' + destDirectory
        ].join(' ');

        grunt.log.debug(cmd);

        var child = exec(cmd, function (err, stdout, stderr) {
            callback(err);
        });
    }
};
