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
      files: ['tests/*.js', 'scripts/*.coffee', 'scripts/operations/commands/*.coffee', 'scripts/operations/queries/*.coffee', '**/*.json'],
      tasks: ['coffee', 'test']
    }
  },

  coffee: {
    compile: {
      files: {
        'js/operator.js': 'scripts/operator.coffee',
        'js/operations/queries/how-much-money-do-i-have.js': 'scripts/operations/queries/how-much-money-do-i-have.coffee',
        'js/operations/commands/invoice-somebody.js': 'scripts/operations/commands/invoice-somebody.coffee',
        'js/operations/queries/what-bills-are-coming-up.js': 'scripts/operations/queries/what-bills-are-coming-up.coffee',
        'js/operations/queries/what-bills-are-overdue.js': 'scripts/operations/queries/what-bills-are-overdue.coffee',
        'js/operations/queries/who-is.js': 'scripts/operations/queries/who-is.coffee',
        'js/operations/queries/who-owes-money.js': 'scripts/operations/queries/who-owes-money.coffee',
        'js/xero-commands.js': 'scripts/xero-commands.coffee',
        'js/xero-queries.js': 'scripts/xero-queries.coffee',
        'js/xero-connection.js': 'scripts/xero-connection.coffee'
      }
    }
  }
});

grunt.registerTask('test', ['mochaTest']);
grunt.registerTask('watchTest', ['watch']);
