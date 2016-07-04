var assert = require('assert');
var howMuchMoneyDoIHave = require('../js/operations/queries/how-much-money-do-i-have');
var FS = require('fs');


describe('HowMuchMoneyDoIHave operation', function () {

  describe('parsing a json response', function () {
    it('should return accountName and closingBalance', function () {
      var testResponse = JSON.parse(FS.readFileSync('./tests/testdata/HowMuchMoneyDoIHave.json'));
      var cells = howMuchMoneyDoIHave.createAnswer(testResponse);
      assert.equal(cells.length, 3);
      assert.equal(cells[0].accountName, 'Cheque Account');
      assert.equal(cells[0].closingBalance, '28506.98');
      assert.equal(cells[1].accountName, 'Citibank IB');
      assert.equal(cells[1].closingBalance, '98081679751.19');
      assert.equal(cells[2].accountName, 'Mastercard');
      assert.equal(cells[2].closingBalance, '22.25');
    });
  });

  describe('formatting an answer', function () {
    it('should format properly', function () {
      var answer = [
        {
          accountName: 'Bank Account',
          closingBalance: '200.00'
        },
        {
          accountName: 'Checking Account',
          closingBalance: '-4946.33'
        }
      ];
      var formattedResponse = howMuchMoneyDoIHave.formatAnswer(answer);
      assert.equal(formattedResponse, "\nBank Account: $200.00\nChecking Account: -$4,946.33\n");
    });
  });

});
