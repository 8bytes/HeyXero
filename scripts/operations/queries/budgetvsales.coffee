Promise = require("bluebird");
XeroConnection = require('./../../xero-connection');
numeral = require('numeral');

module.exports = {

  doRequest: () ->
    new Promise((resolve, reject) ->
      # https://api.xero.com/api.xro/2.0/reports/BudgetSummary?periods=1&timeframe=1
      XeroConnection().call 'GET', '/reports/BudgetSummary', null, (err, json) ->
        if(err)
          reject()
        else
          resolve(json)
    )

  createAnswer: (jsonResponse) ->

    console.log("Received: #{JSON.stringify(jsonResponse)}")

    # Filter and map to array of array
    #rowsSection = jsonResponse.Response.Reports.Report.Rows.Row.filter((row) -> row.RowType == "Section" && row.Rows.Row[0].RowType == "Row")[0]
    cellRows = jsonResponse.Response.Reports.Report.Rows.Rows.Row.filter((row) -> row.RowType == "SummaryRow").map((row) -> row.Cells.Cell)
    if (cellRows.length > 0)
      cellRows.map( (cellRow) ->
        {
          # First cell's Value
          KPIName: cellRow[0].Value
          # Last cell
          ThisMonthValue: cellRow.slice(-1)[0].Value
        }
      )

  formatAnswer: (answer) ->
    formattedAnswer = "Budget v Sales NOT YET WORKING\n"
    answer.forEach((row) -> formattedAnswer = formattedAnswer + "#{row.KPIName}: #{numeral(row.ThisMonthValue).format('0,0.00')}\n")
    formattedAnswer

}
