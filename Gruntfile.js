module.exports = function(grunt) {
    // Project configuration.
    grunt.initConfig({
        clean: {
            downloads: ['<%= download.dest %>/*'],
            transformed: ['<%= transform.dest %>/*'],
            localhost: ['.tmp', 'localhost'],
            dist: ['.tmp', 'dist']
        },

        download: {
            dest: '.tmp/downloads'
        },

        transform: {
            wsdls: '<%= download.dest %>',
            dest: 'transformed'
        },

        htmlmin: {
            dist: {
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

        cssmin: {
            dist: {
                files: [
                    {expand: true, cwd: 'app/', src: '**/*.css', dest: '.tmp/', ext: '.min.css'}
                ],
            }
        },

        copy: {
            localhost: {
                files: [
                    {expand: true, cwd: 'transformed/', src: '**', dest: 'localhost/'},
                    {expand: true, cwd: 'app/', src: ['**', '!css/seapig.css'], dest: 'localhost/'},
                    {
                        expand: true,
                        cwd: 'app/',
                        src: 'css/seapig.css',
                        rename: function (dest, src) {
                            return dest + src.substring(0, src.indexOf('/')) + '/seapig.min.css';
                        },
                        dest: 'localhost/'
                    }
                ]
            },
            dist: {
                files: [
                    {expand: true, cwd: '.tmp/', src: '**', dest: 'dist/'},
                    {expand: true, cwd: 'app/', src: '**', dest: 'dist/'}
                ]
            }
        },

        connect: {
            options: {
                hostname: '*',
                keepalive: true
            },
            localhost: {
                options: {
                    base: 'localhost'
                }
            },
            dist: {
                options: {
                    base: 'dist'
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
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadTasks('tasks');

    // Default task.
    grunt.registerTask('default', ['jshint', 'csslint']);

    grunt.registerTask('build:localhost', [
        'jshint',
        'csslint',
        'clean:localhost',
        'transform',
        'copy:localhost'
    ]);

    grunt.registerTask('build:dist', [
        'jshint',
        'csslint',
        'clean:dist',
        'download',
        'transform',
        'htmlmin',
        'cssmin',
        'copy:dist'
    ]);
};
