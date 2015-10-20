package page.functionpage.changeuser
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.buttonRelated.Button;
	
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
		private var loginBtn:Button = new Button(320,40,440,480);
		
		public function ChangeUserPage()
		{
			backSource = "data/img/ui/checkout3.png";
			backImage.width = 450;
			backImage.height = 450;
			
			userText.type = TextFieldType.INPUT;
			passText.type = TextFieldType.INPUT;
			
			userText.border = passText.border = false;
			userText.width = passText.width = 220;
			userText.height = passText.height = 30;
			userText.y = 350;
			passText.y = 410;
			
			passText.displayAsPassword = true;
			userText.x = passText.x = 100;
			
			userText.defaultTextFormat = new TextFormat("",20);
			passText.defaultTextFormat = new TextFormat("",20);
			
			
			addChild(userText);
			addChild(passText);
			
			addChild(loginBtn);
			loginBtn.buttonMode = true;
			loginBtn.addEventListener(MouseEvent.CLICK,onMouseClick);
			
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





