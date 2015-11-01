package com.shangyi.component.imageRelated
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.loadRelated.ImageLoader;
	import com.shangyi.component.loadRelated.SY_ImageLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.Dictionary;
	
	public class Image extends Sprite
	{
		
		public static const GET_DATA:String = "GET_DATA";
		
		public static var imageDic:Dictionary = new Dictionary();
		
		public static var imageUseDic:Dictionary = new Dictionary();
		
		public static var urlToImageDic:Dictionary = new Dictionary();//当改变url对应的bitmapdata时用于通知image更新
		
		protected var _selected:Boolean = false;
		protected var shape:Shape;
		
		public var sourceURL:String;
		public var sourceUrlArray:Array = new Array();//图片使用中变换source
		
		public var back:Bitmap;
		public var info:Object;
		
		public var _width:Number = 0;
		public var _height:Number = 0;
		
		public var loading:Boolean = false;
		
		protected var _selectAble:Boolean = true;
		
		public var keepRatio:Boolean = false;
		public function Image(source:String = null,bm:Boolean = false,_w:Number = 0,_h:Number = 0,keep:Boolean = false)
		{
			back = new Bitmap();
			back.smoothing = true;
			addChild(back);
			shape = new Shape();
			addChild(shape);
			if(source){
				this.source = source;
			}
			if(bm){
				this.buttonMode = true;
			}
			if(_w!=0){
				width = _w;
			}
			if(_h!=0){
				height = _h;
			}
			keepRatio = keep;
		}
		
//		public function clearData():void{
//			if(this.back.bitmapData != null){
//				this.back.bitmapData.dispose();
//				delete Image.imageDic[this.sourceURL];
//			}
//		}
		
		public function scaleMax():void{
			width = Common.MAX_WIDTH;
			height = Common.MAX_HEIGHT;
		}
		
		public function set selectAble(flag:Boolean):void{
			_selectAble = flag;
			if(!_selectAble){
				shape.graphics.clear();
			}
		}
		
		public function loadSource(source:String):void{
			this.sourceURL = source;
			if(urlToImageDic[sourceURL]){
				if((urlToImageDic[sourceURL] as Array).indexOf(this) == -1){
					(urlToImageDic[sourceURL] as Array).push(this);
				}
				
			}else{
				urlToImageDic[sourceURL] = new Array();
				(urlToImageDic[sourceURL] as Array).push(this);
			}
			var dic:Dictionary = Image.imageDic;
			if(Image.imageDic[source] != null){
				back.bitmapData = Image.imageDic[source];
				back.smoothing = true;
				if(_width != 0){
					this.width = _width;
				}
				if(_height != 0){
					this.height = _height;
				}
				selected = _selected;
				loading = false;
				dispatchEvent(new Event(GET_DATA));
				if(sourceUrlArray.length > 0){
					this.source = sourceUrlArray[sourceUrlArray.length - 1]
				}
			}
			else{
				var load:SY_ImageLoader = new SY_ImageLoader();
				load.load(source,this);
				loading = true;
			}
		}
		
		public function set source(source:String):void{
			if(source == sourceURL){
				return;
			}
			if(sourceURL != null&&!loading){
				if(imageUseDic[this.sourceURL]){
					imageUseDic[this.sourceURL]--;
					if(imageUseDic[this.sourceURL] == 0){
						delete Image.imageDic[this.sourceURL];
						delete Image.imageUseDic[this.sourceURL]
						if(back.bitmapData){
							back.bitmapData.dispose();
						}
					}
				}
			}
			sourceUrlArray.push(source);
			if(Image.imageUseDic[source]){
				Image.imageUseDic[source]++;
			}else{
				Image.imageUseDic[source] = 1;
			}
			if(!loading){
				loadSource(sourceUrlArray.pop());
			}
		}
		
		public function set selected(flag:Boolean):void{
			if(!_selectAble){
				shape.graphics.clear();
				return;
			}
			this._selected = flag;
			if(flag){
				shape.graphics.lineStyle(5/scaleX,0xb75a16);
				shape.graphics.drawRect(0,0,this.width/scaleX,this.height/scaleY);
			}else{
				shape.graphics.clear();
			}
		}
		
		public function get selected():Boolean{
			return _selected;
		}
		
		override public function set width(_width:Number):void{
			this._width = _width;
			if(this.back.bitmapData != null){
				try{
					if(keepRatio){
						this.scaleX = this.scaleY = _width/this.back.bitmapData.width;
					}else{
						this.scaleX = _width/this.back.bitmapData.width;
					}
					
				}catch(e:Error){
					
				}				
			}
		}
		
//		override public function get width():Number{
//			return _width;
//		}
		
		override public function set height(_height:Number):void{
			this._height = _height;
			if(this.back.bitmapData != null){				
				try{
					if(keepRatio){
						this.scaleX = this.scaleY = _height/this.back.bitmapData.height;
					}else{
						this.scaleY = _height/this.back.bitmapData.height;
					}
					
				}catch(e:Error){
					
				}
			}
		}
		
//		override public function get height():Number{
//			return _height;
//		}
		
		public function clear():void{
			if(sourceURL == null){
				if(parent){
					parent.removeChild(this);
				}
				return;
			}
			if(imageUseDic[this.sourceURL]){
				imageUseDic[this.sourceURL]--;
				if(imageUseDic[this.sourceURL] == 0){
					delete Image.imageDic[this.sourceURL];
					delete Image.imageUseDic[this.sourceURL]
					if(back.bitmapData){
						back.bitmapData.dispose();
						//trace(this.sourceURL+"   disposed");
						back.bitmapData = null;
					}
				}
			}
//			back = null;
			if(this.parent){
				this.parent.removeChild(this);
			}
			(urlToImageDic[sourceURL] as Array).splice((urlToImageDic[sourceURL] as Array).indexOf(this),1);
			sourceURL = null;
			System.gc();
		}
		
	}
}