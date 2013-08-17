module.exports = function(grunt) {
    // Project configuration.
    grunt.initConfig({
        clean: {
            downloads: ['<%= download.dest %>/*'],
            transformed: ['<%= transform.dest %>/*'],
            dist: ['.tmp', 'dist']
        },

        download: {
            dest: 'downloads'
        },

        transform: {
            wsdls: '<%= download.dest %>',
            dest: 'transformed'
        },

        htmlmin: {
            app: {
                options: {
                    removeComments: true,
                    collapseWhitespace: true
                },
                files: [
                    {expand: true, cwd: '<%= transform.dest %>/', src: '**/*.html', dest: '.tmp/'},
                    {expand: true, cwd: 'app/', src: '**/*.html', dest: '.tmp/'}
                ]
            }
        },

        copy: {
            app: {
                files: [
                    {expand: true, cwd: '.tmp/', src: '**', dest: 'dist/'},
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
    grunt.loadNpmTasks('grunt-contrib-htmlmin');
    grunt.loadTasks('tasks');

    // Default task.
    grunt.registerTask('default', ['jshint', 'csslint']);

    grunt.registerTask('build', [
        'jshint',
        'csslint',
        'clean:dist',
        'download',
        'transform',
        'htmlmin',
        'copy'
    ]);
};
