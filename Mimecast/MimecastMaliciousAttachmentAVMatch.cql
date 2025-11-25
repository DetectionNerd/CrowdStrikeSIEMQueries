#repo = mimecast | @dataConnectionID = datcon2 #event.dataset=emailsecurity.av | lower("Vendor.fileName", as=Vendor.fileName) | upper("SHA256Hash", as=SHA256Hash)
// ----------------------------------------------------Modify as per the File Name or SHA256 you're searching for------------------------------

| (Vendor.fileName=* OR SHA256Hash=*)

// ----------------------------------------------------Modify as per the File Name or SHA256 you're searching for------------------------------
| upper("Vendor.md5", as=MD5Hash)
| upper("Vendor.sha1", as=SHA1Hash)
| groupBy([Vendor.timestamp, Vendor.route, Vendor.recipients, Vendor.subject, Vendor.senderEnvelope, Vendor.senderDomain, Vendor.senderIp, Vendor.fileName, Vendor.fileExtension, Vendor.emailSize, Vendor.virusFound, SHA256Hash, MD5Hash, SHA1Hash, @dataConnectionID], limit=max)
| sort(field=Vendor.timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="Vendor.timestamp", timezone="America/Los_Angeles")
| case {
@dataConnectionID = "datcon2" | MimecastConnector := "MimecastSIEMCG" ;
* }
| table([PacificTime, Vendor.route, Vendor.recipients, Vendor.subject, Vendor.senderEnvelope, Vendor.senderDomain, Vendor.senderIp, Vendor.fileName, Vendor.fileExtension, Vendor.emailSize, Vendor.virusFound, SHA256Hash, MD5Hash, SHA1Hash, MimecastConnector], limit=max)
| rename("Vendor.route", as="Route")
| rename("Vendor.recipients", as="Recipient")
| rename("Vendor.subject", as="Subject")
| rename("Vendor.senderEnvelope", as="SenderEnvelope")
| rename("Vendor.senderDomain", as="SenderDomain")
| rename("Vendor.result", as="Result")
| rename("Vendor.senderAddress", as="Sender")
| rename("Vendor.senderIp", as="SenderIP")
| rename("Vendor.fileName", as="FileName")
| rename("Vendor.fileExtension", as="FileExtension")
| rename("Vendor.emailSize", as="EmailSize")
| rename("Vendor.virusFound", as="VirusFound")
