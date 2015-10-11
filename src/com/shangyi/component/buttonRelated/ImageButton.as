package com.shangyi.component.buttonRelated
{
	import com.shangyi.component.imageRelated.Image;
	
	public class ImageButton extends Image
	{
		public var index:int = 0;
		public function ImageButton(_x:Number = 0,_y = 0,selectAble:Boolean = false)
		{
			this.x = _x;
			this.y = _y;
			_selectAble = selectAble;
		}
		
		override public function set selected(flag:Boolean):void{
			super._selected = flag;
			if(flag && super._selectAble){
				if(this.back.bitmapData){
				super.shape.graphics.clear();
				super.shape.graphics.lineStyle(this.back.bitmapData.height/30,0xCF5B34,1);
				var thick:Number = this.back.bitmapData.height/30;
				var wid:Number = (this.back.bitmapData.width*scaleX - this.back.bitmapData.height*scaleY/30/3)/scaleX;
				var hei:Number = (this.back.bitmapData.height*scaleY - this.back.bitmapData.height*scaleY/30/3)/scaleY;
				super.shape.graphics.moveTo(thick/2,0);
				super.shape.graphics.lineTo(wid,0);
				super.shape.graphics.lineTo(wid,hei);
				super.shape.graphics.lineTo(thick/2,hei);
				super.shape.graphics.lineTo(thick/2,0);
//				super.shape.graphics.drawRect(this.back.bitmapData.height*scaleY/30/3,
//					this.back.bitmapData.height*scaleY/30/3,
//					(this.back.bitmapData.width*scaleX - this.back.bitmapData.height*scaleY/30/3)/scaleX,
//					(this.back.bitmapData.height*scaleY - this.back.bitmapData.height*scaleY/30/3)/scaleY);
				}
			}else{
				super.shape.graphics.clear();
			}
		}
		
	}
}