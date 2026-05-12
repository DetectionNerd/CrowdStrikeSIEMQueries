#Vendor=crowdstrike #event_simpleName=MotwWritten
| SourceURL := coalesce(HostUrl, ReferrerUrl)
| match(file="GenAIKeywordsForDownload.csv", column="AIDomainName1", field=SourceURL, mode=glob, strict=true, include=["AIDomainName", "AICompanyName", "AIProductName", "AICategory", "AICountry"])
| upper("ComputerName", as="HostName")
| lower("DomainName", as=DomainName)
| ioc:lookup(field=SourceURL, type=url, confidenceThreshold=unverified, strict=false, prefix=URLioc, include=[last_updated, malicious_confidence, labels, published_date, indicator, type])
| default(value="No CrowdStrike intelligence available for this URL", field="URLioc[0].labels")
|formatTime(format="%d %B %Y, %H:%M:%S", as="IOCLastUpdatedURL", field="URLioc[0].last_updated", timezone="America/Los_Angeles")
|formatTime(format="%d %B %Y, %H:%M:%S", as="IOCPublishedURL", field="URLioc[0].published_date", timezone="America/Los_Angeles")
| rename(field="URLioc.detected", as="IOCDetectedURL") | rename(field="URLioc[0].indicator", as="IocURL") | rename(field="URLioc[0].malicious_confidence", as="IOCConfidenceURL") | rename(field="URLioc[0].labels", as="IOCLabelsURL")
| match(file="NetworkCIDRLookup1.csv", column="CIDR1", field=aip, mode=cidr, strict=false, include=["NetworkType1"]) | rename(field="NetworkType1", as="NetworkType")
| default(value="External", field="NetworkType")
| asn(field=aip, as=ip1)
| rename(field="ip1.org", as="NetworkProvider")
| rename(field="ip1.asn", as="AsnIP1")
| ipLocation(field=aip, as=IP)
| case {
        ZoneIdentifier = "0"  | ZoneIdentifierName := "LOCAL MACHINE" ;
        ZoneIdentifier = "1"  | ZoneIdentifierName := "INTRANET" ;
        ZoneIdentifier = "2"  | ZoneIdentifierName := "TRUSTED SITES" ;
        ZoneIdentifier = "3"  | ZoneIdentifierName := "INTERNET" ;
        ZoneIdentifier = "4"  | ZoneIdentifierName := "RESTRICTED SITES" ;
        * }
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| table([PacificTime, HostName, LocalAddressIP4, UserName, FileName, "AICompanyName", "AIProductName", "AICategory", ReferrerUrl, HostUrl, IocURL, IOCLastUpdatedURL, IOCDetectedURL, IOCConfidenceURL, IOCLabelsURL, IOCPublishedURL, ZoneIdentifierName, TargetFileName, FilePath, NetworkType, aip, IP.country, IP.state, IP.city, NetworkProvider, AsnIP1, ZoneIdentifier, aid], limit=max)
|rename(field="aip", as="Sensor Public IP")
