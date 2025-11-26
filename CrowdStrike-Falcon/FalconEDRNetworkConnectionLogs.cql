defineTable(query={(#event_simpleName=NetworkConnectIP4 OR #event_simpleName=NetworkConnectIP6)}, include=[ContextProcessId, ConnectionDirection, Protocol, UserName, ComputerName, LocalAddressIP4, LocalPort, LocalAddressIP6, RemoteAddressIP4, RemotePort, RemoteAddressIP6, TcpConnectErrorCode, #event_simpleName, aid, aip], name="netconnect_events") | #event_simpleName=ProcessRollup2 | match(file="netconnect_events", field=[aid, TargetProcessId], column=[aid, ContextProcessId], include=[ConnectionDirection, Protocol, UserName, ComputerName, LocalAddressIP4, LocalPort, LocalAddressIP6, RemoteAddressIP4, RemotePort, RemoteAddressIP6, TcpConnectErrorCode, #event_simpleName, aid, CommandLine, FileName, aip]) | timestamp := @timestamp | upper("UserName", as=UserName)
// --------------------Modify as per the User, Host, Source IP, Domain or Destination IP you're searching for---------------------------

|  UserName=*IKIGAI* OR ComputerName=PCTEST OR LocalAddressIP4=192.168.24.140 OR RemoteAddressIP4=141.95.145.210 OR LocalAddressIP6="2600:4040:b57f:2100:b3g3:59e:ffbd:x234" OR RemoteAddressIP6="2568:3ed:33:0:0:0:0:11"

// --------------------Modify as per the User, Host, Source IP, Domain or Destination IP you're searching for---------------------------
| ipLocation(field=LocalAddressIP4, as=LocalIP4)
| ipLocation(field=RemoteAddressIP4, as=RemoteIP4)
| ipLocation(field=LocalAddressIP6, as=LocalIP6)
| ipLocation(field=RemoteAddressIP6, as=RemoteIP6)
| ipLocation(field=aip, as=AgentIP)
| groupBy([aid, ComputerName, TargetProcessId], function=([collect([timestamp, ConnectionDirection, Protocol, UserName, ComputerName, FileName, LocalAddressIP4, LocalPort, LocalIP4.country, LocalIP4.state, LocalIP4.city, LocalAddressIP6, LocalIP6.country, LocalIP6.state, LocalIP6.city, RemoteAddressIP4, RemotePort, RemoteIP4.country, RemoteIP4.state, RemoteIP4.city, RemoteAddressIP6, RemoteIP6.country, RemoteIP6.state, RemoteIP6.city, TcpConnectErrorCode, #event_simpleName, aid, aip, AgentIP.country, AgentIP.state, AgentIP.city, CommandLine])]), limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="timestamp", timezone="America/Los_Angeles")
| case {
        ConnectionDirection = "0"  | ConnectionDirection := "Outbound" ;
        ConnectionDirection = "1"  | ConnectionDirection := "Inbound" ;
        ConnectionDirection = "2"  | ConnectionDirection := "Neither" ;
        ConnectionDirection = "3"  | ConnectionDirection := "Both" ;
        ConnectionDirection = "4" | ConnectionDirection := "Unknown" ;
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
| table([PacificTime, ConnectionDirection, Protocol, UserName, ComputerName, FileName, LocalAddressIP4, LocalPort, LocalIP4.country, LocalIP4.state, LocalIP4.city, LocalAddressIP6, LocalIP6.country, LocalIP6.state, LocalIP6.city, RemoteAddressIP4, RemotePort, RemoteIP4.country, RemoteIP4.state, RemoteIP4.city, RemoteAddressIP6, RemoteIP6.country, RemoteIP6.state, RemoteIP6.city, TcpConnectErrorCode, #event_simpleName, aip, AgentIP.country, AgentIP.state, AgentIP.city, aid, CommandLine], limit=max)
