Promise = require("bluebird");
XeroConnection = require('./../../xero-connection');
numeral = require('numeral');
Operator = require('./../../operator');

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
    budgetForMonth = 0
    salesForMonth=55000
    formattedAnswer = "Budget v Sales NOT YET WORKING\n"+'Budget this month: '
    answer.forEach((row) -> budgetForMonth = "#{row.ThisMonthValue}")
    formattedAnswer += numeral(budgetForMonth).format('$0,0.00')+" with "+ numeral(percentOfMonth).format('00.0%') + " of Month past\n"+'Budget to date: '+numeral(budgetForMonth*percentOfMonth).format('$0,0.00')+"\n"+'Sales to date: '+numeral(salesForMonth).format('$0,0.00')+' Sales to date as % of budget: '+numeral(salesForMonth/(budgetForMonth*percentOfMonth)).format('00.0%')+"\n"
    formattedAnswer

}
