Promise = require("bluebird");
XeroConnection = require('./../../xero-connection');
_ = require('lodash');
moment = require('moment');
numeral = require('numeral');

GetBillsOverdue = '/invoices?where=Type%3d%22ACCPAY%22+and+AmountDue%3e0&order=DueDate+ASC'

module.exports = {
	doRequest: () ->
		console.log('WhatBillsAreOverdue.doRequest()')
		promise = new Promise((resolve, reject) ->
			XeroConnection().call('GET', GetBillsOverdue, null, (err, json) ->
				if(err)
					console.log("Error making WhatBillOverdue call, error: #{ JSON.stringify(err) }")
					reject()
				else
					resolve(json.Response)
			)
		)
		return promise;

	createAnswer:  (response) ->
		#console.log("Parsing Bills Overdue response: #{JSON.stringify(response)}")
		if(!response || !response.Invoices || !response.Invoices.Invoice || !response.Invoices.Invoice.length)
			return [];

		results = [];
		_.forEach(_.take(response.Invoices.Invoice, 5), (invoice) ->
			results.push({
				invoiceNumber: invoice.InvoiceNumber
				name: invoice.Contact.Name
				dueDate: moment(invoice.DueDate)
				amountDue: Number(invoice.AmountDue)
			})
		)
		return results;

	formatAnswer: (answer) ->
		results = []
		if(!answer.length)
			results.push("No bills are overdue");
			return results;
		else
			results.push("*Bills overdue*\n");
			_.forEach(answer, (invoice) ->
				line = moment(invoice.dueDate).format('DD/MM/YYYY');
				if(invoice.invoiceNumber)
					line += (' ' + invoice.invoiceNumber + '')
				line += (' ' + invoice.name + ': *' + numeral(invoice.amountDue).format('$0,0.00') + '*/n');
				results.push(line);
			)
		return results;
}
