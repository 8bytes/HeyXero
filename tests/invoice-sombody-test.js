var assert = require('assert');
var invoiceSomebody = require('../js/operations/commands/invoice-somebody');
var FS = require('fs');


describe('InvoiceSomebody operation', function () {

  describe('parsing a json response', function () {
    it('should return invoice id', function () {
      var testResponse = JSON.parse(FS.readFileSync('./tests/testdata/InvoiceSomebody.json'));
      var answer = invoiceSomebody.createAnswer(testResponse);
      assert.equal(answer.InvoiceId, "93be098b-6bd5-4010-b66a-03e80eb038bb");
    });
  });

  describe('formatting an answer', function () {
    it('should format properly', function () {
      var answer = {
        InvoiceId: "testId"
      };
      var formattedResponse = invoiceSomebody.formatAnswer(answer);
      assert.equal(formattedResponse, "\nInvoice created, view it here: https://go.xero.com/AccountsReceivable/View.aspx?invoiceid=testId");
    });
  });

});
