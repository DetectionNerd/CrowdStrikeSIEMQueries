#repo = 3pi_microsoft_teams Vendor.Operation=MemberAdded Vendor.UserId!="Microsoft Teams Sync" | lower("@rawstring", as=@rawstring)
// --------------------------------------------------Modify as per the string you're searching for-----------------------------------------

| @rawstring=*

// --------------------------------------------------Modify as per the string you're searching for-----------------------------------------
| lower("Vendor.Members[0].UPN", as=Vendor.Members[0].UPN)
| replace("#ext#@ikigai.onmicrosoft.com", with="", field=Vendor.Members[0].UPN, as="ChoppedId1")
| replace("_", with="@", field=ChoppedId1, as="ChoppedId2")
| replace("urn:spo:guest#", with="", field=ChoppedId2, as="ExternalUser")
| (
ExternalUser!="*@ikigai.com"
)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| table([PacificTime, ExternalUser, Vendor.CommunicationType, Vendor.ItemName, Vendor.UserId], limit=max)
| rename("Vendor.CommunicationType", as="AddedTo")
| rename("Vendor.ItemName", as="Subject")
| rename("Vendor.UserId", as="AddedBy")
