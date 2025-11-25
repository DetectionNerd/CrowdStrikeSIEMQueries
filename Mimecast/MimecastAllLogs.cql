#repo = mimecast | lower("@rawstring", as=@rawstring)
// --------------------------------------------------Modify as per the string you're searching for---------------------------------------

| @rawstring=*gmail.com*

// --------------------------------------------------Modify as per the string you're searching for---------------------------------------
| groupBy([@timestamp, #event.dataset, @dataConnectionID, @rawstring], limit=max)
| case {
@dataConnectionID = "datcon1" | MimecastConnector := "MimecastEvents" ;
@dataConnectionID = "datcon2" | MimecastConnector := "MimecastSIEMCG" ;
* }
| sort(field=@timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| table([PacificTime, #event.dataset, MimecastConnector, @rawstring], limit=max)
