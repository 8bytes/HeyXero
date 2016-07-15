# Description:
#   Example scripts for you to examine and try out.
#
# Commands:
#   Xero> who owes money - list top contact who owe the most
#   Xero> how much money do I have - lists bank summaries
#   Xero> what bills are coming up - lists upcoming bills
#   Xero> Sales MTD - for the month to date
#   Xero> Sales yesterday - for the last day
#   Xero> Budget - Sales vs. the months budget ***TBA***
#   Xero> Top 5 Sales - list of top 5 sales in last day
#   Xero> Cashflow - summary of cash for month so far
#   Xero> Summary - lists a number of the other queries ***TBA***
#   Xero> Margins - gross profit and net profit margins
#   Xero> Position - Avg debtor and creditor days and cash forecast
#   Xero> Invoices MTD - total number and value of invoices month to date
#   Xero> Invoices Yesterday - number and list of invoices for last day

# Notes:
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md
Operator = require('./operator');
_ = require('lodash');

module.exports = (robot) ->
# Debtors - who owes me money
  robot.respond(/who owes( me)?( the most)?( money)?\??/i, (res) ->
    console.log('about to ask operator, who owes money?')
    Operator.whoOwesMoney().then(
      (result) ->
        res.reply('\n' + _.join(result, '\n'))
      (r) ->
        console.log('Something has gone wrong :( ' + r)
        res.reply("I'm not sure, how about you ask who owes money again later?")
    )
  )
# Bank Balances - of all active accounts
  robot.respond(/how much( money)?( do I have)?( cash)?/i, (res) ->
    console.log('about to ask operator, how much money do i have?')
    Operator.howMuchMoneyDoIHave().then(
      (result) ->
        console.log('Answering!')
        res.reply(result)
      (err) ->
        console.log("Something has gone wrong :( #{err}")
        res.reply("I'm not sure, how about you ask about bank balances again later?")
    )
  )
# Creditors - people I owe money
  robot.respond(/what bills( are)?( coming up)?\??/i, (res) ->
    console.log('about to ask operator, what bills are coming up?')
    Operator.whatBillsAreComingUp().then(
      (result) ->
        res.reply('\n' + _.join(result, '\n'))
      (r) ->
        console.log('Something has gone wrong :( ' + r)
        res.reply("I'm not sure, how about you ask about bills due later?")
    )
  )
# Sales MTD
  robot.respond(/Sales MTD( yesterday)?( revenue)?( turnover)?\??/i, (res) ->
    console.log('about to ask operator, sales month to date?')
    Operator.salesmtd().then(
        (result) ->
            res.reply(result)
        (r) ->
            console.log('Something has gone wrong :( ' + r)
            res.reply("I'm not sure, how about you ask about sales again later?")
    )
  )
# Sales Yesterday
  robot.respond(/Sales yesterday\??/i, (res) ->
    console.log('about to ask operator, sales yesterday?')
    Operator.salesYesterday().then(
        (result) ->
            res.reply(result)
        (r) ->
            console.log('Something has gone wrong :( ' + r)
            res.reply("I'm not sure, how about you ask about sales yesterday again later?")
    )
  )
#BudgetvSales
  robot.respond(/Budget( vs sales)?( performance)?( targets)?\??/i, (res) ->
    console.log('about to ask operator, how are we travelling vs budget?')
    Operator.budgetvsales().then(
        (result) ->
            res.reply(result)
        (r) ->
            console.log('Something has gone wrong :( ' + r)
            res.reply("I'm not sure, how about you ask about budgets again later?")
    )
  )
#Sales Top 5 New Sales
  robot.respond(/top 5( sales)?( who bought)?( the most)?( yesterday)?\??/i, (res) ->
    console.log('about to ask operator, top 5 sales?')
    Operator.topnewsales().then(
        (result) ->
            res.reply(result)
        (r) ->
            console.log('Something has gone wrong :( ' + r)
            res.reply("I'm not sure, how about you ask about Top 5 sales again later?")
    )
  )
#Summary
  robot.respond(/report( summary)?( results)?( daily)?( yesterday)?\??/i, (res) ->
    console.log('about to ask operator for summary?')
    Operator.summary().then(
        (result) ->
            res.reply(result)
        (r) ->
            console.log('Something has gone wrong :( ' + r)
            res.reply("I'm not sure, how about you ask about this again later?")
    )
  )
#cashflowMTD
  robot.respond(/Cashflow( this month)?( MTD)?( Summary)?\??/i, (res) ->
    console.log('about to ask operator, cashflow?')
    Operator.cashflowmtd().then(
        (result) ->
            res.reply(result)
        (r) ->
            console.log('Something has gone wrong :( ' + r)
            res.reply("I'm not sure, how about you ask about cashflow again later?")
    )
  )
#margins
  robot.respond(/Margins( this month)?( MTD)?( Summary)?\??/i, (res) ->
    console.log('about to ask operator, margins?')
    Operator.margins().then(
        (result) ->
            res.reply(result)
        (r) ->
            console.log('Something has gone wrong :( ' + r)
            res.reply("I'm not sure, how about you ask about margins again later?")
    )
  )
#position
  robot.respond(/Position( this month)?( MTD)?( Summary)?\??/i, (res) ->
    console.log('about to ask operator,position ?')
    Operator.position().then(
        (result) ->
            res.reply(result)
        (r) ->
            console.log('Something has gone wrong :( ' + r)
            res.reply("I'm not sure, how about you ask about position again later?")
    )
  )
#invoicesMTD
  robot.respond(/invoices MTD( this month)?( Summary)?\??/i, (res) ->
    console.log('about to ask operator, invoices?')
    Operator.invoicesMTD().then(
        (result) ->
            res.reply(result)
        (r) ->
            console.log('Something has gone wrong :( ' + r)
            res.reply("I'm not sure, how about you ask about invoices again later?")
    )
  )
  #invoicesYesterday
  robot.respond(/invoices yesterday( number)?\??/i, (res) ->
    console.log('about to ask operator, invoices?')
    Operator.invoicesYesterday().then(
        (result) ->
            res.reply(result)
        (r) ->
            console.log('Something has gone wrong :( ' + r)
            res.reply("I'm not sure, how about you ask about invoices again later?")
    )
  )