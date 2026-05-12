(#Vendor=crowdstrike ((#event_simpleName=DnsRequest OR #event_simpleName=SuspiciousDnsRequest) OR ((#event_simpleName=FirewallRuleIP4Matched OR #event_simpleName=FirewallRuleIP6Matched)))) OR (#Vendor=cisco #event.module=umbrella)
| regex("^(?<Vendor.Domain>.*?)(?:\\.)?$", field=Vendor.domain, strict=false)
| case {
    DomainName=* | Domain := DomainName;
    Vendor.Domain=* | Domain := Vendor.Domain;
    DomainNameList=* | Domain := DomainNameList;
    * | Domain := null;
}
| ioc:lookup(field=Domain, type=domain, confidenceThreshold=unverified, strict=true, prefix=domainioc, include=[malicious_confidence, labels])
| default(value="No CrowdStrike intelligence available for this Domain", field="domainioc[0].labels")
| rename(field="domainioc[0].malicious_confidence", as="IOCConfidenceDomain") | rename(field="domainioc[0].labels", as="IOCLabelsDomain")
| regex(",(?<Vendor.HostName>[a-zA-Z0-9-]+)$", field=Vendor.identities, strict=false)
| upper("Vendor.HostName", as="Vendor.HostName")
| upper("ComputerName", as="CrowdsStrike.ComputerName")
| case {
    CrowdsStrike.ComputerName=* | HostName := CrowdsStrike.ComputerName;
    Vendor.HostName=* | HostName := Vendor.HostName;
    * | HostName := null;
}
| default(value="ABCD", field="HostName")
| asn(field=IP4Records, as=ip1)
| rename(field="ip1.org", as="DomaineNetworkProvider")
| case {
    RuleAction = 1 | Action := Allowed;
    RuleAction = 0 | Action := Blocked;
    !DomaineNetworkProvider = "Cisco OpenDNS, LLC" | Action := Allowed;
    DomaineNetworkProvider = "Cisco OpenDNS, LLC" | Action := Blocked;
   Vendor.action=* | Action := Vendor.action;
    * | Action := null;
}
| replace("Allowed", with="Allowed", field=Vendor.action, as="Action")
| default(value="Allowed", field="Action")
| groupBy([Action, HostName, Domain, IOCConfidenceDomain, IOCLabelsDomain], limit=max)
