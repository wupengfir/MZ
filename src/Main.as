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
	
	import user.UserConfig;

	

	

	public class Main extends Page
	{
		public static var basePath:String;
		public static var currentPath:String;
		
		private var dic:Dictionary = new Dictionary();

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
		}
		
		
		private function init():void{
			loadXml();
		}
			
		private function loadXml():void{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(basePath + "data/xml/url.xml"));
			urlLoader.addEventListener(Event.COMPLETE,onLoadComplete);
		}

		
		private function onLoadComplete(e:Event):void{
			Common.url = ((new XML(e.target.data)).url.(@type=="common"))[0].attribute("path").toString();
			
			loadUserConfig();
			
			
			addChild(new LoginPage);
		}				
		
		private function loadUserConfig(){
			var data:SharedObject = UserConfig.userConfigData;
			if(data.data.autoLogin != null){
				UserConfig.autoLogin = data.data.autoLogin;
				trace(UserConfig.autoLogin);
			}else{
				data.data.autoLogin = false;
				data.flush();
			}
		}
		
	}
}














