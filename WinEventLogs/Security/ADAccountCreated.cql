#repo = "3pi_windows_ad" (windows.EventID=4720)
| case {
        windows.EventID = 4720 | Action := "AccountCreated";
        * | Action := "--UndefinedAction--";
        }
| case {
        windows.Keywords = 0x8020000000000000 | Result := "Success";
        windows.Keywords = 0x8010000000000000 | Result := "Failure";
        * | Result := "--Undefined Result--";
        }
| upper("windows.Computer", as=windows.Computer)
| upper("windows.EventData.SubjectUserName", as=windows.EventData.SubjectUserName)
| replace(".IKIGAI.COM", with="", field=windows.Computer, as="windows.Computer")
| parseTimestamp(field="windows.TimeCreated")
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", timezone="America/Los_Angeles")
| table([PacificTime, windows.EventData.TargetUserName, Action, windows.EventData.SubjectUserName, Result, windows.Computer, windows.EventID, windows.EventData.TargetSid, windows.EventData.SubjectUserSid, event.type[1], windows.Channel, event.category[0]], limit=max)
| rename(field="windows.EventData.TargetUserName", as="TargetUser")
| rename(field="windows.EventData.TargetSid", as="TargetSID")
| rename(field="windows.EventData.SubjectUserName", as="ActionBy")
| rename(field="windows.EventData.SubjectUserSid", as="SourceAccountSID")
| rename(field="windows.EventID", as="EventID")
| rename(field="event.type[1]", as="EventType")
| rename(field="windows.Channel", as="LogChannel")
| rename(field="event.category[0]", as="EventCategory")
| rename(field="windows.Computer", as="LogSource")
