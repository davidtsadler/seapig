module.exports = function(grunt) {
    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        clean: {
            downloads: '<%= download.dest %>',
            transformed: '<%= transform.dest %>',
            localhost: '.tmp/localhost',
            dist: ['dist', '<%= download.dest %>', '<%= transform.dest %>', '.tmp/htmlmin', '.tmp/cssmin']
        },

        download: {
            dest: '.tmp/downloads'
        },

        transform: {
            wsdls: '<%= download.dest %>',
            dest: '.tmp/transformed',
            version: '<%= pkg.version %>'
        },

        htmlmin: {
            dist: {
                options: {
                    removeComments: true,
                    collapseWhitespace: true
                },
                files: [
                    {expand: true, cwd: '<%= transform.dest %>/', src: '**/*.html', dest: '.tmp/htmlmin/'},
                    {expand: true, cwd: 'app/', src: '**/*.html', dest: '.tmp/htmlmin/'}
                ]
            }
        },

        cssmin: {
            dist: {
                files: [
                    {expand: true, cwd: 'app/', src: '**/*.css', dest: '.tmp/cssmin/', ext: '.css'}
                ],
            }
        },

        copy: {
            localhost: {
                files: [
                    {expand: true, cwd: '<%= transform.dest %>/', src: '**', dest: '.tmp/localhost/'},
                    {expand: true, cwd: 'app/', src: '**', dest: '.tmp/localhost/'}
                ]
            },
            dist: {
                files: [
                    {expand: true, cwd: '.tmp/htmlmin/', src: '**', dest: 'dist/'},
                    {expand: true, cwd: '.tmp/cssmin/', src: '**', dest: 'dist/'},
                    {src: 'app/robots.txt', dest: 'dist/robots.txt'}
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
                    base: '.tmp/localhost'
                }
            },
            dist: {
                options: {
                    base: 'dist'
                }
            }
        },

        jshint: {
            all: ['Gruntfile.js', 'tasks/*.js', 'tasks/json/*.json'],
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
        },
        bump: {
            options: {
                files: ['package.json'],
                updateConfigs: [],
                commit: true,
                commitMessage: 'Release v%VERSION%',
                commitFiles: ['package.json'],
                createTag: true,
                tagName: 'v%VERSION%',
                tagMessage: 'Version %VERSION%',
                push: true,
                pushTo: 'origin',
                gitDescribeOptions: '--tags --always --abbrev=1 --dirty=-d'
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-contrib-connect');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-csslint');
    grunt.loadNpmTasks('grunt-contrib-htmlmin');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-bump');
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
