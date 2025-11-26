#event_simpleName=UserLogon | upper("UserName", as=UserName)
// -------------------------------------------------------Modify as per the user you're searching for---------------------------------------

| (UserName=*IKUGAI*)

// -------------------------------------------------------Modify as per the user you're searching for---------------------------------------
| case {
        LogonType = "2"  | LogonType := "Interactive" ;
        LogonType = "3"  | LogonType := "Network" ;
        LogonType = "4"  | LogonType := "Batch" ;
        LogonType = "5"  | LogonType := "Service" ;
        LogonType = "6"  | LogonType := "Proxy" ;
        LogonType = "7"  | LogonType := "Unlock" ;
        LogonType = "8"  | LogonType := "Network Cleartext" ;
        LogonType = "9"  | LogonType := "New Credential" ;
        LogonType = "10" | LogonType := "Remote Interactive" ;
        LogonType = "11" | LogonType := "Cached Interactive" ;
        LogonType = "12" | LogonType := "Cached Remote Interactive" ;
        LogonType = "13" | LogonType := "Cached Unlock" ;
        * }
| aid =~ match(file="aid_master_main.csv", column=aid, strict=false)
| ipLocation(field=aip, as=AgentIP)
| groupBy([aid], function=([selectFromMax(field="@timestamp", include=[@timestamp, UserName, ComputerName, LocalAddressIP4, LogonType, RemoteAddressIP4, aip, AgentIP.country, AgentIP.state, AgentIP.city, aid])]), limit=max)
| sort(field=@timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="LastLogon(Pacific)", field="@timestamp", timezone="America/Los_Angeles")
| table(["LastLogon(Pacific)", UserName, ComputerName, LocalAddressIP4, LogonType, RemoteAddressIP4, aip, AgentIP.country, AgentIP.state, AgentIP.city, aid], limit=max)
| rename("RemoteAddressIP4", as="LogonSourceIP")
| rename("aip", as="AgentPublicIP")
| rename("ClientComputerName", as="SourceHostName")
| rename("aip", as="AgentPublicIP")
