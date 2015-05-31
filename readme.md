chtrip core data

```
	keyID 为行程唯一主键
	subID 为子行程id
```


#mark
Date|Summy
---|---|
2015.3.12|1.添加行程时默认添加3天子行程<br/>2.未完成cell选中事件
2015.3.13|1.完成Trip cell 点击事件
2015.3.18|1.修改首页样式
2015.3.19|1.添加地址选择页面
2015.3.24|1.添加行程默认封面 <br/>2.修改添加天的方式<br/>3.添加欲购清单
2015.3.25|1.完善awsomemenu<br/>2.修改coredata <br/>3.完成欲购清单
2015.3.30|1.删除整个/整天行程
2015.4.1|1.子行程时间排序 2.search替换图标


#TripList-table

Attribute|type|
---|---|
keyID|String
tripName|string
startDate|double
endDate|double
FrontData|Binary Data


##SubTripList-table

Attribute|type|
---|---|
keyID|String
subDate|double|
subEndTime|double|
subId|String|
subLat|String|
subLng|String|
subTitle|String|
subStartTime|double|

##BuyList-table
Attribute|type|
---|---|
keyID|String
buyID|String
content|String
quantity|String
createdTime|Double
checkStatus|String

##问题汇总
日期|描述|状态
---|---|---|
2015-3-27|iPhone6Plus首页列表偏移|√
-|iPhone6Plus子行程页面“加号”偏移|√
-|子行程时间未排序|√
-|地址添加页面search换成icon|√
-|行程名透明，日期浮动在图片下|√


##待考虑问题
描述|状态
---|---|
阅览模式和编辑模式|-
行程城市名|-

##删除整天行程说明
```
	1.删除整天行程将往后行程累加上
	2.修改往后行程日期
	3.更新主行程结束日期
```


