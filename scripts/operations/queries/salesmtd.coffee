Promise = require("bluebird");
XeroConnection = require('./../../xero-connection');
numeral = require('numeral');

module.exports = {

  doRequest: () ->
    new Promise((resolve, reject) ->
      # https://api.xero.com/api.xro/2.0/reports/ProfitAndLoss
      XeroConnection().call 'GET', '/reports/ProfitAndLoss', null, (err, json) ->
        if(err)
          reject()
        else
          resolve(json)
    )

  createAnswer: (jsonResponse) ->

    console.log("Received: #{JSON.stringify(jsonResponse)}")

    # Filter and map to array of array
    rowsSection = jsonResponse.Response.Reports.Report.Rows.Row.filter((row) -> row.RowType == "Section" && row.Rows.Row[0].RowType == "Row")[0]
    rowsSummary = rowsSection.Rows.Row.filter((row) -> row.RowType == "SummaryRow").map((row) -> row.Cells.Cell)
#cellRows = rowsSection.Rows.Row.filter((row) -> row.RowType == "Row").map((row) -> row.Cells.Cell)
    if (rowsSummary.length > 0)
      rowsSummary.map( (SummRow) ->
        {
          # First cell's Value
          accountName: SummRow[0].Value
          # Last cell
          closingBalance: SummRow.slice(-1)[0].Value
        }
      )

  formatAnswer: (answer) ->
    formattedAnswer = "\n"
    answer.forEach((row) -> formattedAnswer = formattedAnswer + "#{row.accountName}: #{numeral(row.closingBalance).format('$0,0.00')}\n")
    formattedAnswer

}
