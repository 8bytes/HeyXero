Xero = require('xero');

module.exports = () ->
		new Xero(XERO_API_CONSUMER_KEY, XERO_API_CONSUMER_SECRET, XERO_API_PRIVATE_KEY)
