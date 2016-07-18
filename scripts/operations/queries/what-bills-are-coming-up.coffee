Promise = require("bluebird");
XeroConnection = require('./../../xero-connection');
_ = require('lodash');
moment = require('moment');
numeral = require('numeral');

GetBillsComingUp = '/invoices?where=Type%3d%22ACCPAY%22%26%26Status%3d%22AUTHORISED%22%26%26DueDate%3e%3dDateTime.Today%26%26DueDate%3c%3dDateTime.Today.AddDays(7)&order=DueDate&page=1'

module.exports = {
	doRequest: () ->
		console.log('WhatBillsAreComingUp.doRequest()')
		promise = new Promise((resolve, reject) ->
			XeroConnection().call('GET', GetBillsComingUp, null, (err, json) ->
				if(err)
					console.log("Error making WhatBillAreComingUp call, error: #{ JSON.stringify(err) }")
					reject()
				else
					resolve(json.Response)
			)
		)
		return promise;

	createAnswer:  (response) ->
		#console.log("Parsing who owes me money response: #{JSON.stringify(response)}")
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
			results.push("No bills due soon");
			return results;
		else
			results.push("*Largest Bills coming up in next week*\n");
			_.forEach(answer, (invoice) ->
				line = moment(invoice.dueDate).format('DD/MM/YYYY');
				if(invoice.invoiceNumber)
					line += (' ' + invoice.invoiceNumber + '')
				line += (' ' + invoice.name + ': *' + numeral(invoice.amountDue).format('$0,0.00') + '*');
				results.push(line);
			)
		return results;
}
