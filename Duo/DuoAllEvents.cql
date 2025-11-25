#repo = cisco_duo_mfa | lower("@rawstring", as=@rawstring)
// --------------------------------------------------Modify as per the string you're searching for------------------------------------------

| @rawstring=*

// --------------------------------------------------Modify as per the string you're searching for------------------------------------------
| groupBy([@timestamp, #event.dataset, Vendor.user.name, Vendor.email, @rawstring], limit=max)
| sort(field=@timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| table([PacificTime, #event.dataset, Vendor.user.name, Vendor.email, @rawstring], limit=max)
| rename("#event.dataset", as="EventType")
| rename("@rawstring", as="RawLog")
