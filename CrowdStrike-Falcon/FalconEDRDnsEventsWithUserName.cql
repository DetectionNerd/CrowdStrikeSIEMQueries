defineTable(query={#event_simpleName=DnsRequest | lower("DomainName", as=DomainName)
// --------------------------------Modify as per the domain or host you're searching for----------------------------------------------------
 
| (DomainName=*anydesk.com* OR ComputerName=PCTEST)
 
// --------------------------------Modify as per the domain or host you're searching for----------------------------------------------------
(
DomainName!="*.google.com"
DomainName!="*.googleapis.com"
DomainName!="*.microsoft.com"
DomainName!="*.bing.com"
DomainName!="*.msn.com"
DomainName!="*.office.com"
DomainName!="*.live.com"
DomainName!="*.googleusercontent.com"
DomainName!="*.digicert.com"
DomainName!="*.gstatic.com"
DomainName!="*.azureedge.net"
DomainName!="*.google-analytics.com"
DomainName!="*.googleadservices.com"
DomainName!="*.office.net"
DomainName!="*.intel.com"
DomainName!="*.windows.com"
)
}, include=[aid, ContextProcessId, DomainName, CNAMERecords, IP4Records], name="dns_requests")
| #event_simpleName=ProcessRollup2
| match(file="dns_requests", field=[aid, TargetProcessId], column=[aid, ContextProcessId], include=[DomainName, CNAMERecords, IP4Records])
| timestamp := @timestamp
| ipLocation(field=aip, as=AgentIP)
| groupBy([aid, ComputerName, TargetProcessId], function=([collect([timestamp, UserName, DomainName, FileName, CommandLine, aip, AgentIP.country, AgentIP.state, AgentIP.city, CNAMERecords, IP4Records])]), limit=max)
| sort(field=timestamp, order=desc,  limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="timestamp", timezone="America/Los_Angeles")
| table([PacificTime, UserName, ComputerName, DomainName, CNAMERecords, IP4Records, FileName, CommandLine, aip, AgentIP.country, AgentIP.state, AgentIP.city, aid], limit=max)
| rename("FileName", as="SourceFileName")
| rename("aip", as="AgentPublicIP")
| rename("IP4Records", as="DestinationIP")
