package
{
	import com.shangyi.component.base.Page;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	
	public class Common
	{
		
		public static const MAX_WIDTH:Number = 1200;
		public static const MAX_HEIGHT:Number = 900;
		
		public static var SCREEN_WIDTH:Number = 0;
		public static var SCREEN_HEIGHT:Number = 0;
		public static var SCREEN_SCALEX:Number = 1;
		public static var SCREEN_SCALEY:Number = 1;
		
		public static var MAIN:Main;
		public static var url:String;
		
		public function Common()
		{
			
		}		
		
		public static function loadURL(path:String,f:Function,ef:Function):void{
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest = new URLRequest(Common.url + path);
			urlRequest.method = URLRequestMethod.POST;
			urlLoader.load(urlRequest);
			if(f != null)
			urlLoader.addEventListener(Event.COMPLETE, f);
			if(ef != null)
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ef);
		}
		
		public static function loadURLWithJSON(path:String,v:URLVariables,f:Function,ef:Function):void{
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest = new URLRequest(Common.url + path);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = v;			
			urlLoader.load(urlRequest);
			
			
			if(f != null)
				urlLoader.addEventListener(Event.COMPLETE, f);
			if(ef != null)
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ef);
		}
		
		public static function getImageUrljpg(iname:String):String{
			return Common.url+"furniture/images/"+iname+".jpg";
		}
		
		public static function getImageUrlpng(iname:String):String{
			return Common.url+"furniture/images/"+iname+".png";
		}
		
		public static function checkClick(mx:Number,my:Number,mw:Number,mh:Number,e:MouseEvent):Boolean{
			if(e.localX>mx&&e.localY>my&&e.localX<(mx+mw)&&e.localY<(my+mh)){
				return true;
			}
			return false;
		}

		
	}
}















