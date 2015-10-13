package user
{
	import flash.net.SharedObject;

	public class UserConfig
	{
		public static const DATA_CONFIG_KEY:String = "DATA_CONFIG_KEY";
		
		public static var autoLogin:Boolean = false;
		
		public static var loginedList:Array;
		public function UserConfig()
		{
		}
		
		public static function get userConfigData():SharedObject{
			return SharedObject.getLocal(UserConfig.DATA_CONFIG_KEY);
		}
		
	}
}