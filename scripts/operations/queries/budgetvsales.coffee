Promise = require("bluebird");
XeroConnection = require('./../../xero-connection');
numeral = require('numeral');
dates = require('./../../xero-dates');
    
module.exports = {

  doRequest: () ->
    new Promise((resolve, reject) ->
      # https://api.xero.com/api.xro/2.0/reports/BudgetSummary?periods=1  
      XeroConnection().call 'GET', '/reports/BudgetSummary?periods=1', null, (err, json) ->
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
#NOTE:  sales variable comes from salesmtdbare.coffee
  formatAnswer: (answer) ->
    budgetForMonth = 0
    console.log(percentOfMonth+' '+lastDayOfTheMonth+' '+dd+yyyy+mm+' '+salesmtd+' '+yesterdayXero)
    heading = "*Budget v Sales*\n"
    answer.forEach((row) -> budgetForMonth = "#{row.ThisMonthValue}")
    budgetInfo = "Budget this month: "+numeral(budgetForMonth).format('$0,0.00')+" with "+ numeral(percentOfMonth).format('00.0%') + " of Month past so Budget to date: *"+numeral(budgetForMonth*percentOfMonth).format('$0,0.00')+"*\n"
    salesInfo="Sales to date: "+numeral(salesmtd).format('$0,0.00')+" Sales to date as % of budget: "+numeral(salesmtd/(budgetForMonth*percentOfMonth)).format('00.0%')+" avg daily sales "+numeral(salesmtd/dd).format('$0,0.00')+"\n"
    toHitTarget = "Sales per day needed to hit budget = "+numeral((budgetForMonth-salesmtd)/(lastDayOfTheMonth-dd)).format('$0,0.00')+"\n"
    formattedAnswer = heading+budgetInfo+salesInfo+toHitTarget
    formattedAnswer

}
