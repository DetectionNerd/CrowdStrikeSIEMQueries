#event_simpleName=NetworkContainmentCompleted
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| ipLocation(aip, as=IP)
| aid =~ match(file="aid_master_main.csv", column=aid, strict=false)
| ProductType=2
| table([PacificTime, #event_simpleName, ComputerName, LocalAddressIP4, aid, aip, IP.country, IP.state, IP.city], limit=max)
| rename("#event_simpleName", as="EventType")
| rename("aid", as="AgentID")
| rename("aip", as="PublicIP")
| rename("IP.country", as="Country")
| rename("IP.state", as="State")
| rename("IP.city", as="City")
