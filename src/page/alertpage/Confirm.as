package page.alertpage
{
	import com.shangyi.component.base.Page;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class Confirm extends Page
	{
		public var text:Label = new Label("",20);
		public var yes:Label = new Label("",20);
		public var no:Label = new Label("",20);
		
		public static var a:Confirm = new Confirm();
		private static var w:Number = 200;
		private static var h:Number = 100;
		
		public static const YES:String = "YES";
		public static const NO:String = "NO";
		
		public static var current:EventDispatcher;
		public function Confirm()
		{
			visible = false;
			graphics.beginFill(0,.85);
			graphics.drawRoundRect(0,0,w,h,10);
			graphics.endFill();
			addChild(text);
			text.width = 400;
			this.x = 500;
			this.y = 400;
			text.color = 0xffffff;
			
			yes.x = 30;
			yes.y = 50;
			no.x = 140;
			no.y= 50;

			yes.text = "是";
			no.text = "否";
			yes.width = no.width = 40;
			yes.mouseChildren = no.mouseChildren = false;
			yes.buttonMode = no.buttonMode = true;
			addChild(yes);
			
//			addEventListener(Event.ENTER_FRAME,function(e:Event):void{
//				yes.graphics.clear();
//				no.graphics.clear();
//				yes.graphics.beginFill(0,1);
//				yes.graphics.drawRect(0,0,yes.width,yes.height);
//				yes.graphics.endFill();
//				no.graphics.beginFill(0,1);
//				no.graphics.drawRect(0,0,yes.width,yes.height);
//				no.graphics.endFill();
//			});
			
			
			//yes.width = 100;
			yes.color = 0x00ffff;
			addChild(no);
			//no.width = 100;
			no.color = 0x00ffff;
			
			yes.addEventListener(MouseEvent.CLICK,onyes);
			no.addEventListener(MouseEvent.CLICK,onno);
		}
		
		public static function confirm(s:String,o:EventDispatcher):void{
			current = o;
			a.visible = true;
			a.text.text = s;
			a.alpha = 0.5;
			a.text.x = (w - a.text.textField.textWidth)/2-1;
			a.text.y = 10;
//			TweenLite.to(a,1,{alpha:1,onComplete:function():void{
//				a.visible = false
//			}});
		}
		
		private function onyes(e:MouseEvent):void{
			current.dispatchEvent(new Event(YES));
			a.visible = false;
			trace("yes");
		}
		
		private function onno(e:MouseEvent):void{
			current.dispatchEvent(new Event(NO));
			a.visible = false;
			trace("no");
		}
		
	}
}
















