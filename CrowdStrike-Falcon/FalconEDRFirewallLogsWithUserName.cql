defineTable(query={(#event_simpleName=FirewallRuleIP4Matched OR #event_simpleName=FirewallRuleIP6Matched)}, include=[ContextProcessId, RuleAction, ConnectionDirection, ComputerName, LocalAddressIP4, LocalAddressIP6, LocalPort, DomainNameList, Protocol, RemoteAddressIP4, RemoteAddressIP6, RemotePort, NetworkProfile, aip, #event_simpleName, aid, CommandLine, HbfwRuleId, PolicyIdentifier, HbfwRuleFlags], name="firewall_events") | #event_simpleName=ProcessRollup2 | match(file="firewall_events", field=[aid, TargetProcessId], column=[aid, ContextProcessId], include=[RuleAction, ConnectionDirection, ComputerName, LocalAddressIP4, LocalAddressIP6, LocalPort, DomainNameList, Protocol, RemoteAddressIP4, RemoteAddressIP6, RemotePort, NetworkProfile, aip, #event_simpleName, aid, CommandLine, FileName, HbfwRuleId, PolicyIdentifier, HbfwRuleFlags]) | timestamp := @timestamp | lower("@rawstring", as=@rawstring)
// ---------------------------Modify as per the User, Host, Source IP, Domain or Destination IP you're searching for-------------------------

| @rawstring=*anydesk.com*

// ---------------------------Modify as per the User, Host, Source IP, Domain or Destination IP you're searching for-------------------------
| case {
        NetworkProfile = "0"  | NetworkProfile := "Invalid" ;
        NetworkProfile = "1"  | NetworkProfile := "Domain" ;
        NetworkProfile = "2"  | NetworkProfile := "Public" ;
        NetworkProfile = "4"  | NetworkProfile := "Private" ;
        NetworkProfile = "ff" | NetworkProfile := "Any" ;
        * }
| case {
        ConnectionDirection = "0"  | ConnectionDirection := "Outbound" ;
        ConnectionDirection = "1"  | ConnectionDirection := "Inbound" ;
        ConnectionDirection = "2"  | ConnectionDirection := "Neither" ;
        ConnectionDirection = "3"  | ConnectionDirection := "Both" ;
        ConnectionDirection = "4" | ConnectionDirection := "Unknown" ;
        * }
| case {
        RuleAction = "0"  | RuleAction := "Invalid" ;
        RuleAction = "1"  | RuleAction := "Allow" ;
        RuleAction = "2"  | RuleAction := "Deny" ;
        RuleAction = "3"  | RuleAction := "Delay" ;
        * }
| case {
        Protocol = "0"  | Protocol := "IP" ;
        Protocol = "1"  | Protocol := "ICMP" ;
        Protocol = "2"  | Protocol := "IGMP" ;
        Protocol = "6"  | Protocol := "TCP" ;
        Protocol = "17"  | Protocol := "UDP" ;
        Protocol = "41"  | Protocol := "IPv6" ;
        Protocol = "47"  | Protocol := "GRE" ;
        Protocol = "58"  | Protocol := "ICMPv6" ;
        Protocol = "255"  | Protocol := "Unknown" ;
        * }
| case {
        #event_simpleName = "FirewallRuleIP4Matched"  | #event_simpleName := "IPv4" ;
        #event_simpleName = "FirewallRuleIP6Matched"  | #event_simpleName := "IPv6" ;
        * }
| ipLocation(field=RemoteAddressIP4, as=RemoteIPv4)
| ipLocation(field=LocalAddressIP6, as=RemoteIPv6)
| ipLocation(field=aip, as=AgentIP)
| groupBy([aid, ComputerName, TargetProcessId], function=([collect([timestamp, UserName, RuleAction, ConnectionDirection, ComputerName, LocalAddressIP4, LocalAddressIP6, LocalPort, DomainName, Protocol, RemoteAddressIP4, RemoteIPv4.country, RemoteIPv4.state, RemoteIPv4.city, RemoteAddressIP6, RemoteIPv6.country, RemoteIPv6.state, RemoteIPv6.city, RemotePort, NetworkProfile, aip, AgentIP.country, AgentIP.state, AgentIP.city, #event_simpleName, aid, CommandLine, FileName, HbfwRuleId, FirewallPolicy, PolicyIdentifier, HbfwRuleFlags])]), limit=max)
| sort(field=timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="timestamp", timezone="America/Los_Angeles")
| table([PacificTime, RuleAction, ConnectionDirection, FirewallPolicy, UserName, ComputerName, LocalAddressIP4, LocalAddressIP6, LocalPort, FileName, DomainName, Protocol, RemoteAddressIP4, RemoteIPv4.country, RemoteIPv4.state, RemoteIPv4.city, RemoteAddressIP6, RemoteIPv6.country, RemoteIPv6.state, RemoteIPv6.city, RemotePort, NetworkProfile, aip, AgentIP.country, AgentIP.state, AgentIP.city, #event_simpleName, aid, CommandLine, PolicyIdentifier, HbfwRuleId, HbfwRuleFlags], limit=max)
| rename("#event_simpleName", as="Type")
| rename("aip", as="AgentPublicIP")
| rename("aid", as="AgentID")
| rename("RuleAction", as="Action")
| rename("ConnectionDirection", as="Direction")
| rename("FileName", as="SourceFile")
