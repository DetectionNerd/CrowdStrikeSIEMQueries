#event_simpleName=SensorHeartbeat aid=*
| aid =~ match(file="aid_master_main.csv", column=aid, strict=false)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| ipLocation(aip)
| table([PacificTime, #event_simpleName, ComputerName, LocalAddressIP4, AgentVersion, aip, aip.country, aip.state, aip.city, aip.lat, aip.lon, aid, NetworkContainmentState], limit=max)
