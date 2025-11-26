#event_simpleName=UserLogon ClientComputerName="*" | upper("UserName", as=UserName) | aid =~ match(file="aid_master_main.csv", column=aid, strict=false) | match(file="aid_master_main.csv", column="LocalAddressIP4", field=RemoteAddressIP4, include=[ComputerName])
// ----------------------------Modify as per the User, Logon Host, Source Host or Source IP you're searching for -----------------------------
| (UserName=IKUGAI OR
   ClientComputerName=PCTEST  OR         //ClientComputerName ≅ Logon Host
   ComputerName=IT OR                    //ComputerName ≅ Source Host
   RemoteAddressIP4=192.168.8.49)       // RemoteAddressIP4 ≅ Source IP
// ----------------------------Modify as per the User, Logon Host, Source Host or Source IP you're searching for -----------------------------
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
| ipLocation(field=aip, as=AgentIP)
| sort(field=@timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| table([PacificTime, UserName, ClientComputerName, LocalAddressIP4, LogonType, ComputerName, RemoteAddressIP4, aip, AgentIP.country, AgentIP.state, AgentIP.city, aid], limit=max)
| rename("RemoteAddressIP4", as="LogonSourceIP")
| rename("aip", as="AgentPublicIP")
| rename("ClientComputerName", as="HostName")
| rename("ComputerName", as="LogonSourceHost")
| rename("aip", as="AgentPublicIP")
