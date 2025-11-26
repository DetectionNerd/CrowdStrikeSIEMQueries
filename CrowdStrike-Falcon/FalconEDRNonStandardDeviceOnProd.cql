#event_simpleName=SensorHeartbeat aid=*
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| ipLocation(aip)
| cidr(aip, subnet=["130.130.130.130/23", "130.130.130.130/23"])
| case {
        NetworkContainmentState = "0"  | NetworkContainmentStatus := "NO" ;
        NetworkContainmentState = "1"  | NetworkContainmentStatus := "YES" ;
        * }
| table([PacificTime, #event_simpleName, ComputerName, LocalAddressIP4, aip, aip.country, aip.state, aip.city, aip.lat, aip.lon, aid, NetworkContainmentStatus], limit=max)
