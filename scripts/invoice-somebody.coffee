Promise = require("bluebird");
XeroConnection = require('./xero-connection');

module.exports = {

  doRequest: (contactName, description, unitAmount) ->
    new Promise((resolve, reject) ->
      # https://api.xero.com/api.xro/2.0/reports/BankSummary
      body = [
        {
          Type: "ACCREC"
          Contact: {
            Name: contactName
          }
          LineItems: [
            {
              Description: description
              UnitAmount: unitAmount
            }
          ]
        }
      ]
#      body = """
#        <Invoices>
#          <Invoice>
#            <Type>ACCREC</Type>
#            <Contact>
#              <Name>#{contactName}</Name>
#            </Contact>
#            <LineItems>
#              <LineItem>
#                <Description>#{description}</Description>
#                <UnitAmount>#{unitAmount}</UnitAmount>
#              </LineItem>
#            </LineItems>
#          </Invoice>
#        </Invoices>
#      """
      XeroConnection().call 'POST', '/Invoices', body, (err, json) ->
        if(err)
          reject()
        else
          resolve(json)
    )

  createAnswer: (jsonResponse) ->
    console.log("Creating answer for: #{JSON.stringify(jsonResponse)}")
    {
      Id: jsonResponse.Response.Id
    }

  formatAnswer: (answer) ->
    "\nInvoice created, view it here: https://go.xero.com/AccountsReceivable/View.aspx?invoiceid=#{answer.Id}"

}
