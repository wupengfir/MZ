package com.shangyi.component.scrollerRelated
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.buttonRelated.ImageButton;
	import com.shangyi.component.imageRelated.Image;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.System;
	
	public class Scroller extends Sprite
	{
		public var content:Sprite = new Sprite();
		private var maskSp:Sprite;
		private var _type:int;//0横向1竖向
		public  var maxWidth:Number;
		public  var maxHeight:Number;
		private var addChildWithSelf:Boolean = true;
		private var sourceURL:String;
		private var contentArr:Array;
		
		public var btnArr:Array = new Array();
		//决定scroller的组件可被选择
		private var _selectAble:Boolean = true;
		//决定scroller包含的组件是否接受click事件
		public var contentClickAble:Boolean = true;
		
		private var sliderContainer:Sprite = new Sprite();
		private var rootSroller:Scroller;
		
		public static var scrollerList:Array = new Array();
		public static var listenerAdded:Boolean = false;
		public function Scroller(_width:int,_height:int,type:int = 0)
		{
			scrollerList.push(this);
			_type =type;
			maxHeight = _height;
			maxWidth = _width;
			maskSp = new Sprite();
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(0,0,_width,_height);
			this.graphics.endFill();
			maskSp.graphics.beginFill(0x000000,0);
			maskSp.graphics.drawRect(0,0,_width,_height);
			maskSp.graphics.endFill();
			this.addChild(content);
			this.addChild(maskSp);
			content.mask = maskSp;
			addEventListener(MouseEvent.MOUSE_DOWN,down);
			addEventListener(MouseEvent.MOUSE_UP,up);
//			addEventListener(MouseEvent.MOUSE_OUT,up);
//			addEventListener(MouseEvent.MOUSE_OUT,up);
			addEventListener(MouseEvent.CLICK,onClick,true);
			addChildWithSelf = false;
			rootSroller = this;
			addEventListener(Event.REMOVED_FROM_STAGE,function(e:Event){
				rootSroller.stage.removeEventListener(MouseEvent.MOUSE_UP,onSliderUp);
				rootSroller.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onSliderMove);
			});
			addEventListener(Event.ADDED_TO_STAGE,function(e:Event){
				if(!listenerAdded){
					rootSroller.stage.addEventListener(MouseEvent.MOUSE_UP,onStageUP);
					listenerAdded = true;
				}
			});
		}
		
		private function onStageUP(e:MouseEvent):void{
			for each(var s:Scroller in scrollerList){
				s.up(e);
				
			}
		}
		
		public function setmasksize(w:Number,h:Number):void{
			addChildWithSelf = true;
			content.mask = null;
			this.removeChild(maskSp);
			maskSp = new Sprite();
			this.addChild(maskSp);
			w = w==0?maxWidth:w;
			h = h==0?maxHeight:h;
			maskSp.graphics.clear();
			maskSp.graphics.beginFill(0x000000,0);
			maskSp.graphics.drawRect(0,0,w,h);
			maskSp.graphics.endFill();
			content.mask = maskSp;
			addChildWithSelf = false;
		}
		
		private var sliderBtn:Sprite = new Sprite();
		private function initSlider(base:Number):void{
			addChildWithSelf = true;
			addChild(sliderContainer);
			addChildWithSelf = false;
			sliderContainer.addChild(sliderBtn);
			addEventListener(Event.ENTER_FRAME,rePaintSlider);
			sliderBtn.addEventListener(MouseEvent.MOUSE_DOWN,onSliderDown);
			sliderBtn.addEventListener(MouseEvent.MOUSE_UP,onSliderUp);
			if(stage){
				stage.addEventListener(MouseEvent.MOUSE_UP,onSliderUp);
			}else{
				
				addEventListener(Event.ADDED_TO_STAGE,function(e:Event){rootSroller.stage.addEventListener(MouseEvent.MOUSE_UP,onSliderUp);});
			}
			if(_type == 0){
				sliderContainer.y = maxHeight+10+base;
			}else{
				sliderContainer.x = maxWidth+10+base;
			}
		}
		private var downSliderPosition:Number;
		private var downMousePosition:Number;
		private function onSliderDown(e:MouseEvent):void{
			trace("downdown");
			if(_type == 0){
				downMousePosition = e.stageX;
				downSliderPosition = sliderBtn.x;
			}else{
				downMousePosition = e.stageY;
				downSliderPosition = sliderBtn.y;
			}
			if(stage){
				if(!stage.hasEventListener(MouseEvent.MOUSE_MOVE))
				stage.addEventListener(MouseEvent.MOUSE_MOVE,onSliderMove);
			}else{
				addEventListener(Event.ADDED_TO_STAGE,function(e:Event){rootSroller.stage.addEventListener(MouseEvent.MOUSE_MOVE,onSliderMove);});
			}
			e.stopPropagation();
		}
		
		private function onSliderUp(e:MouseEvent):void{
			sliderBtn.removeEventListener(MouseEvent.MOUSE_MOVE,onSliderMove);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onSliderMove);
			//trace("ss");
		}
		
		private function onSliderMove(e:MouseEvent):void{
			var temp:Number;
			if(_type == 0){
				temp = downSliderPosition + e.stageX - downMousePosition;
				if(temp >= 0 && temp <= maxWidth - currentSliderBtnSize){
					sliderBtn.x = temp;
					content.x = -sliderBtn.x/(maxWidth - currentSliderBtnSize)*(content.width-maxWidth);
				}
			}else{
				temp = downSliderPosition + e.stageY - downMousePosition;
				if(temp >= 0 && temp <= maxHeight - currentSliderBtnSize){
					sliderBtn.y = temp;
					content.y = -sliderBtn.y/(maxHeight - currentSliderBtnSize)*(content.height-maxHeight);
				}
			}
			e.stopPropagation();
		}
		
		private var oldSize:Number = 0;
		private var currentSliderBtnSize:Number = 0;
		private function rePaintSlider(e:Event):void{
			var newSize:Number = _type==0?content.width:content.height;
			if(newSize == 0){
				sliderContainer.graphics.clear();
				sliderContainer.graphics.beginFill(0xcccccc,1);
				sliderBtn.graphics.clear();
				return;
			}
			if(_type == 0 && newSize<=maxWidth){
				sliderContainer.graphics.clear();
				sliderContainer.graphics.beginFill(0xcccccc,1);
				sliderBtn.graphics.clear();
				return;
			}
			if(_type == 1 && newSize<=maxHeight){
				sliderContainer.graphics.clear();
				sliderContainer.graphics.beginFill(0xcccccc,1);
				sliderBtn.graphics.clear();
				return;
			}
			if(newSize != oldSize){
				sliderContainer.graphics.clear();
				sliderContainer.graphics.beginFill(0xcccccc,1);
				sliderBtn.graphics.clear();
				sliderBtn.graphics.beginFill(0xffffff,1);
				if(_type == 0){
					if(content.width == 0){
						return;
					}
					sliderContainer.x = maxWidth*0.1;
					sliderContainer.graphics.drawRoundRect(0,0,maxWidth,sliderThickness,sliderThickness/3);
					sliderContainer.graphics.endFill();
					sliderBtn.x = 0;
					sliderBtn.graphics.drawRoundRect(0,-sliderThickness*0.5,maxWidth*(maxWidth/content.width),sliderThickness,sliderThickness*2);
					sliderBtn.graphics.endFill();
					var sp:Shape = new Shape();
					sp.graphics.beginFill(0xff0000,0);
					sp.graphics.drawRect(-20,0,45,0.8*maxHeight*(maxHeight/content.height));
					sp.graphics.endFill();
					currentSliderBtnSize = maxWidth*(maxWidth/content.width);
					sliderBtn.addChild(sp);
				}else{
					if(content.height == 0){
						return;
					}
					sliderContainer.y =0// maxHeight*0.1;
					sliderContainer.graphics.drawRoundRect(0,0,sliderThickness,maxHeight,sliderThickness);
					sliderContainer.graphics.endFill();
					sliderBtn.y = 0;
					sliderBtn.graphics.drawRoundRect(0,0,sliderThickness,maxHeight*(maxHeight/content.height),sliderThickness);
					sliderBtn.graphics.endFill();
					var sp:Shape = new Shape();
					sp.graphics.beginFill(0xff0000,0);
					sp.graphics.drawRect(-20,0,45,maxHeight*(maxHeight/content.height)<30?30:maxHeight*(maxHeight/content.height));
					sp.graphics.endFill();
					currentSliderBtnSize = maxHeight*(maxHeight/content.height);
					sliderBtn.addChild(sp);
				}
			}
			oldSize = newSize;
		}
		
		private var downX:Number;
		private var contentX:Number;
		private var downY:Number;
		private var contentY:Number;
		private function down(e:MouseEvent):void{
			time = 0;
			downX = e.stageX;
			removeEventListener(Event.ENTER_FRAME,onEnterFrameEx);
			contentX = content.x;
			downY = e.stageY;
			contentY = content.y;
			contentClickAble = true;
//			addEventListener(MouseEvent.MOUSE_MOVE,move);
			if(_type == 0){
				if(maxWidth<content.width){
					addEventListener(Event.ENTER_FRAME,onEnterFrame);
				}
				currentpos = downX; 
			}else{
				if(maxHeight<content.height){
					addEventListener(Event.ENTER_FRAME,onEnterFrame);
				}
				currentpos = downY;
			}
		}
		private var sliderThickness:int;
		public function setSlider(flag:Boolean,base:Number = 0,wid:Number = 10):void{
			if(flag){
				sliderThickness = wid;
				initSlider(base);
			}else{
				if(sliderContainer){
					sliderContainer.visible = false;
				}
			}
		}
		
		public function up(e:MouseEvent):void{
			nochangesped = speed>0?-1:1;//(0-speed)/5;
			addEventListener(Event.ENTER_FRAME,onEnterFrameEx);
			removeEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		
		private function onEnterFrameEx(e:Event):void{
			if(!stage)return;
			switch(_type){
				case 0:
					speed+=nochangesped;
					var resultX:Number = content.x + speed;
					if(Math.abs(speed)<= Math.abs(nochangesped)){
						removeEventListener(Event.ENTER_FRAME,onEnterFrameEx);
					}
					if(resultX >= 0){
						content.x = 0;
						removeEventListener(Event.ENTER_FRAME,onEnterFrameEx);
					}else if(resultX <= maxWidth - content.width){
						content.x = maxWidth - content.width;
						removeEventListener(Event.ENTER_FRAME,onEnterFrameEx);
					}else{
						content.x = resultX;
					}
					if(sliderBtn){
						sliderBtn.x = -content.x*(sliderContainer.width - sliderBtn.width)/(content.width-maxWidth)
					}
					//trace(content.x);
					break;
				case 1:
					speed+=nochangesped;
					var resultY:Number = content.y + speed;
					if(Math.abs(speed)<= Math.abs(nochangesped)){
						removeEventListener(Event.ENTER_FRAME,onEnterFrameEx);
					}
					if(resultY >= 0){
						content.y = 0;
						removeEventListener(Event.ENTER_FRAME,onEnterFrameEx);
					}else if(resultY <= maxHeight - content.height){
						content.y = maxHeight - content.height;
						removeEventListener(Event.ENTER_FRAME,onEnterFrameEx);
					}else{
						content.y = resultY;
					}
					if(sliderBtn){
						sliderBtn.y = -content.y*(maxHeight - currentSliderBtnSize)/(content.height-maxHeight)
					}
					break;
			}
			if(Math.abs(_type == 0?stage.mouseX - downX:stage.mouseY - downY)>15){
				contentClickAble = false;
			}else{
				contentClickAble = true;
			}
		}
		
		public function set selectAble(flag:Boolean):void{
			_selectAble = flag;
			if(!_selectAble){
				for each(var obj:Object in btnArr){
					obj.selectAble = false;
				}
			}
		}
		
		public function atBeginning(offset:Number = 0):Boolean{
			if(_type == 0)
				return content.x + offset >= 0;
			else
				return content.y + offset >= 0;
		}
		
		public function atEnding(offset:Number = 0):Boolean{
			if(_type == 0)
				return content.x - offset <= maxWidth - content.width;
			else
				return content.y - offset <= maxHeight - content.height;
		}
		
		private function onClick(e:MouseEvent):void{
			if(!contentClickAble){
				e.stopImmediatePropagation();
			}
		}
		
		private var speed:Number = 0;
		private var nochangesped:Number = 0;
		private var currentpos:Number = 0;
		private var time:int = 0;
		
		private function onEnterFrame(e:Event):void{
			time++;
			switch(_type){
				case 0:
//					if((maxWidth - content.width)<=(contentX + stage.mouseX - downX)&&(contentX + stage.mouseX - downX)<=0)
						var resultX:Number = contentX + stage.mouseX - downX;
						speed = (stage.mouseX - downX)/time;
						if(Math.abs(stage.mouseX - currentpos) < 10){
							speed = 0;
						}
						currentpos = stage.mouseX;
						if(resultX >= 0){
							content.x = 0;
						}else if(resultX <= maxWidth - content.width){
							content.x = maxWidth - content.width;
						}else{
							content.x = resultX;
						}
						if(sliderBtn){
							sliderBtn.x = -content.x*(sliderContainer.width - sliderBtn.width)/(content.width-maxWidth)
						}
					break;
				case 1:
//					if((maxHeight - content.height)<=(contentY + stage.mouseY - downY)&&(contentY + stage.mouseY - downY)<=0)
//						content.y = contentY + stage.mouseY - downY;
					var resultY:Number = contentY + stage.mouseY - downY;
					speed = (stage.mouseY - downY)/time;
				//	trace(speed);
					
					if(Math.abs(stage.mouseY - currentpos) < 10){
						speed = 0;
					}
					currentpos = stage.mouseY;
					if(resultY >= 0){
						content.y = 0;
					}else if(resultY <= maxHeight - content.height){
						content.y = maxHeight - content.height;
					}else{
						content.y = resultY;
					}
					if(sliderBtn){
						sliderBtn.y = -content.y*(maxHeight - currentSliderBtnSize)/(content.height-maxHeight)
					}
					break;
			}
			if(Math.abs(_type == 0?stage.mouseX - downX:stage.mouseY - downY)>15){
				contentClickAble = false;
			}else{
				contentClickAble = true;
			}
		}
		
		private function move(e:MouseEvent):void{
			switch(_type){
				case 0:
					if((maxWidth - content.width)<=(contentX + e.stageX - downX)&&(contentX + e.stageX - downX)<=0)
					content.x = contentX + e.stageX - downX;
					break;
				case 1:
					if((maxHeight - content.height)<=(contentY + e.stageY - downY)&&(contentY + e.stageY - downY)<=0)
					content.y = contentY + e.stageY - downY;
					break;
			}
			if(Math.abs(e.stageX - downX)>15){
				contentClickAble = false;
			}else{
				contentClickAble = true;
			}
		}
		
		public function set backSource(source:String):void{
			this.sourceURL = source;
			if(Image.imageDic[source] != null){
				addChildWithSelf = true;
				addChild(new Bitmap(Image.imageDic[source] as BitmapData))
				addChildWithSelf = false;
			}
			else{
				var load:Loader = new Loader();
				load.load(new URLRequest(source));
				load.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete,false,0,true);
			}
		}
		
		private function onLoadComplete(e:Event):void{
			Image.imageDic[sourceURL] = e.target.content.bitmapData;
			addChildWithSelf = true;
			addChild(new Bitmap(Image.imageDic[sourceURL] as BitmapData))
			addChildWithSelf = false;
		}
		
		public function clear():void{
			clearContent();
			delete Image.imageDic[this.sourceURL];
			if(this.parent){
				this.parent.removeChild(this);
			}
			System.gc();
		}
		
		public function clearContent():void{
			content.x = content.y = 0;
			for each(var obj:Object in btnArr){
				obj.clear();
			}
			btnArr.splice(0);
			oldSize = 0;
			//trace(content.numChildren+"wewewew");
		}
		
		public function removeContent():void{
			content.x = 0;
			for each(var obj:Object in btnArr){
				content.removeChild(obj as DisplayObject);
			}
			btnArr.splice(0);
		}
		
		public function set contentSource(arr:Array):void{
			contentArr = arr;
			for each(var url:String in arr){
				var img:Image = new Image();
				img.source = url;
				addChild(img);
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject{
			if(addChildWithSelf){
				return super.addChild(child);
			}else{
				btnArr.push(child);
				if(_type == 1){
					if(child.width!=0){
						child.x = (maxWidth - child.width)/2;
					}else{
						if(child is Image){
							child.addEventListener(Image.GET_DATA,function(e:Event):void{
								e.currentTarget.x = (maxWidth - e.currentTarget.width)/2;
							});
						}
					}						
				}
				if(child is ImageButton){
					(child as Object).selectAble = _selectAble;
				}
				
				return content.addChild(child);
			}
		}
		
	}
}