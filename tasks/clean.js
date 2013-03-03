module.exports = function (grunt) {
    var fs = require('fs');
    var path = require('path');

    grunt.registerMultiTask('clean', 'Remove all files and folders recursively from the target\'s directory.', function () {
        var files;

        var directory = path.resolve(this.target);

        try {
            files = fs.readdirSync(directory);
            if (files.length > 0) {
                grunt.verbose.writeln('Cleaning ' + files.length + (files.length > 1  ? ' files' : ' file') + ' from ' + directory);
                files.forEach(function (file) {
                    var filePath = path.join(directory, file);
                    grunt.log.debug('Deleting ' + filePath);
                    grunt.file.delete(filePath); 
                });
            } else {
                grunt.verbose.writeln('No files to clean from ' + directory);
            }
        } catch (e) {
            grunt.fatal(e.message);
        }
    });
};
