(#repo = 3pi_microsoft_teams OR #repo = 3pi_mssharepoint OR #repo = 3pi_microsoft_onedrive) Vendor.SiteUrl="https://ikigai.sharepoint.com/sites/ikigaiExternalDataSharing"  (Vendor.Operation=SharingSet OR Vendor.Operation=AddedToSecureLink OR Vendor.Operation=AddedToSharingLink) Vendor.UserId!="SHAREPOINT\system" Vendor.UserId!=app@sharepoint Vendor.TargetUserOrGroupName!=SharingLinks.* | lower("@rawstring", as=@rawstring)
// --------------------------------------------------Modify as per the string you're searching for---------------------------------------

| @rawstring=*

// --------------------------------------------------Modify as per the string you're searching for---------------------------------------
| lower("Vendor.TargetUserOrGroupName", as=Vendor.TargetUserOrGroupName)
| replace("#ext#@ikigai.onmicrosoft.com", with=" (EXTERNAL)", field=Vendor.TargetUserOrGroupName, as="ChoppedId1")
| replace("_", with="@", field=ChoppedId1, as="ChoppedId2")
| replace("urn:spo:guest#", with="(EXTERNAL) ", field=ChoppedId2, as="ExternalRecipient")
| replace("AddedToSecureLink", with="AddedToSharingLink", field=Vendor.Operation, as="Operation")
| (
ExternalRecipient!="*@ikigai.com"
ExternalRecipient!="*@ikigai.com"
)
| ipLocation(field=Vendor.ClientIP, as=IP)
| groupBy([@timestamp, ExternalRecipient, Vendor.UserId, Vendor.ClientIP, IP.country, IP.state, IP.city, Vendor.ItemType, Vendor.SourceFileName, Vendor.SourceFileExtension, Vendor.ObjectId, Operation], limit=max)
| sort(field=@timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| upper("ExternalRecipient", as=ExternalRecipient)
| (
ExternalRecipient=*@GMAIL.COM OR
ExternalRecipient=*@OUTLOOK.COM OR
ExternalRecipient=*@YAHOO.COM OR
ExternalRecipient=*@HOTMAIL.COM OR
ExternalRecipient=*@AOL.COM OR
ExternalRecipient=*@YMAIL.COM OR
ExternalRecipient=*@MAIL.COM OR
ExternalRecipient=*@GMX.COM
)
 ExternalRecipient!=IKIGAI@GMAIL.COM
| table([PacificTime, ExternalRecipient, Vendor.UserId, Vendor.ClientIP, IP.country, IP.state, IP.city, Vendor.ItemType, Vendor.SourceFileName, Vendor.SourceFileExtension, Vendor.ObjectId, Operation], limit=max)
| rename("Vendor.UserId", as="Sender")
| rename("Vendor.ItemType", as="ItemType")
| rename("Vendor.ObjectId", as="ObjectId")
| rename("Vendor.ClientIP", as="SourceIP")
| rename("IP.country", as="Country")
| rename("IP.state", as="State")
| rename("IP.city", as="City")
| rename("Vendor.SourceFileName", as="FileName")
| rename("Vendor.SourceFileExtension", as="FileExtension")
