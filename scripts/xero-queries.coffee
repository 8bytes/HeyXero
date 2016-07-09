# Description:
#   Example scripts for you to examine and try out.
#
# Commands:
#   who owes money - list top contact who owe the most
#   how much money do I have - lists bank summaries
#   what bills are coming up - lists upcoming bills
#   Sales - for the last day and month to date
#   Budget - Sales vs. the months budget
#   Top 5 Sales - list of top 5 sales in last day
#   Cashflow - summary of cash for month so far
#
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
  robot.respond(/Sales( MTD)?( yesterday)?( revenue)?( turnover)?\??/i, (res) ->
    console.log('about to ask operator, sales month to date?')
    Operator.salesmtd().then(
        (result) ->
            res.reply(result)
        (r) ->
            console.log('Something has gone wrong :( ' + r)
            res.reply("I'm not sure, how about you ask about sales again later?")
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