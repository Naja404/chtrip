chtrip core data

```
	keyId 为行程唯一主键
```


#mark
Date|Summy
---|---|
2015.3.12|1.添加行程时默认添加3天子行程<br/>2.未完成cell选中事件
2015.3.13|1.完成Trip cell 点击事件


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
subTitle|String|
subStartTime|String|