package com.shangyi.component.loadRelated
{
	import com.shangyi.component.imageRelated.Image;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	public class SY_ImageLoader extends EventDispatcher
	{
		public static const COMPLETE:String = "IMAGE_LOAD_COMPLETE";
		private static var pathDic:Dictionary = new Dictionary();;
		
		public var path:String;
		
		private var targetArray:Array;
		private var loader:Loader;
		public function SY_ImageLoader()
		{
			targetArray = new Array();
			loader = new Loader();
		}
		
		public function load(path:String,target:Image):void{
			this.path = path;
			if(pathDic[path]){
				(pathDic[path] as SY_ImageLoader).targetArray.push(target);
			}else{
				pathDic[path] = this;
				targetArray.push(target);
				loader.load(new URLRequest(path));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete,false,0,true);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError,false,0,true);
			}
		}
		
		private function onError(e:IOErrorEvent):void{
			trace(path);
			for each(var img:Image in this.targetArray){
				img.loading = false;
			}
		}
		
		private function onLoadComplete(e:Event):void{
			Image.imageDic[path] = e.target.content.bitmapData;
			for each(var img:Image in this.targetArray){
				img.loadSource(path);
			}
			delete pathDic[path];
			this.dispatchEvent(new Event(SY_ImageLoader.COMPLETE));
		}
		
	}
}