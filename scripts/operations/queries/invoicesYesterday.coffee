Promise = require("bluebird");
XeroConnection = require('./../../xero-connection');
_ = require('lodash');
moment = require('moment');
numeral = require('numeral');

GetInvoicesYesterday = '/invoices?where=Type%3d%22ACCREC%22%26%26date%3dDateTime.Today.AddDays(-3)&order=-total'

module.exports = {
	doRequest: () ->
		console.log('invoicesYesterday.doRequest()')
		promise = new Promise((resolve, reject) ->
			XeroConnection().call('GET', GetInvoicesYesterday, null, (err, json) ->
				if(err)
					console.log("Error making invoice call, error: #{ JSON.stringify(err) }")
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
		_.forEach(_.take(response.Invoices.Invoice, response.Invoices.Invoice.length), (invoice) ->
			results.push({
				invoiceNumber: invoice.InvoiceNumber
				Contactname: invoice.Contact.Name
				Reference: invoice.Reference
				Total: Number(invoice.Total)
				amountPaid: Number(invoice.AmountPaid)
			})
		)
		return results;

	formatAnswer: (answer) ->
		results = []
		if(!answer.length)
			results.push("No invoices yesterday")
			return results
		else
			results.push('*'+answer.length+'* Invoices Yesterday\n')
			TotAmountPaid=0
			TotAmount=0
			_.forEach(answer, (invoice) ->
				TotAmountPaid += invoice.amountPaid
				TotAmount += invoice.Total
				line = ('*'+invoice.Reference+'* by '+invoice.Contactname);
				line += (' *' + numeral(invoice.Total).format('$0,0.00') + '* Paid:' + numeral(invoice.amountPaid).format('$0,0.00') + ' \n');
				results.push(line);
			)
			AvgSizeInvoice = TotAmount/answer.length
			InvoiceSummary = "Total value of invoices: *"+numeral(TotAmount).format('$0,0.00')+"* Paid:"+numeral(TotAmountPaid).format('$0,0.00')+" Average size: "+numeral(AvgSizeInvoice).format('$0,0.00')
			results.push(InvoiceSummary)
		return results
}
