Promise = require("bluebird");
XeroConnection = require('./../../xero-connection');
numeral = require('numeral');

today = new Date
dd = today.getDate()
#The value returned by getMonth is an integer between 0 and 11, referring 0 to January, 1 to February, and so on.
mm = today.getMonth() + 1
yyyy = today.getFullYear()
if dd < 10
  dd = '0' + dd
if mm < 10
  mm = '0' + mm
today = mm + '-' + dd + '-' + yyyy
yd = dd-1
yesterdayXero=yyyy + '-' + mm + '-' + yd


module.exports = {

  doRequest: () ->
    new Promise((resolve, reject) ->
      # https://api.xero.com/api.xro/2.0/reports/ProfitAndLoss?fromDate=yesterdayXero
      XeroConnection().call 'GET', '/reports/ProfitAndLoss?fromDate='+yesterdayXero, null, (err, json) ->
        if(err)
          reject()
        else
          resolve(json)
    )

  createAnswer: (jsonResponse) ->

    console.log("Received: #{JSON.stringify(jsonResponse)}")

    # Filter and map to array of array
    rowsSection = jsonResponse.Response.Reports.Report.Rows.Row.filter((row) -> row.RowType == "Section" && row.Title == "Income" && row.Rows.Row[0].RowType == "Row")[0]
    cellRows = rowsSection.Rows.Row.filter((row) -> row.RowType == "SummaryRow").map((row) -> row.Cells.Cell)
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
    formattedAnswer = "Sales yesterday\n"
    answer.forEach((row) -> formattedAnswer = formattedAnswer + "#{row.KPIName}: #{numeral(row.ThisMonthValue).format('$0,0.00')}\n")
    formattedAnswer

}
