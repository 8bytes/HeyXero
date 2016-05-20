Xero = require('xero');
FS = require('fs');

module.exports = () ->
		new Xero("WCX8ZZUPBNEEMEYKCVQMSSBBZIQCUY", "AFJWIDDM7NZOW4L9UERXKB7HAGDUZA", FS.readFileSync('./privatekey-adams-pizza-emporium.pem'))
