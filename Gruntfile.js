var grunt = require('grunt');
grunt.loadNpmTasks('grunt-mocha-test');
grunt.loadNpmTasks('grunt-contrib-watch');
grunt.loadNpmTasks('grunt-contrib-coffee');

grunt.initConfig({

	mochaTest: {
		test: {
			options: {
				reporter: 'spec',
				captureFile: 'results.txt', // Optionally capture the reporter output to a file
				quiet: false, // Optionally suppress output to standard out (defaults to false)
				clearRequireCache: true // Optionally clear the require cache before running tests (defaults to false)
			},
			src: ['tests/**/*.js']
		}
	},
	
	watch: {
		js: {
			options: {
				spawn: false,
			},
			files: ['tests/*.js', 'scripts/*.coffee', '**/*.json'],
			tasks: ['coffee', 'test']
		}
	},

    coffee: {
      compile: {
        files: {
      		'js/operator.js': 'scripts/operator.coffee',
      		'js/how-much-money-do-i-have.js': 'scripts/how-much-money-do-i-have.coffee',
      		'js/invoice-somebody.js': 'scripts/invoice-somebody.coffee',
      		'js/what-bills-are-coming-up.js': 'scripts/what-bills-are-coming-up.coffee',
      		'js/what-bills-are-overdue.js': 'scripts/what-bills-are-overdue.coffee',
      		'js/who-is.js': 'scripts/who-is.coffee',
      		'js/who-owes-money.js': 'scripts/who-owes-money.coffee',
      		'js/xeno-reports.js': 'scripts/xeno-reports.coffee',
      		'js/xero-connection.js': 'scripts/xero-connection.coffee',
			}
		}
      }
});

grunt.registerTask('test', ['mochaTest']);
grunt.registerTask('watchTest', ['watch']);
