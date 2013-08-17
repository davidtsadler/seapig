module.exports = function(grunt) {
    // Project configuration.
    grunt.initConfig({
        download: {
            dest: 'downloads'
        },

        transform: {
            wsdls: '<%= download.dest %>',
            dest: 'transformed'
        },

        clean: {
            downloads: ['<%= download.dest %>/*'],
            transformed: ['<%= transform.dest %>/*'],
            dist: 'dist/*'
        },

        copy: {
            app: {
                files: [
                    {expand: true, cwd: '<%= transform.dest %>/', src: '**', dest: 'dist/'},
                    {expand: true, cwd: 'app/', src: '**', dest: 'dist/'}
                ]
            }
        },

        connect: {
            transformed: {
                options: {
                    hostname: '*',
                    base: 'dist',
                    keepalive: true
                  }
            }
        },

        jshint: {
            all: ['grunt.js', 'tasks/*.js', 'tasks/json/*.json'],
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
                strict: false 
            }
        },
        
        csslint: {
            src: 'app/css/**/*.css'
        }
    });

    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-contrib-connect');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-csslint');
    grunt.loadTasks('tasks');

    // Default task.
    grunt.registerTask('default', 'jshint');

    grunt.registerTask('build', [
        'clean:dist',
        'download',
        'transform',
        'copy'
    ]);
};
