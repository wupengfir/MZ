package com.shangyi.component.buttonRelated
{
	import com.shangyi.component.imageRelated.Image;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Button extends Sprite
	{
		private var normal:Image;
		private var select:Image;
		private var _selected:Boolean = false;
		private var _normalType:Boolean;
		public function Button(_width:int = 0,_height:int = 0,_x:int = 0,_y:int = 0,selectAble:Boolean = false,normalType:Boolean = true,xOffset:Number = 0,yOffset:Number = 0)
		{
			graphics.beginFill(0x000000,0);
			graphics.drawRect(xOffset,yOffset,_width,_height);
			x = _x;
			y = _y;
			graphics.endFill();
			normal = new Image();
			select = new Image();
			addChild(normal);
			addChild(select);
			normal.visible = true;
			select.visible = false;
			_normalType = normalType;
			if(selectAble){
				addEventListener(MouseEvent.CLICK,onClick)
			}
			mouseChildren = false;
		}
		
		private function onClick(e:MouseEvent):void{
			this.selected = true;
		}
		
		public function set selected(flag:Boolean):void{
			this._selected = flag;
			onGetData(null);
		}
		
		public function clear():void{
			normal.clear();
			select.clear();
			if(parent){
				parent.removeChild(this);
			}
		}
		
		public function get selected():Boolean{
			return this._selected;
		}
		
		private var down:Boolean = false;
		public function set buttonSource(data:Array):void{
			normal.source = data[0];
			select.source = data[1];
			normal.addEventListener(Image.GET_DATA,onGetData);
			select.addEventListener(Image.GET_DATA,onGetData);
			if(_normalType){
				addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent):void{
					select.visible = true;
					down = true;
				});
				addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			}
		}
		
		private function onMouseUp(e:MouseEvent):void{
					
//			if(down){
//				this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
//			}
			if(down){
				select.visible = true;
			}	
			down = false;
		}
		
		private function onGetData(e:Event):void{
			if(normal.back.bitmapData!=null&&select.back.bitmapData!=null){				
				normal.visible = !_selected;
				select.visible = _selected;			
			}
		}
		
	}
}