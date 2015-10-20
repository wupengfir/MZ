package user
{
	import flash.net.SharedObject;
	import flash.utils.Dictionary;

	public class UserInfo
	{
		
		public static const DATA_KEY:String = "DATA_KEY";
		
		public static var userName:String;
		public static var passWord:String;
		public static var sessionID:String;
		//public static var userData:SharedObject = SharedObject.getLocal(UserInfo.DATA_KEY);
		
		public static var diyDataLoaded:Array;
		public static var updateTimeDic:Object;
		
		public function UserInfo()
		{
		}
		
		public static function get userData():SharedObject{
			return SharedObject.getLocal(UserInfo.DATA_KEY);
		}
		
	}
}