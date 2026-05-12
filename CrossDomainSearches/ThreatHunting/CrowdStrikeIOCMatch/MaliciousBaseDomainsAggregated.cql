(#Vendor=crowdstrike ((#event_simpleName=DnsRequest OR #event_simpleName=SuspiciousDnsRequest) OR ((#event_simpleName=FirewallRuleIP4Matched OR #event_simpleName=FirewallRuleIP6Matched)))) OR (#Vendor=cisco #event.module=umbrella)
| regex("^(?<Vendor.Domain>.*?)(?:\\.)?$", field=Vendor.domain, strict=false)
| case {
    DomainName=* | Domain := DomainName;
    Vendor.Domain=* | Domain := Vendor.Domain;
    DomainNameList=* | Domain := DomainNameList;
    * | Domain := null;
}
// Normalize input as a URI so we can reliably work with hostnames
| parseUri(Domain, defaultBase="https://")
// Extract the registrable/base domain into base_domain (extend TLD list as needed)
| Domain.host=/(?<BaseDomain>[-a-zA-Z0-9]+\.(?:co\.uk|com\.tr|com|net|org|edu|gov|io|co|ai|in))$/
| ioc:lookup(field=BaseDomain, type=domain, confidenceThreshold=unverified, strict=true, prefix=domain2ioc, include=[malicious_confidence, labels])
| default(value="No CrowdStrike intelligence available for this Domain", field="domain2ioc[0].labels")
| rename(field="domain2ioc[0].malicious_confidence", as="IOCConfidenceBaseDomain") | rename(field="domain2ioc[0].labels", as="IOCLabelsBaseDomain")
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
| groupBy([Action, HostName, BaseDomain, IOCConfidenceBaseDomain, IOCLabelsBaseDomain], limit=max)
