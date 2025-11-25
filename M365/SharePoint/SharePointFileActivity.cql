(#repo = 3pi_microsoft_teams OR #repo = 3pi_mssharepoint OR #repo = 3pi_microsoft_onedrive) (Vendor.ObjectId="*ikigai.sharepoint.com*" NOT (Vendor.ObjectId="*ikigai.sharepoint.com*" Vendor.AppAccessContext.ClientAppName="Microsoft Teams")) (Vendor.Operation=File* OR Vendor.Operation=Folder*) Vendor.Operation!=FileMalwareDetected Vendor.UserId!="SHAREPOINT\system" Vendor.UserId!=app@sharepoint Vendor.ObjectId!="*ikigai.sharepoint.com/sites/*/SiteAssets/*.jpg" Vendor.UserId!=app@sharepoint Vendor.ObjectId!="*ikigai.sharepoint.com/sites/*/SiteAssets/*.png" Vendor.ObjectId!="*ikigai.sharepoint.com/sites/*/Shared Documents/Forms/AllItems.aspx" Vendor.ObjectId!="*ikigai.sharepoint.com/*/Shared Documents/Forms/AllItems.aspx" Vendor.ObjectId!="*ikigai.sharepoint.com/sites/*/SitePages/Forms/ByAuthor.aspx"| lower("@rawstring", as=@rawstring)
// --------------------------------------------------Modify as per the string you're searching for-----------------------------------------

| @rawstring=*

// --------------------------------------------------Modify as per the string you're searching for-----------------------------------------
| lower("Vendor.UserId", as=Vendor.UserId)
| replace("#ext#@ikigai.onmicrosoft.com", with=" (EXTERNAL)", field=Vendor.UserId, as="ChoppedId1")
| replace("_", with="@", field=ChoppedId1, as="ChoppedId2")
| replace("urn:spo:guest#", with="(EXTERNAL) ", field=ChoppedId2, as="UserId")
| ipLocation(field=Vendor.ClientIP, as=IP)
| groupBy([@timestamp, Vendor.Operation,  UserId, Vendor.SourceFileName, Vendor.SourceFileExtension, Vendor.FileSizeBytes, source.domain, Vendor.ClientIP, IP.country, IP.state, IP.city, Vendor.ObjectId], limit=max)
| sort(field=@timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| table([PacificTime, Vendor.Operation,  UserId, Vendor.SourceFileName, Vendor.SourceFileExtension, Vendor.FileSizeBytes, source.domain, Vendor.ClientIP, IP.country, IP.state, IP.city, Vendor.ObjectId], limit=max)
| rename("Vendor.Operation", as="Operation")
| rename("Vendor.SourceFileName", as="FileName")
| rename("Vendor.SourceFileExtension", as="FileExtension")
| rename("Vendor.FileSizeBytes", as="FileSize")
| rename("source.domain", as="HostName")
| rename("Vendor.ObjectId", as="ObjectID")
| rename("Vendor.ClientIP", as="SourceIP")
| rename("IP.country", as="Country")
| rename("IP.state", as="State")
| rename("IP.city", as="City")
