module.exports = function(grunt) {
    // Project configuration.
    grunt.initConfig({
        download: {
            dest: 'downloads'
        },

        clean: {
            downloads: '<config:download.dest>'
        },

        lint: {
            all: ['grunt.js', 'tasks/**']
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

    grunt.loadTasks('tasks');

    // Default task.
    grunt.registerTask('default', 'lint');
};
