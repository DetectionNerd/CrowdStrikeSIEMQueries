(#Vendor=crowdstrike ((#event_simpleName=DnsRequest OR #event_simpleName=SuspiciousDnsRequest) OR ((#event_simpleName=FirewallRuleIP4Matched OR #event_simpleName=FirewallRuleIP6Matched) RuleAction=1))) OR (#Vendor=cisco #event.module=umbrella Vendor.action=Allowed)
| asn(field=IP4Records, as=ip1)
| rename(ip1.org, as=DomaineNetworkProvider)
| DomaineNetworkProvider!="Cisco OpenDNS, LLC"
| regex("^(?<Vendor.Domain>.*?)(?:\\.)?$", field=Vendor.domain, strict=false)
| case {
    DomainName=* | Domain := DomainName;
    Vendor.Domain=* | Domain := Vendor.Domain;
    DomainNameList=* | Domain := DomainNameList;
    * | Domain := null;
}
| match(file="GenAIKeyword.csv", column="AIDomainName1", field=Domain, mode=glob, strict=true, include=["AIDomainName", "AICompanyName", "AIProductName", "AICategory", "AICountry"])
// Normalize input as a URI so we can reliably work with hostnames
| parseUri(Domain, defaultBase="https://")
// Extract the registrable/base domain into base_domain (extend TLD list as needed)
| Domain.host=/(?<BaseDomain>[-a-zA-Z0-9]+\.(?:co\.uk|com\.tr|com|net|org|edu|gov|io|co|ai|in))$/
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| regex(",(?<Vendor.HostName>[a-zA-Z0-9-]+)$", field=Vendor.identities, strict=false)
| upper("Vendor.HostName", as="Vendor.HostName")
| upper("ComputerName", as="CrowdsStrike.ComputerName")
| case {
    CrowdsStrike.ComputerName=* | HostName := CrowdsStrike.ComputerName;
    Vendor.HostName=* | HostName := Vendor.HostName;
    * | HostName := null;
}
| default(value="ABCD", field="HostName")
| case {
       #Vendor = "crowdstrike"  | LogSource := "CS" ;
       #Vendor = "cisco"  | LogSource := "Umbrella" ;
       }
| case {
    RequestType=* | DnsRequestType := RequestType;
    Vendor.query_type=* | DnsRequestType := Vendor.query_type;
    * | DnsRequestType := null;
}
| case {
    QueryStatus=* | DnsQueryStatus := QueryStatus;
    Vendor.response_code=* | DnsQueryStatus := Vendor.response_code;
    * | DnsQueryStatus := null;
}
| rename(Vendor.action, as=Action)
| default(value="Likely Allowed", field="Action")
| match(file="NetworkCIDRLookup1.csv", column="CIDR1", field=IP4Records, mode=cidr, strict=false, include=["NetworkType1"]) | rename(field="NetworkType1", as="DomainNetworkType")
| case {
    Vendor.external_ip=* | aip := Vendor.external_ip;
    aip=* | aip := aip;
    * | aip := null;
}
| match(file="NetworkCIDRLookup2.csv", column="CIDR2", field=aip, mode=cidr, strict=false, include=["NetworkType2"]) | rename(field="NetworkType2", as="SensorNetworkType")
| default(value="External", field="DomainNetworkType")
| default(value="External", field="SensorNetworkType")
| asn(field=IP4Records, as=ip1)
| rename(field="ip1.asn", as="AsnIP1")
| asn(field=aip, as=ip2)
| rename(ip2.org, as=SensorNetworkProvider)
| rename(field="ip2.asn", as="AsnIP2")
| ipLocation(field=aip, as=SensorIP)
| ioc:lookup(field=BaseDomain, type=domain, confidenceThreshold=unverified, strict=false, prefix=domainioc, include=[last_updated, malicious_confidence, labels, published_date, indicator, type])
| default(value="No CrowdStrike intelligence available for this Domain", field="domainioc[0].labels")
|formatTime(format="%d %B %Y, %H:%M:%S", as="IOCLastUpdatedDomain", field="domainioc[0].last_updated", timezone="America/Los_Angeles")
|formatTime(format="%d %B %Y, %H:%M:%S", as="IOCPublishedDomain", field="domainioc[0].published_date", timezone="America/Los_Angeles")
| rename(field="domainioc.detected", as="IOCDetectedDomain") | rename(field="domainioc[0].indicator", as="IOCDomain") | rename(field="domainioc[0].malicious_confidence", as="IOCConfidenceDomain") | rename(field="domainioc[0].labels", as="IOCLabelsDomain")
| table([PacificTime, LogSource, Action, HostName, Domain, BaseDomain, "AICompanyName", "AIProductName", "AICategory", IOCDetectedDomain, IOCLastUpdatedDomain, IOCDomain, IOCConfidenceDomain, IOCLabelsDomain, IOCPublishedDomain, DnsRequestType, DnsQueryStatus, CNAMERecords, Vendor.categories, DomainNetworkType, IP4Records, DomaineNetworkProvider, AsnIP1, SensorNetworkType, aip, SensorIP.country, SensorIP.state, SensorIP.city, SensorNetworkProvider, AsnIP2, aid], limit=max)
| rename("aip", as="SensorPublicIP")
| rename("IP4Records", as="DestinationIP")
| rename("Vendor.categories", as="Categories")
