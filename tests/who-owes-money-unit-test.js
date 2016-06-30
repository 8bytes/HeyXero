var assert = require('assert');
var FS = require('fs');
var whoOwesMoney = require('../js/operations/queries/who-owes-money');


describe('WhoOwesMoney', function () {

	describe('#createAnswer()', function () {
		it('should handle multiple contacts', function () {
			var json = FS.readFileSync('./tests/data/who-owes-money-multiple.json');
			var answer = whoOwesMoney.createAnswer(JSON.parse(json));
			assert.equal(answer.length, 5);
			assert.equal(answer[0].name, 'Alpha Company Limited')
			assert.equal(answer[0].outstanding, 989.77)
			assert.equal(answer[0].overdue, 989.77)
        });

		it('should handle one contacts', function () {
			var json = FS.readFileSync('./tests/data/who-owes-money-single.json');
			var answer = whoOwesMoney.createAnswer(JSON.parse(json));
			assert.equal(answer.length, 1);
			assert.equal(answer[0].name, 'Lone Wolf Limited')
			assert.equal(answer[0].outstanding, 100.00)
			assert.equal(answer[0].overdue, 10.00)
        });

		it('should handle no contacts', function () {
			assert.equal(whoOwesMoney.createAnswer(null).length, 0);
			assert.equal(whoOwesMoney.createAnswer({}).length, 0);
			assert.equal(whoOwesMoney.createAnswer().length, 0);
			assert.equal(whoOwesMoney.createAnswer({Contacts: []}).length, 0);
        });
    });

	describe('#formatAnswer()', function () {

		function aContact(name, outstanding, overdue){
			return {
				name: name,
				outstanding: outstanding,
				overdue: overdue
			};
		}

		it('should handle multiple contacts', function () {
			var result = whoOwesMoney.formatAnswer([
				aContact('Bob', 1000, 100),
				aContact('Fred', 50, 5),
				aContact('Malthilde', 10)
			]);

			assert.equal(result[0], 'Bob: *$1,000.00* ($100.00 overdue)');
			assert.equal(result[1], 'Fred: *$50.00* ($5.00 overdue)');
			assert.equal(result[2], 'Malthilde: *$10.00*');
        });

		it('should handle one contacts', function () {
			var result = whoOwesMoney.formatAnswer([
				aContact('Bob', 100, 10)
			]);

			assert.equal(result.length, 1);
			assert.equal(result[0], 'Bob: *$100.00* ($10.00 overdue)');
        });

		it('should handle no contacts', function () {
			var result = whoOwesMoney.formatAnswer([]);

			assert.equal(result.length, 1);
			assert.equal(result[0], 'Nobody does');
        });
    });



});
