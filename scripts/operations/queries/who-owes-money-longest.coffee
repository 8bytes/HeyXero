Promise = require("bluebird");
XeroConnection = require('./../../xero-connection');
_ = require('lodash');
numeral = require('numeral');

GetOldInvoices = 'invoices?where=AmountDue%3e0&order=DueDate&page=1'


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
        name: invoice.Name
        outstanding: invoice.AmountDue
        overdue: invoice.DueDate
      })
    );
    return results

  formatAnswer: (answer) ->
    results = []
    if(!answer.length)
      results.push("Nobody does");
    else
      results.push("Oldest invoices (ie. oldest creditor accounts)\n");
      _.forEach(answer, (invoice) ->
        line = '' + invoice.name + " dated "+ invoice.overdue+': *' + numeral(Number(invoice.outstanding)).format('$0,0.00') + '*'
        results.push(line)
      )
    return results;
}
