#Vendor=crowdstrike #event_simpleName=MotwWritten
| SourceURL := coalesce(HostUrl, ReferrerUrl)
| SourceURL=*
| ioc:lookup(field=SourceURL, type=url, confidenceThreshold=unverified, strict=true, prefix=URLioc, include=[last_updated, malicious_confidence, labels, published_date, indicator, type])
| default(value="No CrowdStrike intelligence available for this URL", field="URLioc[0].labels")
|formatTime(format="%d %B %Y, %H:%M:%S", as="IOCLastUpdatedURL", field="URLioc[0].last_updated", timezone="America/Los_Angeles")
|formatTime(format="%d %B %Y, %H:%M:%S", as="IOCPublishedURL", field="URLioc[0].published_date", timezone="America/Los_Angeles")
| rename(field="URLioc.detected", as="IOCDetectedURL") | rename(field="URLioc[0].indicator", as="IocURL") | rename(field="URLioc[0].malicious_confidence", as="IOCConfidenceURL") | rename(field="URLioc[0].labels", as="IOCLabelsURL")
| upper("ComputerName", as="HostName")
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
| sort(field=@timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| urlDecode("SourceURL") | rename(_urldecode, as=DecodedSourceURL)
| table([PacificTime, HostName, LocalAddressIP4, UserName, FileName, DecodedSourceURL, IOCDetectedURL, IOCLastUpdatedURL, IocURL, IOCConfidenceURL, IOCLabelsURL, IOCPublishedURL, HostUrl, ReferrerUrl, ZoneIdentifierName, TargetFileName, FilePath, NetworkType, aip, IP.country, IP.state, IP.city, NetworkProvider, AsnIP1, ZoneIdentifier, aid], limit=max)
|rename(field="aip", as="Sensor Public IP")
