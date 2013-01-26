module.exports = function(grunt) {
    // Project configuration.
    grunt.initConfig({
        lint: {
            all: ['grunt.js']
        },

        jshint: {
            options: {
                curly: true,
                eqeqeq: true,
                immed: true,
                latedef: true,
                newcap: true,
                noarg: true,
                sub: true,
                undef: true,
                boss: true,
                eqnull: true,
                node: true,
                es5: true,
                strict: false 
            }
        }
    });

    // Default task.
    grunt.registerTask('default', 'lint');
};
