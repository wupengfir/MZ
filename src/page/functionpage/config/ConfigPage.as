package page.functionpage.config
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.buttonRelated.Button;
	import com.shangyi.component.buttonRelated.SwitchButton;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import login.LoginPage;
	
	import page.alertpage.Alert;
	
	import user.UserConfig;
	
	public class ConfigPage extends Page
	{
		
		private var clearBtn:Button = new Button(200,50,10,5);
		private var logoutBtn:Button = new Button(200,50,840,5);
		private var showPriceBtn:SwitchButton = new SwitchButton(UserConfig.showPrice);
		public function ConfigPage()
		{
			backSource = "data/img/shezhijiantou.png";
			backImage.width = Common.MAX_WIDTH;
			backImage.height = 75;
			addChild(clearBtn);
			addChild(logoutBtn);
			
			showPriceBtn.x = 700;
			showPriceBtn.y = 8;
			addChild(showPriceBtn);
			
			showPriceBtn.addEventListener(Event.CHANGE,onShowPrice);
			clearBtn.addEventListener(MouseEvent.CLICK,onClearData);
			logoutBtn.addEventListener(MouseEvent.CLICK,onLogout);		
		}
		
		private function onClearData(e:MouseEvent):void{
			Alert.alert("已清除缓存");
		}
		
		private function onShowPrice(e:Event):void{
			UserConfig.showPrice = UserConfig.userConfigData.data.showPrice = showPriceBtn.selected;
			UserConfig.userConfigData.flush();
		}
		
		private function onLogout(e:MouseEvent):void{
			
			(Common.MAIN as Main).normalLayer.removeChildren();
			(Common.MAIN as Main).functionLayer.removeChildren();
			LoginPage.loginPage.visible = true;
		}
		
	}
}




























