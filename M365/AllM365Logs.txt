(#repo = 3pi_microsoft_teams OR #repo = 3pi_mssharepoint OR #repo = 3pi_microsoft_onedrive) | lower("@rawstring", as=@rawstring)
// --------------------------------------------------Modify as per the string you're searching for----------------------------------------------------------

| @rawstring=*

// --------------------------------------------------Modify as per the string you're searching for----------------------------------------------------------
| lower("Vendor.UserId", as=Vendor.UserId)
| replace("#ext#@ikigai.onmicrosoft.com", with=" (EXTERNAL)", field=Vendor.UserId, as="ChoppedId1")
| replace("_", with="@", field=ChoppedId1, as="ChoppedId2")
| replace("urn:spo:guest#", with="(EXTERNAL) ", field=ChoppedId2, as="UserId")
| lower("Vendor.TargetUserOrGroupName", as=Vendor.TargetUserOrGroupName)
| replace("#ext#@ikigai.onmicrosoft.com", with=" (EXTERNAL)", field=Vendor.TargetUserOrGroupName, as="ChoppedId1")
| replace("_", with="@", field=ChoppedId1, as="ChoppedId2")
| replace("urn:spo:guest#", with="(EXTERNAL) ", field=ChoppedId2, as="TargetUser")
| ipLocation(field=Vendor.ClientIP, as=IP)
| groupBy([@timestamp, Vendor.Operation, Vendor.CommunicationType, TargetUser, UserId, source.domain, Vendor.ClientIP, IP.country, IP.state, IP.city,  Vendor.ObjectId, @rawstring], limit=max)
| sort(field=@timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| table([PacificTime, Vendor.Operation, Vendor.CommunicationType, TargetUser, UserId, source.domain, Vendor.ClientIP, IP.country, IP.state, IP.city,  Vendor.ObjectId, @rawstring], limit=max)
| rename("source.domain", as="HostName")
| rename("Vendor.Operation", as="Operation")
| rename("Vendor.ClientIP", as="SourceIP")
| rename("IP.country", as="Country")
| rename("IP.state", as="State")
| rename("IP.city", as="City")
| rename("Vendor.CommunicationType", as="CommunicationType")
