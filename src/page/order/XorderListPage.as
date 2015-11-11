package page.order
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.scrollerRelated.Scroller;
	
	import flash.events.Event;
	import flash.net.SharedObject;
	
	import json.JsonData;
	import json.JsonDecoder;
	
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
					view.type = data.type;
					view.y = index*105;
					index++;
					scroller.addChild(view);
				}
				
				
			}
			
					
		}
		
//		private function getOrderData():Array{
//			var o:OrderData = new OrderData();
//			o.customerAddress = "dizhi";
//			o.customerName = "司思思";
//			o.customerPhone = "13545672345";
//			o.customerReceiverName = "搜懂得";
//			
//			var a:Array = new Array();
//			a.push(o);
//			return a;	
//		}
		
	}
}