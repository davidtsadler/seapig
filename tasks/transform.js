module.exports = function(grunt) {
    var path = require('path');
    var exec = require('child_process').exec;
    var async = grunt.util.async;

    grunt.registerTask('transform', 'Transform the downloaded eBay API WSDLs into HTML.', function () {
        grunt.config.requires('transform.wsdls');
        grunt.config.requires('transform.dest');
        grunt.config.requires('transform.version');

        var done = this.async();
        var wsdlDirectory = path.resolve(grunt.config('transform.wsdls'));
        var destDirectory = path.resolve(grunt.config('transform.dest'));
        var version = grunt.config('transform.version');

        grunt.file.mkdir(destDirectory);

        async.series([
            async.apply(transformServices, destDirectory, version),
            async.apply(transformCallReference, wsdlDirectory, destDirectory, version),
            async.apply(transformRequestResponse, wsdlDirectory, destDirectory, version),
            async.apply(transformIntoSitemap, wsdlDirectory, destDirectory, version)
        ], function(err) { 
            if (err) {
                grunt.log.error(err.message);
                done(false);
            } else {
                done(true);
            }
        });
    });

    function transformServices(destDirectory, version, callback) {
        saxonb('xml/services.xml', 'xsl/services.xsl', '', destDirectory, version, callback);
    }

    function transformCallReference(wsdlDirectory, destDirectory, version, callback) {
        saxonb('xml/services.xml', 'xsl/call_reference.xsl', wsdlDirectory, destDirectory, version, callback);
    }

    function transformRequestResponse(wsdlDirectory, destDirectory, version, callback) {
        saxonb('xml/services.xml', 'xsl/request_response.xsl', wsdlDirectory, destDirectory, version, callback);
    }

    function transformIntoSitemap(wsdlDirectory, destDirectory, version, callback) {
        saxonb('xml/services.xml', 'xsl/sitemap.xsl', wsdlDirectory, destDirectory, version, callback);
    }

    function saxonb(xml, xsl, wsdlDirectory, destDirectory, version, callback) {
        var cmd = 'saxonb-xslt ' + [
            '-ext:on',
            '-s:' + path.resolve(xml),
            '-xsl:' + path.resolve(xsl),
            'wsdlDirectory=' + wsdlDirectory,
            'destDirectory=' + destDirectory,
            'version=' + version,
        ].join(' ');

        grunt.log.debug(cmd);

        var child = exec(cmd, function (err, stdout, stderr) {
            callback(err);
        });
    }
};
