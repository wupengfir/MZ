package
{
	import com.greensock.TweenLite;
	import com.shangyi.component.base.Page;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import page.room.RoomPage;
	
	public class pointMc extends Sprite
	{
		private var touchPad:Sprite = new Sprite();
		
		public var info:Dictionary;
		public var parentInfo:Dictionary;
		
		private var rate:Number = 30;
		private var timer:Timer;
		private var pic_1:Sprite = new Sprite();
		private var pic_2:Sprite = new Sprite();
		private var lineLayer:Sprite = new Sprite();
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
			
			Common.MAIN.roomLayer.addChild(lineLayer);
			timer = new Timer(1000/rate);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		private function beginSmall():void{
			TweenLite.to(pic_1,0.5,{alpha:1,scaleX:1,scaleY:1,onComplete:beginBig});
		}
		
		private function beginBig():void{
			pic_1.alpha = 1;
			pic_1.scaleX = pic_1.scaleY = 1;
			TweenLite.to(pic_1,1.5,{alpha:.2,scaleX:1.8,scaleY:1.8,onComplete:beginBig});
		}
		
		private var currentX:Number;
		private var currentY:Number;
		private var endX:Number;
		private var endY:Number;
		private var kx:Number;
		private var ky:Number;
		private var times:int = 0;
		private function onTimer(e:TimerEvent):void{
			lineLayer.graphics.clear();
			lineLayer.graphics.lineStyle(2,0xffffff);
			lineLayer.graphics.moveTo(this.x,this.y);
			lineLayer.graphics.lineTo(currentX,currentY);
			currentX += kx;
			currentY += ky;
			times++;
			if(times == rate){
				timer.stop();
				Page.eventAccept = true;
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function drawLine():void{
			Page.eventAccept = false;
			currentX = Number(info["x"])*RoomPage.scx;
			currentY = Number(info["y"])*RoomPage.scy;
			endX = Number(info["endX"])*RoomPage.scx;
			endY = Number(info["endY"])*RoomPage.scy;
			kx = (endX - currentX)/rate;
			ky = (endY - currentY)/rate;
			times = 0;
			timer.start();
		}
		
		public function clear():void{
			TweenLite.killTweensOf(this);
			if(parent){
				parent.removeChild(this);
			}
		}
		
	}
}