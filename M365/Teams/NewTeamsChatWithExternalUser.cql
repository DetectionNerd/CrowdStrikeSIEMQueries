#repo = "3pi_microsoft_teams" Vendor.CommunicationType=OneOnOne Vendor.Operation="ChatCreated" | lower("@rawstring", as=@rawstring)
// --------------------------------------------------Modify as per the string you're searching for------------------------------------------

| @rawstring=*

// --------------------------------------------------Modify as per the string you're searching for-----------------------------------------
| lower("Vendor.Members[0].UPN", as=Vendor.Members[0].UPN)
| replace("#ext#@ikigai.onmicrosoft.com", with=" (EXTERNAL)", field=Vendor.Members[0].UPN, as="ChoppedId1")
| replace("_", with="@", field=ChoppedId1, as="ChoppedId2")
| replace("urn:spo:guest#", with="(EXTERNAL) ", field=ChoppedId2, as="ExternalUser")
| (
ExternalUser!="*@ikigai.com"
)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| ipLocation(field=Vendor.ClientIP, as=IP)
| table([PacificTime, Vendor.Operation, ExternalUser, Vendor.ClientIP, IP.country, IP.state, IP.city, Vendor.Members[1].UPN], limit=max)
| rename("Vendor.Operation", as="Operation")
| rename("Vendor.ClientIP", as="SourceIP")
| rename("IP.country", as="Country")
| rename("IP.state", as="State")
| rename("IP.city", as="City")
| rename("Vendor.Members[1].UPN", as="ikigaiUser")
