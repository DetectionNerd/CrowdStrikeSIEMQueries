#repo = mimecast | @dataConnectionID = datcon2 #event.dataset=emailsecurity.url-protect | lower("Vendor.url", as=Vendor.url) | lower("url.domain", as=url.domain)
// --------------------------------------------------Modify as per the string you're searching for-------------------------------------

| (Vendor.url=* OR url.domain=*)

// --------------------------------------------------Modify as per the string you're searching for-------------------------------------
| groupBy([Vendor.timestamp, Vendor.action, Vendor.blockReason, Vendor.urlCategory, Vendor.route, Vendor.recipients, Vendor.subject, Vendor.senderEnvelope, Vendor.senderDomain, Vendor.sourceIp, Vendor.urlCategory, Vendor.url, url.domain, Vendor.analysis, @dataConnectionID], limit=max)
| sort(field=Vendor.timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="Vendor.timestamp", timezone="America/Los_Angeles")
| case {
@dataConnectionID = "datcon2" | MimecastConnector := "MimecastSIEMCG" ;
* }
| table([PacificTime, Vendor.action, Vendor.blockReason, Vendor.urlCategory, Vendor.recipients, Vendor.subject, Vendor.senderEnvelope, Vendor.senderDomain, Vendor.sourceIp, Vendor.url, url.domain, Vendor.analysis, MimecastConnector], limit=max)
| rename("Vendor.route", as="Route")
| rename("Vendor.recipients", as="Recipient")
| rename("Vendor.subject", as="Subject")
| rename("Vendor.senderEnvelope", as="Sender")
| rename("Vendor.action", as="Action")
| rename("Vendor.blockReason", as="BlockReason")
| rename("Vendor.urlCategory", as="UrlCategory")
| rename("Vendor.action", as="Action")
| rename("Vendor.result", as="Result")
| rename("Vendor.fileName", as="FileName")
| rename("Vendor.fileType", as="FileType")
| rename("Vendor.details", as="Details")
| rename("Vendor.actionTriggered", as="Action")
| rename("Vendor.senderDomain", as="SenderDomain")
| rename("Vendor.sourceIp", as="SenderIP")
| rename("Vendor.url", as="URL")
| rename("url.domain", as="Domain")
| rename("Vendor.analysis", as="Analysis")
