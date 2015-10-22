package login
{
	import com.greensock.TweenLite;
	import com.shangyi.component.base.Page;
	import com.shangyi.component.buttonRelated.Button;
	import com.shangyi.component.buttonRelated.SimpleButton;
	import com.shangyi.component.imageRelated.Image;
	import com.shangyi.component.scrollerRelated.Scroller;
	
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
	
	import json.JsonData;
	import json.JsonDecoder;
	
	import page.homepages.HomePage;
	
	import user.UserConfig;
	import user.UserInfo;
	
	//import org.osmf.events.TimeEvent;
	
	public class LoginPage extends Page
	{
		private var productionID:String = "undefined";
		private var userText:TextField = new TextField();
		private var passText:TextField = new TextField();
		private var udid:TextField = new TextField();
		private var loginBtn:Button = new Button(320,40,440,480);
		private var loginedListBtn:Button = new Button(40,40,739,356);
		private var info:TextField = new TextField();
		


		
		private var btnImage:Image = new Image();
		private var xml:XML;
		
		private var timeOffLineMini:Number;
		
		private var halfHourTimer:Timer = new Timer(5*60*1000);
		
		private var loginedScroller:Scroller = new Scroller(210,200,1);
		
		public function LoginPage()
		{
			autoLogin();
			initPage();		
			loginedScroller.visible = false;
		}
		
		private function autoLogin():void{
			if(UserConfig.autoLogin){
				
			}
		}
		
		private function onMouseClick(e:MouseEvent):void{
			
			
			
			loadPhp();
		}
		
		private function onLoginedClick(e:MouseEvent):void{
			
			if(loginedScroller.visible){
				TweenLite.killTweensOf(loginedScroller);
				loginedScroller.visible = false;
				return;
			}
			loginedScroller.x = 650;
			loginedScroller.y = 383;
			loginedScroller.visible = true;
			loginedScroller.alpha = 0;
			addChild(loginedScroller);
			loginedScroller.clearContent();
			
			var index:int = 0;
			for each(var username:String in UserConfig.loginedList){
				var btn:SimpleButton = new SimpleButton(200,30);
				btn.label = username;
				btn.name = username;
				btn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
					userText.text = e.currentTarget.name;
					passText.text = "";
					loginedScroller.visible = false;
				});
				btn.y = index*30;
				loginedScroller.addChild(btn);
				index++;
			}
			
			TweenLite.to(loginedScroller,2,{alpha:1});
			
		}
		
		private function __completeHandler(evt:Event):void
		{
			var data:JsonData = JsonDecoder.decoderToJsonData(evt.currentTarget.data);
			if(data.success){
				if(UserConfig.loginedList.indexOf(userText.text) == -1){
					UserConfig.loginedList.push(userText.text);
					trace(UserConfig.loginedList.length);
					var data1:SharedObject = UserConfig.userConfigData;
					data1.data.loginedList = UserConfig.loginedList;
					data1.flush();
				}
				
				UserInfo.userName = data.dataValue.account;
				UserInfo.sessionID = data.dataValue.JSESSIONID;
				
				this.clear();
				(Common.MAIN as Main).normalLayer.addChild(new HomePage);
			}
			
		} 
		
		
		private function loadPhp():void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(Common.url+"furniture/action/user/iosLogin?name="+userText.text+"&password="+passText.text+"&change=0"));
			urlLoader.addEventListener(Event.COMPLETE, __completeHandler);
		}		
		
		private function __onIOError(evt:Event):void
		{
			
		}
		
		private function coverPathGot(evt:Event):void
		{
			var data:JsonData = JsonDecoder.decoderToJsonData(evt.currentTarget.data);
			if(data.success){
				backSource = Common.url+"furniture/images/"+data.dataValue.coverIma+".jpg";
			}
		} 
		
		private function coverPathGotError(e:IOErrorEvent):void{
			backSource = "data/img/default.jpg";
		}
		
		public function initPage():void{
			backImage.width = Common.MAX_WIDTH;
			backImage.height = Common.MAX_HEIGHT;
			Common.loadURL("furniture/action/davert/iosCover",coverPathGot,coverPathGotError);
			
			var format1:TextFormat = new TextFormat();
			format1.size = 20;
			var format2:TextFormat = new TextFormat();
			format2.size = 30;
			userText.type = TextFieldType.INPUT;
			passText.type = TextFieldType.INPUT;
			udid.type = TextFieldType.INPUT;
			userText.border = passText.border = false;
			userText.width = passText.width = 220;
			userText.height = passText.height = udid.height = 30;
			userText.y = 350;
			passText.y = 410;

			passText.displayAsPassword = true;
			udid.y = 285;
			udid.width = 1000;
			udid.height = 30;
			udid.setTextFormat(format1);
			userText.x = passText.x = udid.x = 500;
			
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
			
			addChild(userText);
			addChild(passText);
			addChild(info);
			
			addChild(loginBtn);
			loginBtn.buttonMode = true;
			loginBtn.addEventListener(MouseEvent.CLICK,onMouseClick);
			
			addChild(loginedListBtn);
			loginedListBtn.buttonMode = true;
			loginedListBtn.addEventListener(MouseEvent.CLICK,onLoginedClick);
			
		}
		
	}
}






















