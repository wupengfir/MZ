package page.order
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	
	import json.JsonData;
	import json.JsonDecoder;
	
	import page.alertpage.Alert;
	import page.alertpage.Confirm;
	
	import user.UserInfo;
	
	public class OrderDataView extends Page
	{
		
		public var img:Image = new Image("data/img/ui/wawa.png");
		public var customerNameLabel:Label = new Label("",18);
		public var customerAddressLabel:Label = new Label("",18);
		public var customerPhoneLabel:Label = new Label("",18);
		public var customerReceiverNameLabel:Label = new Label("",18);
		public var deleteButton:Image = new Image("data/img/delete.jpg");
		
		public var data:OrderData;
		public var type:String;
		private var ps:XML = 
			<root>
				<object name="img" x="18" y="15"/>
				<object name="customerNameLabel" x="90" y="15"/>
				<object name="customerPhoneLabel" x="90" y="70"/>
				<object name="customerAddressLabel" x="400" y="70"/>
				<object name="customerReceiverNameLabel" x="960" y="40"/>
				<object name="deleteButton" x="1100" y="10"/>	
			</root>
		
		public function OrderDataView(_data:OrderData)
		{
			this.data = _data;
			initByPageScript(ps);
			customerNameLabel.text = data.customerName;
			customerAddressLabel.text = data.customerAddress;
			customerAddressLabel.width = 500;
			customerPhoneLabel.width = 200;
			customerPhoneLabel.text = data.customerPhone;
			customerReceiverNameLabel.text = data.customerReceiverName;
			drawBack(1200,100,0xffffff);
			img.scaleX = img.scaleY = 1/2;
			drawLine(100,100,1200,100);
			this.buttonMode = true;
			
			deleteButton.width = 70;
			deleteButton.height = 80;
			deleteButton.buttonMode = true;
			deleteButton.addEventListener(MouseEvent.CLICK,onItendDelete);
			deleteButton.addEventListener(Confirm.YES,onDelete);
			
		}
		private function onItendDelete(e:MouseEvent):void{
			Confirm.confirm("确认删除",deleteButton);
		}
		
		private function onDelete(e:Event):void{
			if(this.type == "local"){
				var so:SharedObject = UserInfo.userLocalOrderData			
				so.data.orderlist[this.data.orderNo] = "";				
				so.flush();
				XorderListPage.instance.loadOrders();
			}else{
				Common.loadURL("furniture/action/order/iosOrderDelete?JSESSIONID="+UserInfo.sessionID+"&orderid="+this.data.orderId,onDeleteed,null);	
			}
			
		}
		
		private function onDeleteed(e:Event):void{
			var data:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			trace(e.currentTarget.data);
			if(data.success){
				if(data.dataValue.isdel){
					XorderListPage.instance.loadOrders();
					Alert.alert("已删除");
				}				
			}
		}
		
	}
}





















