# Description:
#   Xero API Keys
#
# Dependencies:
#
# Configuration:
#
# Commands:
#
# Author:
#   Scott Potter

Xero = require('xero');

module.exports = () ->
  new Xero(process.env.XERO_API_CONSUMER_KEY, process.env.XERO_API_CONSUMER_SECRET, process.env.XERO_API_PRIVATE_KEY)
