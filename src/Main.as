package
{


	
	import com.greensock.TweenLite;
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	import com.shangyi.component.scrollerRelated.Scroller;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import login.LoginPage;
	
	import page.alertpage.Alert;
	import page.alertpage.Confirm;
	import page.homepages.HomePage;
	import page.room.VideoSelectPage;
	
	import user.UserConfig;
	import user.UserInfo;

	

	

	public class Main extends Page
	{
		public static var basePath:String;
		public static var currentPath:String;
		
		private var dic:Dictionary = new Dictionary();
		
		private var logo:Image = new Image("data/img/logo.jpg");
		
		public var normalLayer:Page = new Page();
		public var functionLayer:Page = new Page();
		public var roomLayer:Page = new Page();
		public var MessageLayer:Page = new Page();
		public var loadingPage:LoadingMc = new LoadingMc();
		public function Main()
		{

			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.HIGH;
			stage.frameRate = 60;
			Common.MAIN = this;
			Common.SCREEN_WIDTH = 1200;
			Common.SCREEN_HEIGHT = 900;
			Common.SCREEN_SCALEX = this.scaleX = 1/3;
			Common.SCREEN_SCALEY = this.scaleY = 1/3;
			basePath = File.applicationDirectory.url;
			init();
			//Confirm.confirm("wer",this);
			//stage.addEventListener (Event.RESIZE,test);  
			//stage.addEventListener(MouseEvent.CLICK,onStageXClick);
			
		}
		
		private function onStageXClick (e:MouseEvent):void {  
			stage.nativeWindow.width = 1024+20;
			stage.nativeWindow.height = 768+42;
		}
		
		private function test (e:Event):void {  
			Common.SCREEN_SCALEX = this.scaleX = stage.stageWidth/Common.MAX_WIDTH;
			Common.SCREEN_SCALEY = this.scaleY = stage.stageHeight/Common.MAX_HEIGHT;
		}
		
		private function init():void{
			loadXml();
			showLogo();
			addChild(normalLayer);
			addChild(functionLayer);
			addChild(roomLayer);
			addChild(MessageLayer);
			
			MessageLayer.addChild(Alert.a);
			MessageLayer.addChild(Confirm.a);
			MessageLayer.addChild(loadingPage);
			loadingPage.visible = false;
		}
		
		public function set loading(flag:Boolean):void{
			if(flag){
				loadingPage.visible = true;
			}else{
				loadingPage.visible = false;
			}
		}
		
		private function showLogo():void{
			logo.width = Common.MAX_WIDTH;
			logo.height = Common.MAX_HEIGHT;
			logo.alpha = 0;
			normalLayer.addChild(logo);
			TweenLite.to(logo,1,{alpha:1,onComplete:function():void{
				TweenLite.to(logo,1,{onComplete:function():void{
					logo.clear();
					addChild(new LoginPage);
				}});
			}});
		}
		
		private function loadXml():void{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(basePath + "data/xml/url.xml"));
			urlLoader.addEventListener(Event.COMPLETE,onLoadComplete);
		}

		
		private function onLoadComplete(e:Event):void{
			Common.url = ((new XML(e.target.data)).url.(@type=="common"))[0].attribute("path").toString();			
			loadUserConfig();			
		}				
		
		private function loadUserConfig():void{
			var data:SharedObject = UserConfig.userConfigData;
			if(data.data.autoLogin != null){
				UserConfig.autoLogin = data.data.autoLogin;
			}else{
				data.data.autoLogin = false;
				data.flush();
			}
			
			if(data.data.keepPass != null){
				UserConfig.keepPass = data.data.keepPass;
			}else{
				data.data.keepPass = false;
				data.flush();
			}
			
			if(data.data.showPrice != null){
				UserConfig.showPrice = data.data.showPrice;
			}else{
				data.data.showPrice = false;
				data.flush();
			}
			
			if(data.data.loginedList != null){
				UserConfig.loginedList = data.data.loginedList;
			}else{
				
				data.data.loginedList = new Array;
				UserConfig.loginedList = data.data.loginedList;
				data.flush();
			}
			
			data = UserInfo.userData;
			if(data.data.userName != null){
				UserInfo.userName = data.data.userName;
			}else{
				UserInfo.userName = "";
				data.data.userName = "";
				data.flush();
			}
			
			if(data.data.passWord != null){
				UserInfo.passWord = data.data.passWord;
			}else{
				UserInfo.passWord = "";
				data.data.passWord = "";
				data.flush();
			}
			
			if(data.data.diyDataLoaded != null){
				UserInfo.diyDataLoaded = data.data.diyDataLoaded;
			}else{
				UserInfo.diyDataLoaded = new Array();
				data.data.diyDataLoaded = new Array();
				data.flush();
			}
			
			if(data.data.updateTimeDic != null){
				UserInfo.updateTimeDic = data.data.updateTimeDic;
			}else{
				UserInfo.updateTimeDic = new Dictionary();
				data.data.updateTimeDic = new Dictionary();
				data.flush();
			}
			
		}
		
	}
}














