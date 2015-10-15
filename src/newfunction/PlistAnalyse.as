package newfunction
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	public class PlistAnalyse
	{
		
		public static function analysePlist(plist:XML):Dictionary{
			var dic:Dictionary = new Dictionary();
			var maindict:XML = plist.dict[0];
			var currentKey:String;
			for each(var node:XML in maindict.children()){
				if(node.localName() == "key"){
					currentKey = node.text();
				}else{
					dic[currentKey] = node;
				}
			}
			return dic;
		}
		
		public function PlistAnalyse(path:String = "mzchunjing_bpmtest1.xml")
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(path));
			urlLoader.addEventListener(Event.COMPLETE,onLoadComplete);
		}
		
		private function onLoadComplete(e:Event):void{
				analysePlist(new XML(e.target.data));
		}
		
	}
}