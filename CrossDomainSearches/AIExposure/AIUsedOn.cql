(#Vendor=crowdstrike #event_simpleName="DnsRequest" OR #event_simpleName="SuspiciousDnsRequest") OR (#Vendor=cisco #event.module=umbrella Vendor.action=Allowed Vendor.identities!=*ABCD)
| asn(field=IP4Records, as=ip1)
| rename(ip1.org, as="DomaineNetworkProvider")
| DomaineNetworkProvider!="Cisco OpenDNS, LLC"
| regex("^(?<Vendor.Domain>.*?)(?:\\.)?$", field=Vendor.domain, strict=false)
| case {
    DomainName=* | Domain := DomainName;
    Vendor.Domain=* | Domain := Vendor.Domain;
    * | Domain := null;
}
| match(file="GenAIKeyword.csv", column="AIDomainName1", field=Domain, mode=glob, strict=true, include=["AIProductName"])
| regex(",(?<Vendor.HostName>[a-zA-Z0-9-]+)$", field=Vendor.identities, strict=false)
| upper("Vendor.HostName", as="Vendor.HostName")
| upper("ComputerName", as="CrowdsStrike.ComputerName")
| case {
    CrowdsStrike.ComputerName=* | HostName := CrowdsStrike.ComputerName;
    Vendor.HostName=* | HostName := Vendor.HostName;
    * | HostName := null;
}
| groupBy([HostName, AIProductName], limit=max)
| sort(field=[_count, HostName], order=desc, limit=15)
