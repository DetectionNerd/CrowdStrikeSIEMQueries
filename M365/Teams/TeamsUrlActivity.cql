(#repo = 3pi_microsoft_teams) (Vendor.Operation=MessageCreatedHasLink OR Vendor.Operation=MessageEditedHasLink) | lower("@rawstring", as=@rawstring)
// --------------------------------------------------Modify as per the string you're searching for------------------------------------------

| @rawstring=*

// --------------------------------------------------Modify as per the string you're searching for------------------------------------------
| (
Vendor.MessageURLs[0]!="*us-api.asm.skype.com*"
Vendor.MessageURLs[0]!="*statics.teams.cdn.office.net*"
Vendor.MessageURLs[0]!="*teams.microsoft.com*"
Vendor.MessageURLs[0]!="*giphy.com*"
Vendor.MessageURLs[0]!="*ikigai-my.sharepoint.com*"
Vendor.MessageURLs[0]!="*ikigai.sharepoint.com*"
Vendor.MessageURLs[0]!="*ikigai.com*"
Vendor.MessageURLs[0]!="*crowdstrike.com*"
)
| lower("Vendor.UserId", as=Vendor.UserId)
| replace("#ext#@ikigai.onmicrosoft.com", with=" (EXTERNAL)", field=Vendor.UserId, as="ChoppedId1")
| replace("_", with="@", field=ChoppedId1, as="ChoppedId2")
| replace("urn:spo:guest#", with="(EXTERNAL) ", field=ChoppedId2, as="UserId")
| ipLocation(field=Vendor.ClientIP, as=IP)
| groupBy([@timestamp, Vendor.Operation, Vendor.CommunicationType, Vendor.TeamName, Vendor.ChannelName, Vendor.ChatName, source.domain, UserId, Vendor.ClientIP, IP.country, IP.state, IP.city, Vendor.MessageURLs[0], Vendor.MessageURLs[1], Vendor.MessageURLs[2], Vendor.MessageURLs[3], Vendor.MessageURLs[4], Vendor.MessageURLs[5], MessageURLs[6], MessageURLs[7], MessageURLs[8], MessageURLs[9], MessageURLs[10]], limit=max)
| sort(field=@timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| table([PacificTime, Vendor.Operation, Vendor.CommunicationType, Vendor.TeamName, Vendor.ChannelName, Vendor.ChatName, source.domain, UserId, Vendor.ClientIP, IP.country, IP.state, IP.city, Vendor.MessageURLs[0], Vendor.MessageURLs[1], Vendor.MessageURLs[2], Vendor.MessageURLs[3], Vendor.MessageURLs[4], Vendor.MessageURLs[5], MessageURLs[6], MessageURLs[7], MessageURLs[8], MessageURLs[9], MessageURLs[10]], limit=max)
| rename("Vendor.Operation", as="Operation")
| rename("Vendor.CommunicationType", as="CommunicationType")
| rename("Vendor.TeamName", as="TeamName")
| rename("Vendor.ChannelName", as="ChannelName")
| rename("Vendor.ChatName", as="ChatName")
| rename("source.domain", as="HostName")
| rename("Vendor.ClientIP", as="SourceIP")
| rename("IP.country", as="Country")
| rename("IP.state", as="State")
| rename("IP.city", as="City")
| rename("Vendor.MessageURLs[0]", as="URL")
| rename("Vendor.MessageURLs[1]", as="URL1")
| rename("Vendor.MessageURLs[2]", as="URL2")
| rename("Vendor.MessageURLs[3]", as="URL3")
| rename("Vendor.MessageURLs[4]", as="URL4")
| rename("Vendor.MessageURLs[5]", as="URL5")
| rename("Vendor.MessageURLs[6]", as="URL6")
| rename("Vendor.MessageURLs[7]", as="URL7")
| rename("Vendor.MessageURLs[8]", as="URL8")
| rename("Vendor.MessageURLs[9]", as="URL9")
| rename("Vendor.MessageURLs[10]", as="URL10")
