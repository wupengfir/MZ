package page.functionpage.changeuser
{
	import com.greensock.TweenLite;
	import com.shangyi.component.base.Page;
	import com.shangyi.component.buttonRelated.Button;
	import com.shangyi.component.buttonRelated.SimpleButton;
	import com.shangyi.component.scrollerRelated.Scroller;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import json.JsonData;
	import json.JsonDecoder;
	
	import user.UserConfig;
	import user.UserInfo;
	
	public class ChangeUserPage extends Page
	{
		
		private var userText:TextField = new TextField();
		private var passText:TextField = new TextField();
		private var loginBtn:Button = new Button(110,70,242,462);
		private var loginedScroller:Scroller = new Scroller(210,200,1);
		private var loginedListBtn:Button = new Button(40,40,433,242);
		public function ChangeUserPage()
		{
			addChild(loginedListBtn);
			loginedListBtn.buttonMode = true;
			loginedListBtn.addEventListener(MouseEvent.CLICK,onLoginedClick);
			loginedScroller.visible = false;
			backSource = "data/img/ui/checkout3.png";
			backImage.width = 593;
			backImage.height = 589;
			
			userText.type = TextFieldType.INPUT;
			passText.type = TextFieldType.INPUT;
			
			userText.border = passText.border = false;
			userText.width = passText.width = 220;
			userText.height = passText.height = 30;
			userText.y = 235;
			passText.y = 288;
			
			passText.displayAsPassword = true;
			userText.x = passText.x = 195;
			
			userText.defaultTextFormat = new TextFormat("",20);
			passText.defaultTextFormat = new TextFormat("",20);
			
			
			addChild(userText);
			addChild(passText);
			
			addChild(loginBtn);
			loginBtn.buttonMode = true;
			loginBtn.addEventListener(MouseEvent.CLICK,onMouseClick);
			setCloseBtn(543,0);
		}
		
		private function onLoginedClick(e:MouseEvent):void{
			
			if(loginedScroller.visible){
				TweenLite.killTweensOf(loginedScroller);
				loginedScroller.visible = false;
				return;
			}
			loginedScroller.x = 366;
			loginedScroller.y = 280;
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
		
		private function onMouseClick(e:MouseEvent):void{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(Common.url+"furniture/action/user/iosLogin?name="+userText.text+"&password="+passText.text+"&change=1"));
			urlLoader.addEventListener(Event.COMPLETE, __completeHandler);
		}
		
		private function __completeHandler(evt:Event):void
		{
			var data:JsonData = JsonDecoder.decoderToJsonData(evt.currentTarget.data);
			if(data.success){
				if(UserConfig.loginedList.indexOf(userText.text) == -1){
					UserConfig.loginedList.push(userText.text);
					var data1:SharedObject = UserConfig.userConfigData;
					data1.data.loginedList = UserConfig.loginedList;
					data1.flush();
				}
				
				UserInfo.userName = data.dataValue.account;
				UserInfo.sessionID = data.dataValue.JSESSIONID;
				
				this.visible = false;
			}
			
		} 
		
	}
}





