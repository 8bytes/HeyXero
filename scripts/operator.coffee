Promise = require("bluebird");

# All of the operators
WhoOwesMoney = require('./who-owes-money');
HowMuchMoneyDoIHave = require('./how-much-money-do-i-have');
WhatBillsAreComingUp = require('./what-bills-are-coming-up');
InvoiceSomebody = require('./invoice-somebody');

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
