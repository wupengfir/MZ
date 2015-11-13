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
	import flash.utils.Dictionary;

	
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
		
		public static var currentColor:String = "shense";
		public static var currentPath:String = "mzchunjing";
		public static var currentRoomData:Dictionary;
		public static var currentRoomDicDic:Dictionary;
		
		public function Common()
		{
			
		}		
		
		public static function RGB(r:int,g:int,b:int):uint{
			return uint(0xff|(r<<16)|(g<<8)|b);
		}
		
		public static function plistToDictionary(plist:XML):void{
			var dic:Dictionary = new Dictionary();
			currentRoomDicDic = new Dictionary();
			var maindict:XML = plist.dict[0];
			var currentKey:String;
			for each(var node:XML in maindict.children()){
				if(node.localName() == "key"){
					currentKey = node.text();
				}else{
					if(node.localName() == "array"){
						dic[currentKey] = getArray(node);
					}else if(node.localName() == "dict"){
						dic[currentKey] = getDict(node,dic);
					}else if(node.localName() == "string"){
						dic[currentKey] = node.text().toString();
					}
				}
			}
			currentRoomData = dic;
		}
		
//		public static function getDictionary(key:String):Dictionary{
//			var xml:XML;
//			while(xml.dict.length>0){
//				for each(var dic:){
//					
//				}
//			}
//		}
		
		private static function getArray(xml:XML):Array{
			var array:Array = new Array();
			for each(var node:XML in xml.children()){
				if(node.localName() == "dict"){
					array.push(getDict(node,array));
				}
			}
			return array;
		}
		
		private static function getDict(xml:XML,p:Object):Dictionary{
			var dict:Dictionary = new Dictionary();
			var currentKey:String;
			for each(var node:XML in xml.children()){
				if(node.localName() == "key"){
					currentKey = node.text();
				}else{
					if(node.localName() == "array"){
						dict[currentKey] = getArray(node);
					}else if(node.localName() == "dict"){						
						dict[currentKey] = getDict(node,dict);
					}else if(node.localName() == "string"){
						dict[currentKey] = node.text().toString();
					}
					dict["parent"] = p;
				}
			}
			if(dict["source"] != null){
				currentRoomDicDic[dict["source"]] = dict;
			}
			return dict;
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
		
		public static function getVideoPath(type:String):String{
			return Main.basePath+"data/img/"+currentPath+"/"+currentColor+"/video/Video-"+currentColor+"_"+type+".flv";
		}
		
		public static function getBigImagePath(type:String):String{
			return Main.basePath+"data/img/"+currentPath+"/"+currentColor+"/bigImg/"+type;//Main.basePath+"img/fengge/"+FenggeSelectPage.currentPath+"/"+Main.currentColor+"/"+type;
		}
		
		public static function getThumbImagePath(type:String):String{
			return Main.basePath+"data/img/"+currentPath+"/"+currentColor+"/thumb/"+type;//Main.basePath+"img/fengge/"+FenggeSelectPage.currentPath+"/"+Main.currentColor+"/"+type;
		}
		
		public static function getZoomImagePath(type:String):String{
			return Main.basePath+"data/img/"+currentPath+"/"+currentColor+"/zoomout/"+type;//Main.basePath+"img/fengge/"+FenggeSelectPage.currentPath+"/"+Main.currentColor+"/"+type;
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















