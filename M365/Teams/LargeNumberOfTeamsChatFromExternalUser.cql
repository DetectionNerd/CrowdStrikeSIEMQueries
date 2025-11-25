#repo = "3pi_microsoft_teams" Vendor.CommunicationType=OneOnOne Vendor.Operation="ChatCreated" | lower("@rawstring", as=@rawstring)
// --------------------------------------------------Modify as per the string you're searching for------------------------------------------

| @rawstring=*

// --------------------------------------------------Modify as per the string you're searching for------------------------------------------
| lower("Vendor.Members[0].UPN", as=Vendor.Members[0].UPN)
| replace("#ext#@ikigai.onmicrosoft.com", with=" (EXTERNAL)", field=Vendor.Members[0].UPN, as="ChoppedId1")
| replace("_", with="@", field=ChoppedId1, as="ChoppedId2")
| replace("urn:spo:guest#", with="(EXTERNAL) ", field=ChoppedId2, as="ExternalUser")
| (
ExternalUser!="*@ikigai.com"
)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| replace("#EXT#@ikigai.onmicrosoft.com", with="", field=Vendor.Members[0].UPN, as="UPN")
| replace("_", with="@", field=UPN, as="ExternalUser")
| ipLocation(field=Vendor.ClientIP, as=IP)
| groupBy(ExternalUser, function=([count(Vendor.Members[1].UPN, distinct=true, as=RecipientCount), collect(Vendor.Members[1].UPN)]))
| RecipientCount>3
| table([ExternalUser, Vendor.Members[1].UPN, RecipientCount])
| rename("Vendor.Operation", as="Operation")
| rename("Vendor.ClientIP", as="SourceIP")
| rename("IP.country", as="Country")
| rename("IP.state", as="State")
| rename("IP.city", as="City")
| rename("Vendor.Members[1].UPN", as="Recipients")
