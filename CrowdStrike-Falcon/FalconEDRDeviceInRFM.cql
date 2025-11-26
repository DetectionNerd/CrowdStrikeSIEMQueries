#event_simpleName=OsVersionInfo
| aid =~ match(file="aid_master_main.csv", column=aid, strict=false)
| groupBy([aid], function=([selectFromMax(field="@timestamp", include=[@timestamp, RFMState, ComputerName, LocalAddressIP4, MAC, ProductName, BuildNumber, AgentVersion, aip, aid, ProductType])]), limit=max)
| ProductType=1
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| case {
        RFMState = "0"  | RFMStatus := "NoRFM" ;
        RFMState = "1"  | RFMStatus := "InRFM" ;
        * }
| upper("MAC", as=MAC)
| RFMStatus=InRFM
| table([PacificTime, RFMStatus, ComputerName, LocalAddressIP4, MAC, ProductName, BuildNumber, AgentVersion, aip, aid], limit=max)
| rename("ComputerName", as="HostName")
| rename("ProductName", as="OS")
| rename("BuildNumber", as="OsBuild")
| rename("AgentVersion", as="SensorVersion")
| rename("aip", as="PublicIP")
| rename("aid", as="SensorID")
