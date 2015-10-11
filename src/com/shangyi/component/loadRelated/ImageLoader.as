package com.shangyi.component.loadRelated
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class ImageLoader
	{
		public static const pathArr:Array = new Array();
		public static const imageDic:Dictionary = new Dictionary();
		public static const imageLoader:Loader = new Loader();
		
		private static var loading:Boolean = false;
		private static var loadingPath:String;
		private static var listenerAdded:Boolean = false;
		
		public static function load(path:String,image:Image):void{
			if(!listenerAdded){
				listenerAdded = true;
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete,false,0,true);
				imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
			}
			if(imageDic[path] == null){
				imageDic[path] = new Array();
			}
			pathArr.push(path);
			imageDic[path].push(image);
			if(!loading){
				loadingPath = pathArr.pop();
				imageLoader.load(new URLRequest(loadingPath));
				loading = true;
			}
		}
		
		private static function onError(e:IOErrorEvent):void{
			loading = false;
			var temp:String = loadingPath;
			for each(var img:Image in imageDic[loadingPath]){
//				ImageLoader.load("img/test.png",img);
				img.source = "img/test.png";
			}
			delete imageDic[temp];
			if(pathArr.length>0&&!loading){
				loadingPath = pathArr.pop();
				imageLoader.load(new URLRequest(loadingPath));
				loading = true;
			}
		}
		
		private static function onLoadComplete(e:Event):void{
			loading = false;
			Image.imageDic[loadingPath] = e.target.content.bitmapData;
			for each(var img:Image in imageDic[loadingPath]){
				img.back.bitmapData = e.target.content.bitmapData;
				if(img._width != 0){
					img.width = img._width;
				}
				if(img._height != 0){
					img.height = img._height;
				}
			}
			delete imageDic[loadingPath];
			if(pathArr.length>0){
				loadingPath = pathArr.pop();
				imageLoader.load(new URLRequest(loadingPath));
				loading = true;
			}
		}
		
	}
}