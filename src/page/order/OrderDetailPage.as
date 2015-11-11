package page.order
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	import com.shangyi.component.scrollerRelated.Scroller;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import page.alertpage.Alert;
	
	public class OrderDetailPage extends Page
	{
		
		private var saveContainer:Page = new Page();
		private var closeImage:Image = new Image(Main.basePath + "data/img/goback.png");
		private var saveState:Image = new Image(Main.basePath + "data/img/save.png");
		private var savedState:Image = new Image(Main.basePath + "img/saved.png");
		
		private var userNameText:TextField = new TextField();
		private var userPhoneText:TextField = new TextField();
		private var guideText:TextField = new TextField();
		private var userAddressText:TextField = new TextField();
		
		private var noticeLabel:Label = new Label("姓名与联系电话为必填项");
		private var productInfoScroller:Scroller = new Scroller(Common.MAX_WIDTH,600,1);
		
		private var zongjia:Label = new Label("",16);
		private var saveBack:Image = new Image("data/img/ui/dingdanback2.png");
		
		public function OrderDetailPage()
		{
			
		}
		
		private function hide():void{
			this.clearAll();
		}
		
		private function createSave():void{
			saveState.buttonMode = closeImage.buttonMode = true;
			saveContainer.graphics.beginFill(0,.6);
			saveContainer.graphics.drawRect(-300,-300,Common.MAX_WIDTH*2,Common.MAX_HEIGHT*2);
			saveContainer.graphics.endFill();
			addChild(saveContainer);
			saveContainer.addChild(saveBack);
			//saveContainer.source =Main.basePath + "data/img/ui/orderdetails.png";
			saveContainer.x = 0;
			saveContainer.y = 0;
			saveState.x = savedState.x = 134;
			saveState.y = savedState.y = 866;
			saveContainer.addChild(saveState);
			saveContainer.addChild(closeImage);

			
			
			saveContainer.addChild(userAddressText);
			saveContainer.addChild(userNameText);
			saveContainer.addChild(userPhoneText);
			saveContainer.addChild(guideText);
			saveContainer.addChild(productInfoScroller);
			saveContainer.addChild(zongjia);
			zongjia.height = 30;
			zongjia.width = 150;
			closeImage.x = 54;
			closeImage.y = 866;
			zongjia.x = 428*2;
			zongjia.y = 64*2;
			zongjia.size = 20;
			saveContainer.visible = false;
			savedState.visible = false;
			userNameText.height = userPhoneText.height = userAddressText.height = guideText.height = 30;
			//userAddressText.type = userNameText.type = userPhoneText.type = guideText.type = TextFieldType.INPUT;
			userNameText.x = 67*2;
			userNameText.y = 38*2;
			var format:TextFormat = new TextFormat();
			format.size = 20;
			userNameText.defaultTextFormat = format;
			userAddressText.x = 67*2;
			userAddressText.y = 61*2;
			format = new TextFormat();
			format.size = 20;
			userAddressText.defaultTextFormat = format;
			
			userPhoneText.x = 220*2;
			userPhoneText.y = 38*2;
			format = new TextFormat();
			format.size = 20;
			userPhoneText.defaultTextFormat = format;
			guideText.x = 430*2;
			guideText.y = 38*2;
			format = new TextFormat();
			format.size = 20;
			guideText.defaultTextFormat = format;
			userNameText.width = 150;
			userAddressText.width = 600;
			userPhoneText.width = 150;
			guideText.width = 440+374;			
			productInfoScroller.x = 12;
			productInfoScroller.y = 220;
			
			noticeLabel.x = 500;
			noticeLabel.y = 680;
			noticeLabel.color="0xffff0000";
			noticeLabel.size = 12;
			noticeLabel.width = 250;
			noticeLabel.visible = false;
			saveContainer.addChild(noticeLabel);
			
			saveState.addEventListener(MouseEvent.CLICK,saveOrder);
			closeImage.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				hide();
			});
		}
		
		private function saveOrder(e:MouseEvent):void{
			
//			var localOrders:SharedObject = UserInfo.userLocalOrderData;
//			if(localOrders.data.orderlist == null){
//				localOrders.data.orderlist = new Dictionary();
//			}
//			var i:int = 1;
//			while(localOrders.data.orderlist[i.toString()]!=null&&localOrders.data.orderlist[i.toString()]!=""){
//				i++;
//			}
//			var key:String = i.toString();
//			
//			var jsonObject:Object = new Object();
//			jsonObject.to_address = userAddressText.text;
//			jsonObject.to_totalPrice = zongjia.text;
//			jsonObject.to_name = userNameText.text;
//			jsonObject.orderNo = key;
//			jsonObject.to_salesman = guideText.text;
//			jsonObject.to_tel = userPhoneText.text;
//			var productList:Array = new Array();
//			
//			for each(var product:Dictionary in orderInfoDic[Common.currentPath+"_"+kongjian]){
//				
//				var productData:Object = new Object();
//				productData.sc_name = product["brandName"];
//				productData.sc_money = product["price"];
//				productData.sc_number = product["num"];
//				productData.sc_guige = product["guige"];
//				productData.sc_prid = product["productId"];
//				productList.push(productData);
//			}
//			jsonObject.product = productList;
//			
//			var jsonString:String = JSON.stringify(jsonObject);
//			localOrders.data.orderlist[key] = jsonString;
//			localOrders.flush();
//			Common.loadURL("furniture/action/order/iosSaveTempOrder?JSESSIONID="+UserInfo.sessionID+"&ordersJson="+"["+jsonString+"]",onSaveUploaded,null);
//			Alert.alert("订单已保存");
		}
		
	}
}
















