#repo = mimecast | @dataConnectionID = datcon1 #event.dataset=emailsecurity.dlp
| case {
        @dataConnectionID = "datcon1"  | MimecastConnector := "MimecastEvents" ;
        * }
| groupBy([@timestamp, Vendor.route, Vendor.recipientAddress, Vendor.subject, Vendor.senderAddress, Vendor.policy, Vendor.action, MimecastConnector], limit=max)
| sort(field=@timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| table([PacificTime, Vendor.route, Vendor.recipientAddress, Vendor.subject, Vendor.senderAddress, Vendor.policy, Vendor.action, MimecastConnector], limit=max)
| rename("Vendor.route", as="Route")
| rename("Vendor.recipientAddress", as="Recipient")
| rename("Vendor.subject", as="Subject")
| rename("Vendor.senderAddress", as="Sender")
| rename("Vendor.policy", as="Policy")
| rename("Vendor.action", as="Action")
