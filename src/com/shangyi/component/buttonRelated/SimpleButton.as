package com.shangyi.component.buttonRelated
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class SimpleButton extends Sprite
	{
		
		private var _width:Number;
		private var _height:Number;
		private var _color:uint;
		private var rootx:SimpleButton;
		private var text:TextField = new TextField();
		public var round:Boolean;
		private var textFormat:TextFormat;
		public function SimpleButton(_width:Number,_height:Number,round:Boolean = false,_color:uint = 0x483d8b,_alpha:Number = .8,size:Number = 20)
		{
			textFormat = new TextFormat();
			textFormat.size = size;
			textFormat.font = "SimHei";
			textFormat.color = 0x646464;
			text.setTextFormat(textFormat);
			this.round = round; 
			this.graphics.beginFill(_color,_alpha);
			if(round){
				this.graphics.drawRoundRect(0,0,_width,_height,_width/30);
			}else{
				this.graphics.drawRect(0,0,_width,_height);
			}
			
			this.graphics.endFill();
			this._width = _width;
			this._height = _height;
			this._color = _color;
			this.buttonMode = true;
			rootx = this;
			addEventListener(Event.ADDED_TO_STAGE,function(e:Event):void{
				rootx.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent):void{
					rootx.graphics.clear();					
					var r:Number = _color>>16;
					var g:Number = _color>>8 & 0xff;
					var b:Number = _color & 0xff;					
					var result:uint = (r-20)<<16|(g-20)<<8|(b-20);
					rootx.graphics.beginFill(result,_alpha);
					if(rootx.round){
						rootx.graphics.drawRoundRect(0,0,_width,_height,_width/30);
					}else{
						rootx.graphics.drawRect(0,0,_width,_height);
					}
					rootx.graphics.endFill();
				});
				stage.addEventListener(MouseEvent.MOUSE_UP,function(e:MouseEvent):void{
					rootx.graphics.clear();
					rootx.graphics.beginFill(_color,_alpha);
					if(rootx.round){
						rootx.graphics.drawRoundRect(0,0,_width,_height,_width/30);
					}else{
						rootx.graphics.drawRect(0,0,_width,_height);
					}
					rootx.graphics.endFill();
				});
			});
			
			addChild(text);
		}
		
		public function set textColor(color:uint):void{
			textFormat.color = color;
			text.setTextFormat(textFormat);
		}
		
		public function set label(_label:String):void{
			text.width = _width;
			text.height = _height;
			text.text = _label;
			text.mouseEnabled = false;
			text.selectable = false;
			
//			text.x = (_width - text.textWidth)/2-1;
			text.y = (_height - text.textHeight)/2-1;				
			text.autoSize = TextFieldAutoSize.CENTER;
			text.setTextFormat(textFormat);
		}
		
		public function clear():void{
			if(parent){
				parent.removeChild(this);
			}
		}
		
	}
}