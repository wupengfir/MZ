package login
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	//import org.osmf.events.TimeEvent;
	
	public class LoginPage extends Page
	{
		private var productionID:String = "undefined";
		private var userText:TextField = new TextField();
		private var passText:TextField = new TextField();
		private var udid:TextField = new TextField();
		private var loginBtn:TextField = new TextField();
		private var info:TextField = new TextField();
		
		private var btnContainer = new Sprite();
		private var timerOnLine:Timer;
		private var timerOffLine:Timer;
		private var timeroutLine:Timer = new Timer(10*1000);
		
		private var address:String = "www.pauchie.com.cn:8180";
		//private var address:String = "222.125.72.173:8280"
		
		private var btnImage:Image = new Image();
		private var xml:XML;
		
		private var timeOffLineMini:Number;
		
		private var halfHourTimer:Timer = new Timer(5*60*1000);
		
		
		public function LoginPage()
		{
//			sharedObject = SharedObject.getLocal("offlineTime");
//			sharedObject.clear();
			checkTime();
			initPage();
			halfHourTimer.addEventListener(TimerEvent.TIMER,onTimer);
			timeroutLine.addEventListener(TimerEvent.TIMER,ontwenty);
			halfHourTimer.start();
			

			
		}
		

		private function onTimer(e:TimerEvent):void{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest("http://www.dajinge.com/ipad/user.php?username="+userText.text+"&password="+passText.text));
			trace("http://www.dajinge.com/ipad/user.php?username="+userText.text+"&password="+passText.text+"   halfhpur");
			urlLoader.addEventListener(Event.COMPLETE, __completeHandler1);
			timeroutLine.start();
		}
		
		private function ontwenty(e:TimerEvent):void{
			parent.addChild(this);
			this.visible = true;
			timeroutLine.stop();
		}
		
		private function __completeHandler1(evt:Event):void
		{
			try
			{
				trace("!!!!"+evt.currentTarget.data.toString()+"!!!!");
				xml = new XML(evt.currentTarget.data.toString());
				if(xml.status.toString() == "OK"){					
					timeroutLine.stop();
				}else{
					info.text = xml.message.toString();
				}
			}
			catch (err:Error)
			{
				trace("ERROR:" + err.getStackTrace());
			}
			
		} 
		
		private function __completeHandler(evt:Event):void
		{
			try
			{
				trace("333@@##$$%%"+evt.currentTarget.data.toString()+"!!@@##$$%%");
				xml = new XML(evt.currentTarget.data.toString());
				if(xml.status.toString() == "OK"){
					
					this.visible = false;					
					sharedObject = SharedObject.getLocal("offlineTime");
					sharedObject.data.loginTime = new Date().time;
					sharedObject.flush();
					
				}else{
					info.text = xml.message.toString();
				}
			}
			catch (err:Error)
			{
				trace("ERROR:" + err.getStackTrace());
			}
		} 
		
		
		private function loadPhp():void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest("http://www.dajinge.com/ipad/user.php?username="+userText.text+"&password="+passText.text));
			trace("http://www.dajinge.com/ipad/user.php?username="+userText.text+"&password="+passText.text);
			urlLoader.addEventListener(Event.COMPLETE, __completeHandler);
		}
		
//		private function onCompletedHandle(event:Event):void {
//			trace(event.currentTarget.data.toString());
//			var xml:XML = new XML(event.currentTarget.data.toString());
//			trace(xml.status == "OK");
//		}
		
		private var sharedObject:SharedObject;
		private static const offlineTimeAllowed:Number = 1000;
		private var checkTimeFalseTimer:Timer;
		private function checkTime():Boolean{
			sharedObject = SharedObject.getLocal("offlineTime");
			if(sharedObject.data.loginTime == undefined || sharedObject.data.loginTime == null){
				return false;
			}
			var timeLeft:Number = offlineTimeAllowed - new Date().time + (sharedObject.data.loginTime as Number);
			trace(timeLeft);
			if(timeLeft > 0){
				this.visible = false;
				return true;
			}else{
				return false;
			}
		}
		
		private function __onIOError(evt:Event):void
		{
			
		}
		
		public function initPage():void{
			backSource = "img/login.png";
			backImage.x = 200;
			backImage.y = 130;
			graphics.beginFill(0xffffff,0.4);
			graphics.drawRect(0,0,1024,768);
			graphics.endFill();
			
			btnImage.source = "img/btn.png";
			btnImage.x = 445;
			btnImage.y = 350;
			btnImage.visible = false;
			btnImage.mouseChildren = btnImage.mouseEnabled = false;
			addChild(btnImage);
			
			var format1:TextFormat = new TextFormat();
			format1.size = 20;
			var format2:TextFormat = new TextFormat();
			format2.size = 30;
			userText.type = TextFieldType.INPUT;
			passText.type = TextFieldType.INPUT;
			udid.type = TextFieldType.INPUT;
			userText.border = passText.border = false;
			userText.width = passText.width = 385;
			userText.height = passText.height = udid.height = 30;
			userText.y = 215;
			passText.y = 262;
			//			userText.setTextFormat(format1);
			//userText.defaultTextFormat = new TextFormat("",20,0xff3399);
			passText.displayAsPassword = true;
			udid.y = 285;
			udid.width = 1000;
			udid.height = 30;
			udid.setTextFormat(format1);
			userText.x = passText.x = udid.x = 330;
			
			info.text = "";
			info.x = 350;
			info.y = 315;
			info.width = 1000;
			info.height = 30;
			info.setTextFormat(format1);
			
			userText.defaultTextFormat = new TextFormat("",20);
			passText.defaultTextFormat = new TextFormat("",20);
			udid.defaultTextFormat = new TextFormat("",20);
			info.defaultTextFormat = new TextFormat("",20);
			
			//			userText.addEventListener(Event.CHANGE,function(e:Event):void{userText.setTextFormat(format1);});
			//			passText.addEventListener(Event.CHANGE,function(e:Event):void{passText.setTextFormat(format1);});
			//			udid.addEventListener(Event.CHANGE,function(e:Event):void{udid.setTextFormat(format1);});
			//			info.addEventListener(Event.CHANGE,function(e:Event):void{info.setTextFormat(format1);});
			
			btnContainer.x = 380;
			btnContainer.y = 340;
			btnContainer.graphics.beginFill(0x00ff00,0);
			btnContainer.graphics.drawRect(0,0,150,50);
			btnContainer.graphics.endFill();
			btnContainer.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent):void{
				btnImage.visible = true;			});
			btnContainer.addEventListener(MouseEvent.MOUSE_UP,function(e:MouseEvent):void{
				btnImage.visible = false;			});
			btnContainer.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				
							loadPhp();
//				info.text = "";
//				var re:RequestController = new RequestController();
//				var xx:URLVariables = new URLVariables();
//				re.addEventListener(Event.COMPLETE, __completeHandler);
//				//trace("http://e.lvmofa.com/ipad/user.php?username="+userText.text+"&password="+passText.text+"1111111111111111111111111111");
//				re.request(URLRequestMethod.GET,"http://e.lvmofa.com/ipad/user.php?username="+userText.text+"&password="+passText.text,xx);			
			});
			addChild(btnContainer);
			addChild(userText);
			addChild(passText);
			//addChild(udid);
			addChild(info);
		}
		
	}
}






















