package com.shangyi.component.scrollerRelated
{
	import com.greensock.TweenLite;
	import com.shangyi.component.buttonRelated.ImageButton;
	import com.shangyi.component.imageRelated.Image;
	import com.shangyi.component.scrollerRelated.Scroller;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SY_Scroller extends Sprite
	{
//		[Embed(source="img/leftarrow.png")]    
//		private var arrow:Class;  
		private var backWidth:int;
		private var backHeight:int;
		//左右箭头
		public var leftArrow:Image;
		public var rightArrow:Image;
		
		public var leftArrowBaseX:Number = 0;
		public var leftArrowBaseY:Number = 0;
		public var rightArrowBaseX:Number = 0;
		public var rightArrowBaseY:Number = 0;
		//滑动框
		public var scroller:Scroller;
		//被选中的组件
		public var selectedObj:Object;
		//0横向1竖向
		private var type:int;
		
		private var offset:int;
		
		private var relocate:Boolean;
		public function SY_Scroller(_width:int,_height:int,scrollerWidth:int,scrollerHeight:int,backColor:uint = 0xffffff,type:int = 0,relocate:Boolean = true)
		{
			if(_width < scrollerWidth || _height < scrollerHeight){
				throw new Error("size of SY_Scroller should be larger than its scroller");
			}
			this.relocate = relocate;
			this.type = type;
			backWidth = _width;
			backHeight = _height;
			//绘制背景
			this.graphics.beginFill(backColor,.6);
			this.graphics.drawRect(0,0,_width,_height);
			this.graphics.endFill();
			
			scroller = new Scroller(scrollerWidth,scrollerHeight,type);
			scroller.x = (_width - scrollerWidth)>>1;
			scroller.y = (_height - scrollerHeight)>>1;
			this.addChild(scroller);
			
			leftArrow = new Image();
			rightArrow = new Image();
			leftArrow.addEventListener(Image.GET_DATA,locateLeftArrow);
			rightArrow.addEventListener(Image.GET_DATA,locateRightArrow);
			leftArrow.source = Main.basePath + "img/leftarrow.png";
			rightArrow.source = Main.basePath + "img/leftarrow.png";
			
			leftArrow.addEventListener(MouseEvent.CLICK,onLeftArrowClick);
			rightArrow.addEventListener(MouseEvent.CLICK,onRightArrowClick);
			this.addChild(leftArrow);
			this.addChild(rightArrow);
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			leftArrow.addEventListener(Image.GET_DATA,function(e:Event):void{
				var data:BitmapData = leftArrow.back.bitmapData;
				for(var i:int = 0;i<data.width;i++){
					for (var j:int = 0; j < data.height; j++) 
					{
						if(data.getPixel32(i,j) == 0xffffffff){
							data.setPixel32(i,j,0x00ffffff);
						}						
					}					
				}
			});
			this.selectAble = false;
		}
		
		public function set selectAble(flag:Boolean):void{
				scroller.selectAble = flag;
		}
		
		public function clickNextBtn():void{
			var arr:Array = scroller.btnArr;
			var flag:Boolean = false;
			var temp:ImageButton = arr[0];
			for each(var btn:ImageButton in arr){
				if(flag){
					temp = btn;
					break;
				}
				else if(btn.selected){
					flag = true;
				}
			}
			temp.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		public function setLeftArrowX(num:Number):void{
			leftArrowBaseX = num;
			locateLeftArrow(null);
			locateRightArrow(null);
		}
		 
		public function setLeftArrowY(num:Number):void{
			leftArrowBaseY = num;
			locateLeftArrow(null);
			locateRightArrow(null);
		}
		
		private function locateLeftArrow(e:Event):void{
			if(type == 0){
				leftArrow.x = 10+leftArrowBaseX;
				leftArrow.y = (((backHeight - scroller.height)/2 - leftArrow.height)>>1)+leftArrowBaseY;
			}else{
				leftArrow.rotation = 90;
				leftArrow.y = 10+leftArrowBaseY;
				leftArrow.x = ((backWidth + leftArrow.back.width)>>1)+leftArrowBaseX;
			}
		}
		
		private function locateRightArrow(e:Event):void{
			rightArrow.scaleX = -1;
			if(type == 0){
				rightArrow.y = leftArrow.y;//(backHeight - leftArrow.height)>>1;
				rightArrow.x = backWidth - 10;
			}else{
				rightArrow.rotation = 90;
				rightArrow.x = ((backWidth + leftArrow.back.width)>>1)+leftArrowBaseX;;
				rightArrow.y = backHeight - 10;
			}
		}
		
		private var _size:int;
		private var _lines:int;
		public function dataSource(data:Array,space:int,offset:int,func:Function = null,selectedIndex:int = 0,lines:int = 1):void{
			this.offset = offset;//space + offset;
			var index:int = 0;
			var size:int;
			var a:Number;
			_lines = lines;
			if(type == 0){
				size = (scroller.maxHeight - (lines - 1)*offset )/lines;
			}else{
				size = (scroller.maxWidth - (lines - 1)*offset )/lines;
			}
			_size = size;
			for each(var path:String in data){
				var btn:ImageButton = new ImageButton();
				btn.index = index;
				if(relocate){
					btn.addEventListener(Image.GET_DATA,reLocate);
				}
				btn.source = path;
				if(func){
					btn.addEventListener(MouseEvent.CLICK,func);
				}
				if(!relocate){
					if(type == 0){
						btn.width = space;
						btn.height = size;
						btn.x = (Math.floor(index/lines))*(space + offset);
						btn.y = (index%lines)*(size + offset);
					}else{
						btn.width = size;
						btn.height = space;
						btn.x = (index%lines)*(size + offset);
						btn.y = (Math.floor(index/lines))*this.offset;
					}	
				}

//				btn.index = index;
//				if(relocate){
//					btn.addEventListener(Image.GET_DATA,reLocate);
//				}
				
				if(index == selectedIndex){
					btn.selected = true;
					this.selectedObj = btn;
					if(type == 0){
						if(btn.x + this.offset >= scroller.maxWidth){
							scroller.content.x = scroller.maxWidth - btn.x - this.offset;
						}
					}else{
						if(btn.y + this.offset >= scroller.maxHeight){
							scroller.content.y = scroller.maxHeight - btn.y - this.offset;
						}
					}
				}
				btn.addEventListener(MouseEvent.CLICK,onBtnClick,false,100);
				scroller.addChild(btn);
				index++;
			}
		}
		
		private function reLocate(e:Event):void{
			//trace("ordered......");
			var btn:ImageButton = e.currentTarget as ImageButton;
			if(type == 0){
				btn.width = (_size/btn.height)*btn.width;
				btn.height = _size;
				btn.x = (Math.floor(btn.index/_lines))*(this.offset+btn.width);
				btn.y = (btn.index%_lines)*(_size + offset);
			}else{
				btn.height = (_size/btn.width)*btn.height;
				btn.width = _size;
				
				btn.x = (btn.index%_lines)*(_size + offset);
				btn.y = (Math.floor(btn.index/_lines))*(this.offset+btn.height);
			}
		}
		
		private function onBtnClick(e:MouseEvent):void{
			if(this.selectedObj){
				selectedObj.selected = false;
			}
			this.selectedObj = e.currentTarget;
			e.currentTarget.selected = true;
		}
		
		private function onLeftArrowClick(e:MouseEvent):void{
			if(scroller.atEnding(offset)){
				leftArrow.visible = false;
			}
			rightArrow.visible = true;
			var temp:Number = 0;
			if(type == 0){
				for each(var image:Image in scroller.btnArr){
					if(Math.abs(image.x+scroller.content.x)<=offset){
						temp = Math.abs(image.x+scroller.content.x);
						break;
					}
				}
				TweenLite.to(scroller.content,.2,{x:scroller.content.x + temp});
			}
			else
				TweenLite.to(scroller.content,.2,{y:scroller.content.y + offset > 0?0:scroller.content.y + offset});

		}
		
		private function onRightArrowClick(e:MouseEvent):void{
			if(scroller.atBeginning(offset)){
				rightArrow.visible = false;
			}
			leftArrow.visible = true;
			if(type == 0)
				TweenLite.to(scroller.content,.2,{x:scroller.content.x - offset<scroller.maxWidth - scroller.content.width?scroller.maxWidth - scroller.content.width:scroller.content.x - offset});
			else
				TweenLite.to(scroller.content,.2,{y:scroller.content.y - offset<scroller.maxHeight - scroller.content.height?scroller.maxHeight - scroller.content.height:scroller.content.y - offset});
		}
		
		private function onEnterFrame(e:Event):void{
			rightArrow.visible = !scroller.atEnding();
			leftArrow.visible = !scroller.atBeginning();
		}
		
		private function onAddedToStage(e:Event):void{
			stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
		}
		
		private function onStageMouseUp(e:MouseEvent):void{
			this.scroller.up(null);
		}
		
	}
}














