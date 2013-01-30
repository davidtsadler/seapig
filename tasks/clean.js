module.exports = function (grunt) {
    var fs = require('fs');
    var path = require('path');

    grunt.registerMultiTask('clean', 'Remove all files from the target\'s directory.', function () {
        var files;

        var directory = path.resolve(this.target);

        try {
            files = fs.readdirSync(directory);
            if (files.length > 0) {
                grunt.verbose.writeln('Cleaning ' + files.length + (files.length > 1  ? ' files' : ' file') + ' from ' + directory);
                files.forEach(function (file) {
                    var filePath = path.join(directory, file);
                    if (fs.statSync(filePath).isFile()) {
                        fs.unlinkSync(filePath);
                        grunt.verbose.writeln(file);
                    } else {
                        grunt.verbose.writeln('Skipping directory ' + file);
                    }
                });
            } else {
                grunt.verbose.writeln('No files to clean from ' + directory);
            }
        } catch (e) {
            grunt.fatal(e.message);
        }
    });
};
