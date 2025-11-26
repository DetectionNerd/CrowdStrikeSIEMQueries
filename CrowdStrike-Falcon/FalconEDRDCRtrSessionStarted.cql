#event_simpleName=Event_RemoteResponseSessionStartEvent
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="UTCTimestamp", timezone="America/Los_Angeles")
| rename("AgentIdString", as="aid")
| aid =~ match(file="aid_master_main.csv", column=aid, strict=false)
| table([PacificTime, #event_simpleName, UserName, HostnameField, LocalAddressIP4, MAC, aip, aid], limit=max)
| rename("#event_simpleName", as="EventType")
| rename("HostnameField", as="HostName")
| rename("aip", as="HostPublicIP")
| rename("aid", as="AgentID")
