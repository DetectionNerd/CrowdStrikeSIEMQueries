#event_simpleName=OsVersionInfo event_platform=Win ProductType=1 BuildNumber<22631
| ipLocation(field=aip, as=SensorIP)
| case {
	cidr(field=aip, subnet=["130.130.130.130/24", "130.130.130.130/24"]) | NetworkType := "VPN";
	cidr(field=aip, subnet=["130.130.130.130/23"]) | NetworkType := "Prod";
	* | NetworkType := "Non-Org. External Network";
    }
| groupBy([aid], function=([selectFromMax(field="@timestamp", include=[@timestamp, ComputerName, LocalAddressIP4, MAC, WinOSVersion, ProductName, BuildNumber, aip, NetworkType, SensorIP.country, SensorIP.state, SensorIP.city, aid])]), limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="OsReportedAt", field="@timestamp", timezone="America/Los_Angeles")
| table([OsReportedAt, ComputerName, LocalAddressIP4, WinOSVersion, ProductName, BuildNumber, aip, NetworkType, SensorIP.country, SensorIP.state, SensorIP.city, aid], limit=max)
| sort(ComputerName, order=asc, limit=max)
| rename("aip", as="PublicIP")
| rename("SensorIP.country", as="Country")
| rename("SensorIP.state", as="State")
| rename("SensorIP.city", as="City")
