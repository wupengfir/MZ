package
{
	import com.shangyi.component.base.Page;
	
	import flash.events.MouseEvent;

	
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
		
		public static function checkClick(mx:Number,my:Number,mw:Number,mh:Number,e:MouseEvent):Boolean{
			if(e.localX>mx&&e.localY>my&&e.localX<(mx+mw)&&e.localY<(my+mh)){
				return true;
			}
			return false;
		}

		
	}
}















