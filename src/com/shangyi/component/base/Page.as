package com.shangyi.component.base
{
	
	import com.shangyi.component.imageRelated.Image;
	import com.shangyi.component.scrollerRelated.Scroller;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.Dictionary;
	
	public class Page extends Sprite
	{
		
		private var back:Bitmap;
		public var sourceURL:String;
		public var backImage:Image;
		public static var SCALEX:Number;
		public static var SCALEY:Number;

		
		public static var eventAccept:Boolean = true;
		public static var eventadded:Boolean = false;
		
		public var info:Object;
		
		public function Page()
		{
			
			backImage = new Image();
			//trace(this["backImage"]);
			addChild(backImage);
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
		}
		
		private var stack:Array = new Array();
		protected function initByPageScript(root:XML):void{
			var target:XML;
			var currentParent:Object = this;
			stack.push(root);
			while(stack.length>0){
				target = stack.pop();
				if(target != root){
					currentParent = this[target.attribute("name").toString()];
				}
				for each(var xml:XML in target.children()){
					if(xml.children().length != 0){
						stack.push(xml);
					}
					if(xml.hasOwnProperty("@x")){
						this[xml.attribute("name").toString()].x = Number(xml.attribute("x").toString());
					}
					if(xml.hasOwnProperty("@y")){
						this[xml.attribute("name").toString()].y = Number(xml.attribute("y").toString());
					}
					//trace(xml.hasOwnProperty("@visible")+"@@@");
					if(xml.hasOwnProperty("@visible")){
						this[xml.attribute("name").toString()].visible = xml.attribute("visible").toString() == "true"?true:false;
						//trace(this[xml.attribute("name").toString()].visible);
					}
					currentParent.addChild(this[xml.attribute("name").toString()]);
				}
			}
			
		}
		
		private function onAdd(e:Event):void{
			if(!eventadded){
				stage.addEventListener(MouseEvent.CLICK,terminate,true);
				stage.addEventListener(MouseEvent.MOUSE_MOVE,terminate,true);
				stage.addEventListener(MouseEvent.MOUSE_DOWN,terminate,true);
				stage.addEventListener(MouseEvent.MOUSE_UP,terminate,true);
				stage.addEventListener(MouseEvent.MOUSE_OVER,terminate,true);
				stage.addEventListener(MouseEvent.MOUSE_OUT,terminate,true);
				eventadded = true;
			}
		}
		
		public function close(e:Object = null):void{
			clearAll(this);
			clear();
		}
		
		
		
		public function setCloseBtn(cx:Number,cy:Number,level:int = 0):void{
			var cbtn:Image = new Image("data/img/close.png");
			cbtn.x = cx;
			cbtn.y = cy;
			addChild(cbtn);
			if(level == 0){
				cbtn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
					e.currentTarget.parent.visible = false;
				});
			}else if(level == 1){
				cbtn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
					close();
				});
			}
		}
		
		private function terminate(e:MouseEvent):void{
			if(!eventAccept){
				e.stopImmediatePropagation();
			}
		}
		
		public function set backSource(source:String):void{
			backImage.source = source;
//			this.sourceURL = source;
//			if(Image.imageDic[source] != null){
//				back.bitmapData = Image.imageDic[source];
//			}
//			else{
//				var load:Loader = new Loader();
//				load.load(new URLRequest(source));
//				load.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete,false,0,true);
//			}
		}
		
		public function drawBack(_width:Number = Common.MAX_WIDTH,_height:Number = Common.MAX_HEIGHT,color:uint = 0xffffff,al:Number = 1):void{
			graphics.beginFill(color,al);
			graphics.drawRect(0,0,_width,_height);
			graphics.endFill();
		}
		
		public function drawLine(sx:Number,sy:Number,dx:Number,dy:Number,color:uint = 0,thick:Number = 2):void{
			graphics.lineStyle(thick,color);
			graphics.moveTo(sx,sy);
			graphics.lineTo(dx,dy);
		}
		
		public function clearAll(par:DisplayObjectContainer):void{
			var obj:DisplayObject;
			while(par.numChildren > 0){
				obj = par.getChildAt(par.numChildren - 1);
				if(obj is Image){
					(obj as Image).clear();
				}else if(obj is Scroller){
					(obj as Scroller).clear();
				}
				else if(obj is DisplayObjectContainer){
					clearAll(obj as DisplayObjectContainer);
					par.removeChild(obj);
				}else{
					par.removeChild(obj);
				}				
			}
			
		}
		
		private function onLoadComplete(e:Event):void{
			Image.imageDic[sourceURL] = e.target.content.bitmapData;
			back.bitmapData = e.target.content.bitmapData;
		}
		
		public function addButton(ix:int,iy:int,name:String,iWidth:int = 50,iHeight:int = 30):void{
			var button:Sprite = new Sprite();
			button.graphics.beginFill(0x000000,0);
			button.graphics.drawRect(0,0,iWidth,iHeight);
			button.graphics.endFill();
			button.name = name;
			addChild(button);
		}
		
		public function clear():void{
			backImage.clear();
			if(this.parent){
				this.parent.removeChild(this);
			}
			System.gc();
		}
		
	}
}