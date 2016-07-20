# HeyXero - simple hubot with Slack and Xero integration

This bot is a result of an internal hackathon in Xero, by Adam Moore (adam.moore@xero.com), Nick Green (nick.green@xero.com), and Scott Potter (scott.potter@xero.com).
It's basic and only has a few commands, but it's a start and we want to get it out there and do more!

Ths fork by Brent Jackson has added a bunch of other commands to extend the work done by Scott and Nick, it should result in the following extra commands working

> what bills are overdue - lists 5 bills most past due date

> Sales MTD - for the month to date

> Sales yesterday - for the last day

> Budget - Sales vs. the months budget

> Top 5 Sales - list of top 5 sales in last day

> Cashflow - summary of cash for month so far

> Margins - gross profit and net profit margins

> Position - Avg debtor and creditor days and cash forecast

> Invoices MTD - total number and value of invoices month to date

> Invoices Yesterday - number and list of invoices for last day

> Summary - lists a number of the other queries 

There is also a cron file but that does not work with the base Heroku setup (use Heroku scheduler instead).  

### Overview

This repo contains a fully working hubot with the slack adapter and custom scripts for making calls to Xero's Public API.
It is based off of michikono's repo (https://github.com/michikono/slackbot-tutorial)
It also uses a public node js client for the Xero API by thallium205 (https://github.com/thallium205/xero)


### Connecting to the Xero public API with a private application

Set up a private application for the Xero Org you'd like to connect the bot to, following the steps here:
https://developer.xero.com/documentation/getting-started/private-applications/

Note the CONSUMER_KEY and CONSUMER_SECRET and private_key.pem created through this process, as they are necessary to set as environment variables for the bot.

### Running the bot Locally

You can start hubot locally by running the following commands in the base directory of this project:

    % export XERO_API_CONSUMER_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    % export XERO_API_CONSUMER_SECRET=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    % export XERO_API_PRIVATE_KEY="$(cat /path/to/private_key.pem)"
    % npm install
    % bin/hubot

You'll see some start up output about where your scripts come from and a
prompt:

    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading adapter shell
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/scripts
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/src/scripts
    Hubot>

Then you can interact with hubot by typing `hubot help`.

    hubot> hubot help

    hubot> animate me <query> - The same thing as `image me`, except adds a few
    convert me <expression> to <units> - Convert expression to given units.
    help - Displays all of the help commands that Hubot knows about.
    ...

You can test out custom commands by typing them in as if you were in a chat room with the bot:

    Hubot> hubot who owes me money?
    Hubot> about to ask operator, who owes money?
    doRequest()
    sending...
    Shell: 
    Kim Dot C: *$6,223.80* ($6,223.80 overdue)
    xero: *$3,387.90* ($3,387.90 overdue)
    TMNT: *$379.50* ($379.50 overdue)
    Shazza's 21st: *$253.00* ($253.00 overdue)
    Club Mate: *$100.00* ($100.00 overdue)

## Testing the bot locally with slack:

Add your slack token as an environment variable, and start hubot with the slack adapter. To find or generate a slack token for this bot, go to your slack team page -> Apps & integrations -> Manage -> And add a hubot configuration. 
  
    export HUBOT_SLACK_TOKEN=YOUR_TOKEN_HERE
    ./bin/hubot -a slack
    
## Deployment

This is a modified set of instructions based on the [instructions on the Hubot wiki](https://github.com/github/hubot/blob/master/docs/deploying/heroku.md).

- Install [heroku toolbelt](https://toolbelt.heroku.com/) if you haven't already.
- `heroku create my-org-xerobot`
- Activate the Hubot service on your ["Team Services"](http://my.slack.com/services/new/hubot) page inside Slack.
- Add the [slack config variables](#adapter-configuration). For example:

        % heroku config:add HUBOT_SLACK_TOKEN=xoxb-1234-5678-91011-00e4dd
        % heroku config:add HEROKU_URL=http://my-org-xerobot.herokuapp.com

- Add the [xero config variables]. For example:

        % heroku config:add XERO_API_CONSUMER_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        % heroku config:add XERO_API_CONSUMER_SECRET=NOTFW35P7RGG1KN96AWKPGWM6JIOUX
        % heroku config:add XERO_API_PRIVATE_KEY="$(cat /path/to/private_key.pem)"

- Deploy and start the bot:

        % git push heroku master
        % heroku ps:scale web=1

- Profit!

## Configuration

This bot uses the following environment variables:

 - `HUBOT_SLACK_TOKEN` - this is the API token for the Slack user you would like to run Hubot under.
 - `XERO_API_CONSUMER_KEY` - the consumer key for the private application registered with the Xero API
 - `XERO_API_CONSUMER_SECRET` - the consumer secret for the private application registered with the Xero API
 - `XERO_API_PRIVATE_KEY` - the private key created while generating the public key to provide to the Xero API for signing.

To add or remove your bot from specific channels or private groups, you can use the /kick and /invite slash commands that are built into Slack.

## Restart the bot

You may want to get comfortable with `heroku logs` and `heroku restart`
if you're having issues.
