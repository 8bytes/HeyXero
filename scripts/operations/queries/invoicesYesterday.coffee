Promise = require("bluebird");
XeroConnection = require('./../../xero-connection');
_ = require('lodash');
moment = require('moment');
numeral = require('numeral');

GetInvoicesYesterday = '/invoices?where=date%3dDateTime.Today.AddDays(-1)&order=-amountdue'

module.exports = {
	doRequest: () ->
		console.log('topnewsales.doRequest()')
		promise = new Promise((resolve, reject) ->
			XeroConnection().call('GET', GetInvoicesYesterday, null, (err, json) ->
				if(err)
					console.log("Error making topnewsales call, error: #{ JSON.stringify(err) }")
					reject()
				else
					resolve(json.Response)
			)
		)
		return promise;

	createAnswer:  (response) ->
		#console.log("Parsing invoices response: #{JSON.stringify(response)}")
		if(!response || !response.Invoices || !response.Invoices.Invoice || !response.Invoices.Invoice.length)
			return [];

		results = [];
		_.forEach(_.take(response.Invoices.Invoice, 5), (invoice) ->
			results.push({
				invoiceNumber: invoice.InvoiceNumber
				Contactname: invoice.Contact.Name
				dueDate: moment(invoice.DueDate)
				amountDue: Number(invoice.AmountDue)
				amountTotal +=amountDue
			})
		)
		return results;

	formatAnswer: (answer) ->
		results = []
		if(!answer.length)
			results.push("No invoices yesterday");
			return results;
		else
			results.push("Invoices Yesterday\n");
			_.forEach(answer, (invoice) ->
				line = ('*' + invoice.Contactname + '*');
				if(invoice.invoiceNumber)
					line += (' ' + invoice.invoiceNumber + ' ')
				line += (' ' + numeral(invoice.amountDue).format('$0,0.00') + ' \n');
				results.push(line);
			)
		return results;
}
