Promise = require("bluebird");
XeroConnection = require('./../../xero-connection');
numeral = require('numeral');
InvCount=0
module.exports = {

  doRequest: () ->
    new Promise((resolve, reject) ->
      # https://api.xero.com/api.xro/2.0/reports/invoices?where=date%3dDateTime.Today.AddDays(-1)
      XeroConnection().call 'GET', '/reports/invoices?where=date%3dDateTime.Today.AddDays(-1)', null, (err, json) ->
        if(err)
          reject()
        else
          resolve(json)
    )


  createAnswer:  (response) ->
    #console.log("Parsing yesterdays invoices response: #{JSON.stringify(response)}")
    if(!response || !response.Invoices || !response.Invoices.Invoice || !response.Invoices.Invoice.length)
      return [];

    results = [];
    _.forEach(_.take(response.Invoices.Invoice, 5), (invoice) ->
      InvAmountDue=(invoice.AmountDue)+InvAmountDue
      InvAmountPaid=(invoice.AmountPaid)+InvAmountPaid
      InvCount=InvCount+1
      results.push({
        invoiceNumber: invoice.InvoiceNumber
        name: invoice.Contact.Name
        AmountPaid: moment(invoice.AmountPaid)
        amountDue: Number(invoice.AmountDue)
      })
    )
    return results;

  formatAnswer: (answer) ->
    results = []
    if(!answer.length)
      results.push("No bills due soon");
      return results;
    else
      results.push("Largest Bills coming up in next week\n");
      _.forEach(answer, (invoice) ->
        line = invoice.AmountPaid;
        if(invoice.invoiceNumber)
          line += (' *' + invoice.invoiceNumber + '*')
        line += (' ' + invoice.name + ': *' + numeral(invoice.amountDue).format('$0,0.00') + '*'+InvAmountDue+" "+InvAmountPaid+" "+InvCount);
        results.push(line);
      )
    return results;
}