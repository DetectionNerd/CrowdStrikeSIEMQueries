defineTable(query={
(#Vendor=crowdstrike #event_simpleName="DnsRequest" OR #event_simpleName="SuspiciousDnsRequest") OR (#Vendor=cisco #event.module=umbrella Vendor.action=Allowed Vendor.identities!=*ABCD)
| asn(field=IP4Records, as=ip1)
| rename(field=ip1.org, as="DomaineNetworkProvider")
| DomaineNetworkProvider!="Cisco OpenDNS, LLC"
| regex("^(?<Vendor.Domain>.*?)(?:\\.)?$", field=Vendor.domain, strict=false)
| case {
    DomainName=* | Domain := DomainName;
    Vendor.Domain=* | Domain := Vendor.Domain;
    * | Domain := null;
}
| match(file="GenAIKeywords.csv", column="AIDomainName1", field=Domain, mode=glob, strict=true, include=["AIProductName"])
}, include=[aid, AIProductName, ContextProcessId, Vendor.identities], name="downloaded_files") | #event_simpleName=ProcessRollup2 | match(file="downloaded_files", field=[aid, TargetProcessId], column=[aid, ContextProcessId], include=[AIProductName, Vendor.identities]) | upper("UserName", as=CrowdStrike.UserName)
| regex("(?<Vendor.UserName>[a-zA-Z0-9-]+)\s*\(", field=Vendor.identities, strict=false)
| upper("Vendor.UserName", as="Vendor.UserName")
| case {
    CrowdStrike.UserName=* | UserName := CrowdStrike.UserName;
    Vendor.UserName=* | UserName := Vendor.UserName;
    * | UserName := null;
}
| groupBy([UserName, AIProductName], limit=max)
| sort(field=[_count, UserName], order=desc, limit=15)
