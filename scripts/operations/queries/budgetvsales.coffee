Promise = require("bluebird");
XeroConnection = require('./../../xero-connection');
numeral = require('numeral');

#get some dates for the queries - should be in a separate script later! from http://www.w3resource.com/coffeescript-exercises/coffeescript-exercise-2.php
today = new Date
dd = today.getDate()
#The value returned by getMonth is an integer between 0 and 11, referring 0 to January, 1 to February, and so on. 
mm = today.getMonth() + 1
yyyy = today.getFullYear()
lastDayOfTheMonthDate = new Date(yyyy, mm, 0)
lastDayOfTheMonth=lastDayOfTheMonthDate.getDate()
if dd < 10
  dd = '0' + dd
if mm < 10
  mm = '0' + mm
today = dd + '-' + mm + '-' + yyyy
#now make some formats for Xero to use
todayXero = yyyy + '-' + mm + '-' + dd
yd = dd-1
yesterdayXero=yyyy + '-' + mm + '-' + yd
percentOfMonth=dd/lastDayOfTheMonth

module.exports = {

  doRequest: () ->
    new Promise((resolve, reject) ->
      # https://api.xero.com/api.xro/2.0/reports/BudgetSummary?periods=1  ***NOTE remove date filterlater when working
      XeroConnection().call 'GET', '/reports/BudgetSummary?periods=1&date=2016-06-13', null, (err, json) ->
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
    formattedAnswer = "Budget v Sales NOT YET WORKING\n"+'Budget this month: '+dd+"\n"+ numeral(percentOfMonth).format('00.00%') + "% of Month past\n"+'Budget to date: '+(dd*percentOfMonth)+"\n"+'Sales to date: '+dd+"\n"+'Sales to date as % of budget: '+dd+"\n"
    answer.forEach((row) -> formattedAnswer = formattedAnswer + "#{row.KPIName}: #{numeral(row.ThisMonthValue).format('$0,0.00')}\n")
    formattedAnswer

}
