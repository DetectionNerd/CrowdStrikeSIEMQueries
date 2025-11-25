#repo = mimecast | @dataConnectionID = datcon1 #event.dataset=emailsecurity.ttp Vendor.result=malicious | lower("Vendor.fileName", as=Vendor.fileName) | upper("SHA256Hash", as=SHA256Hash)
// ----------------------------------------------------Modify as per the File Name or SHA256 you're searching for-----------------------

| (Vendor.fileName=* OR SHA256Hash=*)

// ----------------------------------------------------Modify as per the File Name or SHA256 you're searching for-----------------------
| upper("Vendor.fileHash", as=SHA256Hash)
| groupBy([@timestamp, Vendor.result, Vendor.actionTriggered, Vendor.route, Vendor.recipientAddress, Vendor.subject, Vendor.senderAddress, Vendor.fileName, Vendor.fileType, SHA256Hash, Vendor.details, Vendor.actionTriggered, @dataConnectionID], limit=max)
| sort(field=@timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| case {
@dataConnectionID = "datcon1" | MimecastConnector := "MimecastEvents" ;
* }
| table([PacificTime, Vendor.result, Vendor.actionTriggered, Vendor.route, Vendor.recipientAddress, Vendor.subject, Vendor.senderAddress, Vendor.fileName, Vendor.fileType, SHA256Hash, Vendor.details, MimecastConnector], limit=max)
| rename("Vendor.route", as="Route")
| rename("Vendor.recipientAddress", as="Recipient")
| rename("Vendor.subject", as="Subject")
| rename("Vendor.senderAddress", as="Sender")
| rename("Vendor.action", as="Action")
| rename("Vendor.result", as="Result")
| rename("Vendor.senderAddress", as="Sender")
| rename("Vendor.action", as="Action")
| rename("Vendor.result", as="Result")
| rename("Vendor.fileName", as="FileName")
| rename("Vendor.fileType", as="FileType")
| rename("Vendor.details", as="Details")
| rename("Vendor.actionTriggered", as="Action")
