Promise = require("bluebird");

# All of the operators
WhoOwesMoney = require('./operations/queries/who-owes-money');
HowMuchMoneyDoIHave = require('./operations/queries/how-much-money-do-i-have');
WhatBillsAreComingUp = require('./operations/queries/what-bills-are-coming-up');
salesmtd = require('./operations/queries/salesmtd');
salesYesterday = require('./operations/queries/salesYesterday');
budgetvsales = require('./operations/queries/budgetvsales');
topnewsales = require('./operations/queries/topnewsales');
cashflowmtd = require('./operations/queries/cashflowmtd');
margins = require('./operations/queries/margins');
invoices = require('./operations/queries/invoices');
position = require('./operations/queries/position');
summary = require('./operations/queries/summary');
InvoiceSomebody = require('./operations/commands/invoice-somebody');

standardSingleQuery = (operation) ->
  new Promise((resolve, reject) ->
      # Start the request and get its promise
      promise = operation.doRequest();
      promise.then(
        (xeroResponse) ->
          answer = operation.createAnswer(xeroResponse);
          formattedAnswer = operation.formatAnswer(answer);
          resolve(formattedAnswer);
        () ->
          reject();
      )
    )


module.exports = {

  whoOwesMoney: () ->
    standardSingleQuery(WhoOwesMoney)

  whatBillsAreComingUp: () ->
    standardSingleQuery(WhatBillsAreComingUp)

  howMuchMoneyDoIHave: () ->
    standardSingleQuery(HowMuchMoneyDoIHave)

  salesmtd: () ->
    standardSingleQuery(salesmtd)

  salesYesterday: () ->
    standardSingleQuery(salesYesterday)

  budgetvsales: () ->
    standardSingleQuery(budgetvsales)

  topnewsales: () ->
    standardSingleQuery(topnewsales)

  cashflowmtd: () ->
    standardSingleQuery(cashflowmtd)

  margins: () ->
    standardSingleQuery(margins)

  invoices: () ->
    standardSingleQuery(invoices)

  position: () ->
    standardSingleQuery(position)

  summary: () ->
    standardSingleQuery(summary)

  invoiceSomebody: (contactName, description, unitAmount) ->
    new Promise((resolve, reject) ->
      # Start the request and get its promise
      promise = InvoiceSomebody.doRequest(contactName, description, unitAmount);
      promise.then(
        (xeroResponse) ->
          answer = InvoiceSomebody.createAnswer(xeroResponse);
          formattedAnswer = InvoiceSomebody.formatAnswer(answer);
          resolve(formattedAnswer);
        () ->
          reject();
      )
    )

}
