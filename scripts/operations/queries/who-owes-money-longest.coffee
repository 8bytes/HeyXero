Promise = require("bluebird");
XeroConnection = require('./../../xero-connection');
_ = require('lodash');
numeral = require('numeral');
moment = require('moment');

GetOldInvoices = '/invoices?where=AmountDue%3e0&order=DueDate&page=1'


module.exports = {

  doRequest: () ->
    console.log('doRequest()')
    promise = new Promise((resolve, reject) ->
      console.log('sending...')
      XeroConnection().call('GET', GetOldInvoices, null, (err, json) ->
        if(err)
          console.log("error calling WhoOwesMoney: #{JSON.stringify(err)}")
          reject()
        else
          resolve(json.Response)
      )
    )
    return promise;

  createAnswer: (response) ->
#console.log("Parsing oldest invoices response: #{JSON.stringify(response)}")
    if(!response || !response.Invoices || !response.Invoices.Invoice || !response.Invoices.Invoice.length)
      return [];

    results = [];
    _.forEach(_.take(response.Invoices.Invoice, 5), (invoice) ->
      results.push({
        name: invoice.Contact.Name
        invoiceNumber: invoice.InvoiceNumber
        Reference: invoice.Reference
        outstanding: Number(invoice.AmountDue)
        overdue: moment(invoice.DueDate)
      })
    );
    return results

  formatAnswer: (answer) ->
    results = []
    if(!answer.length)
      results.push("No old invoices");
    else
      results.push("Oldest invoices (ie. oldest creditor accounts)\n");
      _.forEach(answer, (invoice) ->
        line =invoice.name + ' for '+invoice.Reference+' No:'+invoice.invoiceNumber+" dated "+ moment(invoice.overdue).format('DD/MM/YYYY')+': *' + numeral(Number(invoice.outstanding)).format('$0,0.00') + '*'
        results.push(line)
      )
    return results;
}
