chtrip core data

```
	keyId 为行程唯一主键
```


#mark
Date|Summy
---|---|
2015.3.12|1.添加行程时默认添加3天子行程<br/>2.未完成cell选中事件
2015.3.13|1.完成Trip cell 点击事件
2015.3.18|1.修改首页样式
2015.3.19|1.添加地址选择页面


#TripList-table

Attribute|type|
---|---|
keyId|String
tripName|string
startDate|double
endDate|double
FrontData|Binary Data


##SubTripList-table

Attribute|type|
---|---|
keyId|String
subDate|double|
subEndTime|double|
subId|String|
subLat|String|
subLng|String|
subTitle|String|
subStartTime|double|