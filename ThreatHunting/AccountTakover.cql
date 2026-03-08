// --- STEP 1: Duo MFA Account Phone Update ---
#repo = cisco_duo_mfa
#event.dataset=duo.administrator Vendor.action=user_update
Vendor.description="{\"phones*"
Vendor.username!="Active Directory User Sync: AD Sync"
| upper("Vendor.object", as=TargetAccount)
| formatTime(format="%d %B %Y, %H:%M:%S", as="DuoUpdateTime", field="Vendor.timestamp", timezone="America/Los_Angeles")
| rename(field="#event.dataset", as="EventDataset")
| rename(field="Vendor.action", as="DuoAction")
| rename(field="Vendor.username", as="DuoActionBy")
| rename(field="Vendor.description.phones.phone1.number", as="Phone1")
| rename(field="Vendor.description.phones.phone2.number", as="Phone2")
| rename(field="Vendor.description.phones.phone3.number", as="Phone3")
| rename(field="Vendor.description.phones.phone4.number", as="Phone4")
| rename(field="Vendor.description.phones.phone5.number", as="Phone5")

// --- STEP 2: AD Password Change Events ---
| join({
  #repo = "3pi_windows_ad"(windows.EventID=4723 OR windows.EventID=4724)
  | case{
    windows.EventID = 4723 | ADAction := "Password Change Attempted (self)";
    windows.EventID = 4724 | ADAction := "Password Reset Attempted (admin)";
    * | ADAction := "--UndefinedAction--";
   }
  | case{
    windows.Keywords = 0x8020000000000000 | Result := "Success";
    windows.Keywords = 0x8010000000000000 | Result := "Failure";
    * | Result := "--Undefined Result--";
   }
  | upper("windows.EventData.TargetUserName", as=TargetAccount)
  | replace(".IKIGAI.AI", with="", field=windows.Computer, as="windows.Computer")
  | formatTime(format="%d %B %Y, %H:%M:%S", as="PasswordResetTime", field="windows.TimeCreated", timezone="America/Los_Angeles")
  | rename(field="windows.EventData.SubjectUserName", as="ADActionBy")
  | rename(field="windows.Computer", as="LogSource")
  | rename(field="windows.EventData.TargetSid", as="TargetSID")
  | rename(field="windows.EventData.SubjectUserSid", as="SourceAccountSID")
  | rename(field="windows.EventID", as="EventID")
  | rename(field="event.type[1]", as="EventType")
  | rename(field="windows.Channel", as="LogChannel")
  | rename(field="event.category[0]", as="EventCategory")
}, field=TargetAccount, include=[PasswordResetTime, ADAction, Result, ADActionBy, LogSource, TargetSID, SourceAccountSID, EventID, EventType, LogChannel, EventCategory], mode=inner)

// --- STEP 3: Workday Emails ---
| join({
  #repo = mimecast
  #event.dataset=emailsecurity.receipt(Vendor.senderHeader=IKIGAI@myworkday.com OR Vendor.senderEnvelope=*.myworkday.com) Vendor.subject=Payment*
  | formatTime(format="%d %B %Y, %H:%M:%S", as="WorkdayEmailTime", field="Vendor.timestamp", timezone="America/Los_Angeles")
  | case{
    Vendor.action = "Acc" | EmailAction := "Accept";
    Vendor.action = "Rej" | EmailAction := "Reject";
    Vendor.action = "Hld" | EmailAction := "Hold";
    Vendor.action = "Ign" | EmailAction := "Ignore";
    Vendor.action = "Bnc" | EmailAction := "Bnc";
    *}
  | regex("(?<EmailUser>[a-zA-Z0-9-]+)\s*@", field=Vendor.recipients, strict=false)
  | upper("EmailUser", as=TargetAccount)
  | rename(field="Vendor.direction", as="Direction")
  | rename(field="Vendor.recipients", as="TargetEmail")
  | rename(field="Vendor.senderHeader", as="SenderHeader")
  | rename(field="Vendor.senderEnvelope", as="SenderEnvelope")
  | rename(field="Vendor.senderIp", as="SenderIP")
  | rename(field="Vendor.subject", as="Subject")
  | rename(field="Vendor.rejectionType", as="RejectionType")
  | rename(field="Vendor.rejectionInfo", as="RejectionInfo")
  | rename(field="Vendor.numberAttachments", as="Attachment")
}, field=TargetAccount, include=[WorkdayEmailTime, EmailAction, Direction, TargetEmail, SenderHeader, SenderEnvelope, SenderIP, Subject, RejectionType, RejectionInfo, Attachment], mode=inner)

// --- STEP 4: Final Table ---
| table([TargetAccount, DuoUpdateTime, DuoAction, DuoActionBy, Phone1, Phone2, Phone3, Phone4, Phone5, PasswordResetTime, ADAction, ADActionBy, Result, LogSource, EventID, WorkdayEmailTime, EmailAction, Direction, TargetEmail, SenderHeader, Subject, SenderEnvelope, SenderIP, Attachment, TargetSID, SourceAccountSID])
