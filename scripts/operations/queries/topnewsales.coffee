Promise = require("bluebird");
XeroConnection = require('./../../xero-connection');
numeral = require('numeral');

module.exports = {

  doRequest: () ->
    new Promise((resolve, reject) ->
      # https://api.xero.com/api.xro/2.0/reports/CustomerInvoiceReport
      XeroConnection().call 'GET', '/reports/CustomerInvoiceReport', null, (err, json) ->
        if(err)
          reject()
        else
          resolve(json)
    )

  createAnswer: (jsonResponse) ->

    console.log("Received: #{JSON.stringify(jsonResponse)}")

    # Filter and map to array of array
    rowsSection = jsonResponse.Response.Reports.Report.Rows.Row.filter((row) -> row.RowType == "Section" && row.Rows.Row[0].RowType == "Row")[0]
    cellRows = rowsSection.Rows.Row.filter((row) -> row.RowType == "Row").map((row) -> row.Cells.Cell)
    if (cellRows.length > 0)
      cellRows.map( (cellRow) ->
        {
          # Name of the contact/client from invoice
          ClientName: cellRow[3].Value
          # Invoice reference
          Reference: cellRow.slice(-1)[1].Value
           # Invoice Amount
          InvoiceAmount: cellRow.slice(-5)[0].Value
        }
      )

  formatAnswer: (answer) ->
    formattedAnswer = "\n"
    answer.forEach((row) -> formattedAnswer = formattedAnswer + "#{row.ClientName}-#{row.Reference}: #{numeral(row.InvoiceAmount).format('$0,0.00')}\n")
    formattedAnswer

}
