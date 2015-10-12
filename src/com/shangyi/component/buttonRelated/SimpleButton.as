package com.shangyi.component.buttonRelated
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class SimpleButton extends Sprite
	{
		
		private var _width:Number;
		private var _height:Number;
		private var _color:uint;
		private var rootx:SimpleButton;
		private var text:TextField = new TextField();
		
		private var normal:Shape = new Shape();
		private var selected:Shape = new Shape();;
		
		public function SimpleButton(_width:Number,_height:Number,_color:uint = 0xff5675,_alpha:Number = .8)
		{
			this.graphics.beginFill(_color,_alpha);
			this.graphics.drawRoundRect(0,0,_width,_height,_width/3);
			this.graphics.endFill();
			this._width = _width;
			this._height = _height;
			this._color = _color;
			this.buttonMode = true;
			
			var r:Number = _color>>16;
			var g:Number = _color>>8 & 0xff;
			var b:Number = _color & 0xff;	
			r = r>20?r:20;
			g = g>20?g:20;
			b = b>20?b:20;
			var result:uint = (r-20)<<16|(g-20)<<8|(b-20);
			selected.graphics.beginFill(result,_alpha);
			selected.graphics.drawRoundRect(0,0,_width,_height,_width/3);
			selected.graphics.endFill();
			
			normal.graphics.beginFill(_color,_alpha);
			normal.graphics.drawRoundRect(0,0,_width,_height,_width/3);
			normal.graphics.endFill();
			
			selected.visible = false;
			
			addChild(selected);
			addChild(normal);
			
			rootx = this;
			addEventListener(Event.ADDED_TO_STAGE,function(e:Event):void{
				rootx.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent):void{
					selected.visible = true;
					normal.visible = false;
				});
				rootx.addEventListener(MouseEvent.MOUSE_UP,function(e:MouseEvent):void{
					selected.visible = false;
					normal.visible = true;
				});
				rootx.addEventListener(MouseEvent.MOUSE_OUT,function(e:MouseEvent):void{
					selected.visible = false;
					normal.visible = true;
				});
			});
		}
		
		public function set label(_label:String):void{
			text.width = _width;
			text.height = _height;
			text.text = _label;
			text.mouseEnabled = false;
			text.selectable = false;
			text.x = (_width - text.textWidth)/2-1;
			text.y = (_height - text.textHeight)/2-1;
			addChild(text);
		}
		
		
		
	}
}