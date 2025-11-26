#event_simpleName=Event_AuthActivityAuditEvent (OperationName=userAuthenticate OR OperationName=twoFactorAuthenticate) UserIp!="" #event.outcome=failure
| ipLocation(UserIp, as=IP)
| timestamp := @timestamp
| groupBy([UserId], function=[count(), collect([UTCTimestamp, OperationName, #event.outcome, UserId, UserIp, IP.country, IP.state, IP.city, _count, timestamp])], limit=max)
| _count >=5
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="timestamp", timezone="America/Los_Angeles")
| table([PacificTime, UserId, OperationName, #event.outcome, UserIp, IP.country, IP.state, IP.city, _count], limit=max)
| rename("UserId", as="CrowdStrikeUserName")
| rename("#event.outcome", as="Result")
| rename("_count", as="LoginFailCount")
| rename("UserIp", as="SourceIP")
| rename("IP.country", as="Country")
| rename("IP.state", as="State")
| rename("IP.city", as="City")
