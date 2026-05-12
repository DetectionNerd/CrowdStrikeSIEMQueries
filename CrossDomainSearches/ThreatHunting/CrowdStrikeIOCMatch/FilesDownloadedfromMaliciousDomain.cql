#Vendor=crowdstrike #event_simpleName=MotwWritten
| SourceURL := coalesce(HostUrl, ReferrerUrl)
| SourceURL=*
// Normalize input as a URI so we can reliably work with hostnames
| parseUri(SourceURL, defaultBase="https://")
// Extract the registrable/base domain into base_domain (extend TLD list as needed)
| SourceURL.host=/(?<DownloadSourceDomain>[-a-zA-Z0-9]+\.(?:co\.uk|com\.tr|com|net|org|edu|gov|io|co|ai|in|top|xyz))$/
| lower("DownloadSourceDomain", as=DownloadSourceDomain)
| ioc:lookup(field=DownloadSourceDomain, type=domain, confidenceThreshold=unverified, strict=true, prefix=domainioc, include=[last_updated, malicious_confidence, labels, published_date, indicator, type])
| default(value="No CrowdStrike intelligence available for this Domain", field="domainioc[0].labels")
|formatTime(format="%d %B %Y, %H:%M:%S", as="IOCLastUpdatedDomain", field="domainioc[0].last_updated", timezone="America/Los_Angeles")
|formatTime(format="%d %B %Y, %H:%M:%S", as="IOCPublishedDomain", field="domainioc[0].published_date", timezone="America/Los_Angeles")
| rename(field="domainioc.detected", as="IOCDetectedDomain") | rename(field="domainioc[0].indicator", as="IOCDomain") | rename(field="domainioc[0].malicious_confidence", as="IOCConfidenceDomain") | rename(field="domainioc[0].labels", as="IOCLabelsDomain")
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
| table([PacificTime, HostName, LocalAddressIP4, UserName, FileName, DownloadSourceDomain, IOCDetectedDomain, IOCLastUpdatedDomain, IOCConfidenceDomain, IOCLabelsDomain, IOCPublishedDomainL, HostUrl, ReferrerUrl, ZoneIdentifierName, TargetFileName, FilePath, NetworkType, aip, IP.country, IP.state, IP.city, NetworkProvider, AsnIP1, ZoneIdentifier, aid], limit=max)
|rename(field="aip", as="Sensor Public IP")
