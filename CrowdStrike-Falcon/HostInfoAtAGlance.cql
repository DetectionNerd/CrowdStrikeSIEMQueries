| setTimeInterval(start=1y, end=now)
| ComputerName =~wildcard(?HostName, ignoreCase=true)
| #event_simpleName=SensorHeartbeat
| join(
   {
      #event_simpleName=OsVersionInfo
      | groupBy([aid], function=([selectFromMax(field="@timestamp", include=[@timestamp, ProductName, BuildNumber])]))
      |formatTime(format="%d %B %Y, %H:%M:%S", as="OsLastReportedAt", field="@timestamp", timezone="America/Los_Angeles")
      }, field=[aid], include=[ProductName, BuildNumber, OsLastReportedAt]
)
| join(
   {
      #event_simpleName=InstalledUpdates
      | groupBy([aid], function=([selectFromMax(field="@timestamp", include=[@timestamp, LastUpdateInstalledTime, PendingUpdateIds, InstalledUpdateIds, SupersededUpdateIds])]))
      |formatTime(format="%d %B %Y, %H:%M:%S", as="PatchStatusReportedAt", field="@timestamp", timezone="America/Los_Angeles")
      }, field=[aid], include=[LastUpdateInstalledTime, PendingUpdateIds, InstalledUpdateIds, SupersededUpdateIds, PatchStatusReportedAt]
)
| upper("ComputerName", as="HostName")
| case {
	cidr(field=source.ip, subnet=["120.120.120.120/24", "120.120.120.120/24"]) | NetworkType := "VPN";
	cidr(field=source.ip, subnet=["120.120.120.120/24"]) | NetworkType := "Prod";
  cidr(field=source.ip, subnet=["120.120.120.120/24"]) | NetworkType := "Guest";
	* | NetworkType := "External";
    }
| groupBy([aid], function=([selectFromMax(field="@timestamp", include=[@timestamp, HostName, LocalIP, NetworkContainmentState, aip, NetworkType, aid, OsLastReportedAt, ProductName, BuildNumber, LastUpdateInstalledTime, PendingUpdateIds, InstalledUpdateIds, SupersededUpdateIds, PatchStatusReportedAt])]))
|formatTime(format="%d %B %Y, %H:%M:%S", as="LastSeen", field="@timestamp", timezone="America/Los_Angeles")
| case {
        NetworkContainmentState = "0"  | Status := "Normal" ;
        NetworkContainmentState = "1"  | Status := "Quarantined" ;
        * }
| ipLocation(field=aip, as=SensorIP)
| findTimestamp(field="LastUpdateInstalledTime")
|formatTime(format="%d %B %Y, %H:%M:%S", as="LastUpdateInstalledAt", timezone="America/Los_Angeles")
| format(format="%s, %s, %s", field=[SensorIP.city, SensorIP.state, SensorIP.country], as="SensorIPLocation")
| format(format="%s (%s)", field=[ProductName, BuildNumber], as="OS (BuildV)")
| asn(field=aip, as=ip)
| table([LastSeen, HostName, LocalIP, Status, NetworkType, aip, NetworkProvider, ip.asn, SensorIPLocation, OsLastReportedAt, "OS (BuildV)", LastUpdateInstalledAt, PendingUpdateIds, InstalledUpdateIds, SupersededUpdateIds, PatchStatusReportedAt, aid], limit=1)
| rename(field="aip", as="SensorPublicIP")
| rename(field="aid", as="SensorID")
| rename(field="IP.country", as="Country")
| rename(field="IP.state", as="State")
| rename(field="IP.city", as="City")
| rename(field="ProductName", as="OS")
| rename(field="BuildNumber", as="OsBuildVersion")
| rename(field="ip.asn", as="ASN")
