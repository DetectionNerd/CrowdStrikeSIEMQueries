#Vendor=cisco | #event.module=umbrella | lower("@rawstring", as=@rawstring)
// --------------------------------------------------Modify as per the string you're searching for-----------------------------------------

| @rawstring=*anydesk*

// --------------------------------------------------Modify as per the string you're searching for-----------------------------------------
| groupBy([@timestamp, Vendor.action, source.domain, Vendor.identities, Vendor.most_granular_identity, Vendor.internal_ip, Vendor.external_ip, Vendor.domain, Vendor.categories, Vendor.blocked_categories, Vendor.query_type, Vendor.response_code], limit=max)
| sort(field=@timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="@timestamp", timezone="America/Los_Angeles")
| table([PacificTime, Vendor.action, source.domain, Vendor.identities, Vendor.most_granular_identity, Vendor.internal_ip, Vendor.external_ip, Vendor.domain, Vendor.categories, Vendor.blocked_categories, Vendor.query_type, Vendor.response_code], limit=max)
| rename("Vendor.action", as="Action")
| rename("source.domain", as="HostName")
| rename("Vendor.identities", as="Identities")
| rename("Vendor.most_granular_identity", as="GranularIdentities")
| rename("Vendor.internal_ip", as="LocalAddressIP4")
| rename("Vendor.external_ip", as="PublicIP")
| rename("Vendor.domain", as="DomainName")
| rename("Vendor.categories", as="Categories")
| rename("Vendor.blocked_categories", as="BlockedCategories")
| rename("Vendor.query_type", as="DnsQueryType")
| rename("Vendor.response_code", as="ResponseCode")
