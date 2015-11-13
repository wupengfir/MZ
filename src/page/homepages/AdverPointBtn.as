package page.homepages
{
	import flash.display.Sprite;

	
	public class AdverPointBtn extends Sprite
	{
		
		private var _r:Number;
		private var _color:uint;
		private var _alpha:Number;
		private var rootx:AdverPointBtn;
		public var index:int;
		public function AdverPointBtn(_r:Number,_color:uint = 0x646464,_alpha:Number = .8)
		{

			this.graphics.beginFill(_color,_alpha);
			this.graphics.drawCircle(0,0,_r);
			this.graphics.endFill();
			this._alpha = _alpha;
			this._r = _r;
			this._color = _color;
			this.buttonMode = true;
			rootx = this;
		}
		private var _selected:Boolean;
		public function set selected(_select:Boolean):void{
			this._selected = _select;
			if(_select){
				this.graphics.clear();					
//				var r:Number = _color>>16;
//				var g:Number = _color>>8 & 0xff;
//				var b:Number = _color & 0xff;					
//				var result:uint = (r-20)<<16|(g-20)<<8|(b-20);
				this.graphics.beginFill(Common.RGB(58,148,228),_alpha);
				this.graphics.drawCircle(0,0,_r);
				this.graphics.endFill();
			}else{
				this.graphics.clear();
				this.graphics.beginFill(_color,_alpha);
				this.graphics.drawCircle(0,0,_r);
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