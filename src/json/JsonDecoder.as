package json
{

	public class JsonDecoder
	{
		public function JsonDecoder()
		{
		}
		
		public static function decoderToJsonData(o:Object):JsonData{
			var data:JsonData = new JsonData();
			var container:Object = JSON.parse(o.toString());
			data.success = (container.code == "0");
			data.msg = container.msg;
			data.dataValue = container.data;
			return data;
		}
		
		public static function decoderPriceSyncToJsonData(o:Object):JsonData{
			var data:JsonData = new JsonData();
			var container:Object = JSON.parse(o.toString());
			data.success = (container.success == "0");
			data.msg = container.message;
			data.dataValue = container.data;
			return data;
		}
		
	}
}