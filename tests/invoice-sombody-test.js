var assert = require('assert');
var invoiceSomebody = require('../js/invoice-somebody');
var FS = require('fs');


describe('InvoiceSomebody operation', function () {

  describe('parsing a json response', function () {
    it('should return invoice id', function () {
      var testResponse = JSON.parse(FS.readFileSync('./tests/testdata/InvoiceSomebody.json'));
      var answer = invoiceSomebody.createAnswer(testResponse);
      assert.equal(answer.Id, "47dde990-5167-48e5-922b-3c9d2ea9c304");
    });
  });

  describe('formatting an answer', function () {
    it('should format properly', function () {
      var answer = {
        Id: "testId"
      };
      var formattedResponse = invoiceSomebody.formatAnswer(answer);
      assert.equal(formattedResponse, "\nInvoice created, view it here: https://go.xero.com/AccountsReceivable/View.aspx?invoiceid=testId");
    });
  });

});
