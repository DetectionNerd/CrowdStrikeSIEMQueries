#event_simpleName=Event_AuthActivityAuditEvent (OperationName=userAuthenticate OR OperationName=twoFactorAuthenticate) UserIp!=""
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="UTCTimestamp", timezone="America/Los_Angeles")
| ipLocation(UserIp, as=IP)
| IP.country!="US"
| table([PacificTime, OperationName, #event.outcome, UserId, UserIp, IP.country, IP.state, IP.city], limit=max)
| rename("#event.outcome", as="Result")
