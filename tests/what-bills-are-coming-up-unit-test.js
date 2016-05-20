var assert = require('assert');
var FS = require('fs');
var whatBillsAreComingUp = require('../js/what-bills-are-coming-up'); 
var moment = require('moment');

describe('WhatBillsAreComingUp', function () {

	describe('#createAnswer()', function () {
		it('should handle multiple invoices', function () {
			var json = FS.readFileSync('./tests/data/what-bills-are-coming-up-multiple.json');
			var answer = whatBillsAreComingUp.createAnswer(JSON.parse(json));
			assert.equal(answer.length, 5);
			assert.equal(answer[0].name, 'Zulu Company Limited');
			assert.equal(answer[0].dueDate.toString(), moment('2015-07-28T00:00:00').toString());
			assert.equal(answer[0].amountDue, 258.75);
        });

		it('should handle one invoices', function () {
			var json = FS.readFileSync('./tests/data/what-bills-are-coming-up-single.json');
			var answer = whatBillsAreComingUp.createAnswer(JSON.parse(json));
			assert.equal(answer.length, 1);
			assert.equal(answer[0].name, 'Whiskey Company Limited');
			assert.equal(answer[0].dueDate.toString(), moment('2014-04-01T00:00:00').toString());
			assert.equal(answer[0].amountDue, 149.50);
        });

		it('should handle no invoices', function () {
			assert.equal(whatBillsAreComingUp.createAnswer(null).length, 0);
			assert.equal(whatBillsAreComingUp.createAnswer({}).length, 0);
			assert.equal(whatBillsAreComingUp.createAnswer().length, 0);
			assert.equal(whatBillsAreComingUp.createAnswer({Contacts: []}).length, 0);
        });
    });

	describe('#formatAnswer()', function () {

		function anInvoice(contactName, invoiceNumber, dueDate, amountDue){
			return {
				name: contactName,
        invoiceNumber: invoiceNumber,
				dueDate: dueDate,
				amountDue: amountDue
			};
		}

		
		it('should handle multiple invoices', function () {
			var result = whatBillsAreComingUp.formatAnswer([
				anInvoice('Bob', 1, moment('2016-09-01'), 1000.00),
				anInvoice('Fred', 2, moment('2016-09-02'), 50.00),
				anInvoice('Malthilde', undefined, moment('2016-09-03'), 12.12)
			]);

			assert.equal(result.length, 3);
			assert.equal(result[0], '01/09/2016 *1* Bob: *$1,000.00*');
			assert.equal(result[1], '02/09/2016 *2* Fred: *$50.00*');
			assert.equal(result[2], '03/09/2016 Malthilde: *$12.12*');
    });

		it('should handle one invoices', function () {
      var result = whatBillsAreComingUp.formatAnswer([
        anInvoice('Malthilde', 3, moment('2016-09-03'), 12.12)
      ]);

      assert.equal(result.length, 1);
      assert.equal(result[0], '03/09/2016 *3* Malthilde: *$12.12*');
    });

		it('should handle no invoices', function () {
      var result = whatBillsAreComingUp.formatAnswer([]);

      assert.equal(result.length, 1);
      assert.equal(result[0], 'No bills due soon');
    });
  });


        
});