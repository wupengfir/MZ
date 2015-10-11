package com.shangyi.component.buttonRelated
{
	import com.shangyi.component.imageRelated.Image;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SimpleImageButton extends Image
	{
		
		private var downImage:Bitmap;
		private var rootx:SimpleImageButton; 
		private var _colorChange:Number = 20;
		
		public function SimpleImageButton()
		{
			this.addEventListener(Image.GET_DATA,onGetImage);
			rootx = this;
			addEventListener(Event.ADDED_TO_STAGE,function(e:Event):void{
				rootx.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent):void{
					rootx.back.visible = false;
					rootx.downImage.visible = true;
				});
				stage.addEventListener(MouseEvent.MOUSE_UP,function(e:MouseEvent):void{
					rootx.back.visible = true;
					rootx.downImage.visible = false;
				});
			});
		}
		
		private function onGetImage(e:Event):void{
			downImage = new Bitmap();
			downImage.bitmapData = new BitmapData(back.width,back.height);
			for (var i:int = 0; i < back.width; i++) 
			{
				for (var j:int = 0; j < back.height; j++) 
				{
					var _color = back.bitmapData.getPixel(i,j);
					var r:Number = _color>>16;
					var g:Number = _color>>8 & 0xff;
					var b:Number = _color & 0xff;
					r = (r-_colorChange)<0?0:(r-_colorChange);
					g = (g-_colorChange)<0?0:(g-_colorChange);
					b = (b-_colorChange)<0?0:(b-_colorChange);
					var result:uint = r<<16|g<<8|b;
					downImage.bitmapData.setPixel(i,j,result);
				}
				
			}
			downImage.visible = false;
			addChild(downImage);
		}
		
	}
}