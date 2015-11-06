package page.homepages
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class AdverPointBtn extends Sprite
	{
		
		private var _r:Number;
		private var _color:uint;
		private var _alpha:Number;
		private var rootx:AdverPointBtn;
		private var textFormat:TextFormat;
		public function AdverPointBtn(_r:Number,_color:uint = 0x483d8b,_alpha:Number = .8)
		{
			textFormat = new TextFormat();
			this.graphics.beginFill(_color,_alpha);
			this.graphics.drawCircle((0,0,_r);
			this.graphics.endFill();
			this._alpha = _alpha;
			this._r = _r;
			this._color = _color;
			this.buttonMode = true;
			rootx = this;
		}
		private var _selected:Boolean;
		public function set selected(_select:Boolean):void{
			this.selected = _select;
			if(_select){
				this.graphics.clear();					
				var r:Number = _color>>16;
				var g:Number = _color>>8 & 0xff;
				var b:Number = _color & 0xff;					
				var result:uint = (r-20)<<16|(g-20)<<8|(b-20);
				this.graphics.beginFill(result,_alpha);
				this.graphics.drawCircle(0,0,_r);
				this.graphics.endFill();
			}else{
				this.graphics.clear();
				this.graphics.beginFill(_color,_alpha);
				this.graphics.drawCircle((0,0,_r);
				this.graphics.endFill();
			}
		}
		
		public function clear():void{
			if(this.parent){
				parent.removeChild(this);
			}
		}
		
	}
}