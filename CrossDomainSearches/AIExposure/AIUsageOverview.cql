(#Vendor=crowdstrike #event_simpleName="DnsRequest" OR #event_simpleName="SuspiciousDnsRequest") OR (#Vendor=cisco #event.module=umbrella Vendor.action=Allowed)
| asn(field=IP4Records, as=ip1)
| rename(field="ip1.org", as=DomaineNetworkProvider)
| DomaineNetworkProvider!="Cisco OpenDNS, LLC"
| regex("^(?<Vendor.Domain>.*?)(?:\\.)?$", field=Vendor.domain, strict=false)
| case {
    DomainName=* | Domain := DomainName;
    Vendor.Domain=* | Domain := Vendor.Domain;
}
| match(file="GenAIKeyword.csv", column="AIDomainName1", field=Domain, mode=glob, strict=true, include=["AIProductName"])
| groupBy([AIProductName], limit=max)
