defineTable(query={#event_simpleName=DnsRequest DomainName=*.onion}, include=[aid, ContextProcessId, DomainName], name="dns_requests")
| #event_simpleName=ProcessRollup2
| match(file="dns_requests", field=[aid, TargetProcessId], column=[aid, ContextProcessId], include=[DomainName])
| timestamp := @timestamp
| groupBy([aid, ComputerName, TargetProcessId], function=([collect([timestamp, UserName, DomainName, FileName, CommandLine])]), limit=max)
| sort(field=timestamp, order=desc)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="timestamp", timezone="America/Los_Angeles")
| table([PacificTime, UserName, ComputerName, DomainName, FileName, CommandLine], limit=max)
