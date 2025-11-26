aip=*
| !cidr(aip, subnet=["130.130.130.0/23"])
| ipLocation(aip)
|  groupBy([ComputerName], function=([selectFromMax(field="@timestamp", include=[aip, aip.country, aip.state, aip.city, aip.lat, aip.lon])]), limit=max)
