package
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	
	public class pointMc extends Sprite
	{
		private var touchPad:Sprite = new Sprite();
		
		private var pic_1:Sprite = new Sprite();
		private var pic_2:Sprite = new Sprite();
		public function pointMc()
		{
			addChild(pic_2);
			pic_2.graphics.beginFill(0,.6);
			pic_2.graphics.drawCircle(0,0,10);
			pic_2.graphics.endFill();
			pic_2.graphics.lineStyle(3,0xffffff,1);
			pic_2.graphics.drawCircle(0,0,11);
			pic_2.graphics.endFill();
			
			addChild(touchPad);
			touchPad.graphics.beginFill(0,0);
			touchPad.graphics.drawRect(-20,-20,40,40);
			touchPad.graphics.endFill();
			
			addChild(pic_1);
			pic_1.graphics.lineStyle(3,0xffffff,1);
			pic_1.graphics.drawCircle(0,0,11);
			pic_1.graphics.endFill();
			beginBig();
		}
		private function beginSmall():void{
			TweenLite.to(pic_1,0.5,{alpha:1,scaleX:1,scaleY:1,onComplete:beginBig});
		}
		
		private function beginBig():void{
			pic_1.alpha = 1;
			pic_1.scaleX = pic_1.scaleY = 1;
			TweenLite.to(pic_1,1.5,{alpha:.2,scaleX:1.8,scaleY:1.8,onComplete:beginBig});
		}
		
		public function clear():void{
			TweenLite.killTweensOf(this);
		}
		
	}
}