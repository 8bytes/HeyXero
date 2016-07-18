# Description:
#   Example scripts for you to examine and try out.
#
# Commands:
#   hubot Xero> who owes money - list top contact who owe the most
#   hubot Xero> how much money do I have - lists bank summaries
#   hubot Xero> what bills are coming up - lists upcoming bills
#   hubot Xero> Sales MTD - for the month to date
#   hubot Xero> Sales yesterday - for the last day
#   hubot Xero> Budget - Sales vs. the months budget ***TBA***
#   hubot Xero> Top 5 Sales - list of top 5 sales in last day
#   hubot Xero> Cashflow - summary of cash for month so far
#   hubot Xero> Margins - gross profit and net profit margins
#   hubot Xero> Position - Avg debtor and creditor days and cash forecast
#   hubot Xero> Invoices MTD - total number and value of invoices month to date
#   hubot Xero> Invoices Yesterday - number and list of invoices for last day
#   hubot Xero> Summary - lists a number of the other queries 

# Notes:
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

Operator = require('./operator');
_ = require('lodash');

module.exports = (robot) ->
#Summary - comment out ones you don't want in the report!
  robot.respond(/summary|report|results|status( yesterday)?\??/i, (res) ->
    console.log('about to ask operator for summary?')
    res.reply("*Summary*") 
    robot.emit "whatbills", (res)
    robot.emit "Top5", (res)
    robot.emit "invoicesmtd", (res)
    robot.emit "invoicesyesterday", (res)
    robot.emit "salesyesterday", (res)
    robot.emit "salesmtd", (res)
    robot.emit "whoowes", (res)
    robot.emit "bankbalances", (res)
#    robot.emit "budget", (res)
#    robot.emit "cashflow", (res)
#    robot.emit "margins", (res)
#    robot.emit "position", (res)
  )
# Debtors - who owes me money
  robot.respond(/who owes( me)?( the most)?( money)?\??/i, (res) ->
    console.log('about to ask event, who owes money?')
    robot.emit 'whoowes', (res)
  )
# Debtors - who owes me money event
  robot.on 'whoowes', (res) ->
    console.log('about to ask operator, who owes money?')
    Operator.whoOwesMoney().then(
      (result) ->
        res.reply('\n' + _.join(result, '\n'))
      (r) ->
        console.log('Something has gone wrong :( ' + r)
        res.reply("I'm not sure, how about you ask who owes money again later?")
    )
  
# Bank Balances - of all active accounts
  robot.respond(/how much( money)?( do I have)?( cash)?/i, (res) ->
    console.log('about to ask event, how much money do i have?')
    robot.emit 'bankbalances', (res)
  )
# Bank Balances - of all active accounts event
  robot.on "bankbalances", (res) ->
    console.log('about to ask operator, how much money do i have?')
    Operator.howMuchMoneyDoIHave().then(
      (result) ->
        console.log('Answering!')
        res.reply(result)
      (err) ->
        console.log("Something has gone wrong :( #{err}")
        res.reply("I'm not sure, how about you ask about bank balances again later?")
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
    robot.emit "margins", (res)
    )

#margins from the event
  robot.on 'margins', (res) ->
    console.log('about to ask operator, margins from event?')
    Operator.margins().then(
        (result) ->
            res.reply(result)
        (r) ->
            console.log('Something has gone wrong :( ' + r)
            res.reply("I'm not sure, how about you ask about margins again later?")
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