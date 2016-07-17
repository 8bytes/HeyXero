Promise = require("bluebird");
XeroConnection = require('./../../xero-connection');
numeral = require('numeral');

#get some dates for the queries - should be in a separate script later! from http://www.w3resource.com/coffeescript-#some handlers to make it easier to use dates with the way Xero handles them!
#first get some dates for the queries - based off http://www.w3resource.com/coffeescript-exercises/coffeescript-exercise-2.php

today = new Date
dd = today.getDate()
if dd < 10
  dd = '0' + dd
#The value returned by getMonth is an integer between 0 and 11, referring 0 to January, 1 to February, and so on. 
mm = today.getMonth() + 1
if mm < 10
  mm = '0' + mm
yyyy = today.getFullYear()

# some important accounting dates
lastDayOfTheMonthDate = new Date(yyyy, mm, 0)
lastDayOfTheMonth = lastDayOfTheMonthDate.getDate()             #how many days in the month
today = dd + '-' + mm + '-' + yyyy
yd = dd-1                                                     #yesterday in date format

#now make some formats for Xero to use
todayXero = yyyy + '-' + mm + '-' + dd
yesterdayXero=yyyy + '-' + mm + '-' + yd
endOfMonthXero=yyyy + '-' + mm + '-' + lastDayOfTheMonth
percentOfMonth=dd/lastDayOfTheMonth


module.exports = {

  doRequest: () ->
    new Promise((resolve, reject) ->
      # https://api.xero.com/api.xro/2.0/reports/ProfitAndLoss
      XeroConnection().call 'GET', '/reports/ProfitAndLoss?fromDate='+yesterdayXero+'&toDate='+yesterdayXero, null, (err, json) ->
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
