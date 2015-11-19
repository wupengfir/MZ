package page.order
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.scrollerRelated.Scroller;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	
	import json.JsonData;
	import json.JsonDecoder;
	
	import page.alertpage.Alert;
	import page.alertpage.Confirm;
	
	import user.UserInfo;
	
	public class XorderListPage extends Page
	{
		private var scroller:Scroller = new Scroller(Common.MAX_WIDTH,700,1);
		private var orderList:Array;
		public static var instance:XorderListPage;
		public function XorderListPage()
		{
			instance = this;
			backSource = "data/img/ui/orderlistback.png";
			backImage.width = Common.MAX_WIDTH;
			backImage.height = 840;
			scroller.y = 100;
			addChild(scroller);
			
			loadOrders();

			
			//showList();
		}
		
		public function loadOrders():void{
			Common.loadURL("furniture/action/order/iosQueryOrder?JSESSIONID="+UserInfo.sessionID,showList,null);	
		}
		
		public function showList(e:Event):void{
			
			
			var orderdata:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			trace(e.currentTarget.data);
			if(orderdata.success){
				
				scroller.clearContent();
				orderList = new Array();
				//添加后台订单
				var o:OrderData
				for each(var obj:Object in orderdata.dataValue.datavalue){		
					o = new OrderData();
					o.orderId = obj.to_id;
					o.customerAddress = obj.to_address;
					o.customerName = obj.to_name;
					o.customerPhone = obj.to_tel;
					o.customerReceiverName = obj.to_salesman;
					orderList.push(o);
				}
				//添加本地订单
				var so:SharedObject = UserInfo.userLocalOrderData;
				if(so.data.orderlist != null){
					for(var key:String in so.data.orderlist){
						var js:String = so.data.orderlist[key];
						if(js == ""){
							continue;
						}
						var od:Object = JSON.parse(js);
						o = new OrderData();
						o.type = "local";
						o.orderNo = key;
						o.customerAddress = od.to_address;
						o.customerName = od.to_name;
						o.customerPhone = od.to_tel;
						o.customerReceiverName = od.to_salesman;
						orderList.push(o);
					}
				}
				
				
				/////////////////////////////////
				var index:int = 0;
				for each(var data:OrderData in orderList){
					var view:OrderDataView = new OrderDataView(data);
					view.addEventListener(MouseEvent.CLICK,createOrderDetail);
					view.type = data.type;
					view.y = index*105;
					index++;
					scroller.addChild(view);
				}
				
				
			}
			
					
		}
		
		private function createOrderDetail(e:MouseEvent):void{
			if(e.target == e.currentTarget){
				var dp:OrderDetailPage;
				if((e.currentTarget.data as OrderData).type == "server"){
					dp = new OrderDetailPage(e.currentTarget.data,"server");
					var id:String = (e.currentTarget.data as OrderData).orderId.toString();
					var js:String = UserInfo.userOrdersDatabase.data.orderlist[id];
					if(js == null||js == ""||js == undefined){
						Alert.alert("无本地订单数据");
						return;
					}
					var orderDetails:Object = JSON.parse(js);
					dp.showqingdan(orderDetails);
				}else{
					dp = new OrderDetailPage(e.currentTarget.data,"local");
					var id:String = (e.currentTarget.data as OrderData).orderNo.toString();
					var js:String = UserInfo.userOrdersDatabase.data.orderlist[id];
					var orderDetails:Object = JSON.parse(js);
					dp.showqingdan(orderDetails);
				}
				addChild(dp);
			}			
		}
		
		private function onSaveUploaded(e:Event):void{
			var data:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			trace(e.currentTarget.data);
			if(data.success){
//				var so:SharedObject = UserInfo.userLocalOrderData
//				for each(var obj:Object in data.dataValue.orders){					
//					so.data.orderlist[obj.orderNo] = "";					
//				}
//				so.flush();
			}
		}
		
	}
}