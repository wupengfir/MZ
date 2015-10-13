package
{
	import com.shangyi.component.base.Page;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	
	public class Common
	{
		
		public static const MAX_WIDTH:Number = 1200;
		public static const MAX_HEIGHT:Number = 900;
		
		public static var SCREEN_WIDTH:Number = 0;
		public static var SCREEN_HEIGHT:Number = 0;
		public static var SCREEN_SCALEX:Number = 1;
		public static var SCREEN_SCALEY:Number = 1;
		
		public static var MAIN:Page;
		public static var url:String;
		
		public function Common()
		{
			
		}		
		
		public static function loadURL(path:String,f:Function,ef:Function):void{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(Common.url+path));
			if(f != null)
			urlLoader.addEventListener(Event.COMPLETE, f);
			if(ef != null)
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ef);
		}
		
		public static function checkClick(mx:Number,my:Number,mw:Number,mh:Number,e:MouseEvent):Boolean{
			if(e.localX>mx&&e.localY>my&&e.localX<(mx+mw)&&e.localY<(my+mh)){
				return true;
			}
			return false;
		}

		
	}
}















