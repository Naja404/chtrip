chtrip core data

```
	keyId 为行程唯一主键
```


#mark
预先入库subtrip，triplist cell select not work


#TripList-table

Attribute|type|
---|---|
keyId|String
tripName|string
startDate|Date
endDate|Date
FrontData|Binary Data


##SubTripList-table

Attribute|type|
---|---|
keyId|String
subDate|Date|
subEndTime|String|
subId|String|
subLat|String|
subLng|String|
subName|String|
subStartTime|String|