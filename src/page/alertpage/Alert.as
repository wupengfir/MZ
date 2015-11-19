package page.alertpage
{
	import com.greensock.TweenLite;
	import com.shangyi.component.base.Page;
	
	public class Alert extends Page
	{
		
		public var text:Label = new Label("",20);
		public static var a:Alert = new Alert();
		private static var w:Number = 200;
		private static var h:Number = 100;
		public function Alert()
		{
			visible = false;
			graphics.beginFill(0,.85);
			graphics.drawRoundRect(0,0,w,h,10);
			graphics.endFill();
			addChild(text);
			text.width = 180;
			this.x = 500;
			this.y = 400;
			text.color = 0xffffff;
		}
		
		public static function alert(s:String,delay:Number = 1):void{
			a.visible = true;
			a.text.text = s;
			a.alpha = 0.5;
			a.text.x = (w - a.text.textField.textWidth)/2-1;
			a.text.y = (h - a.text.textField.textHeight)/2-1;
			TweenLite.to(a,delay,{alpha:1,onComplete:function():void{
				a.visible = false
			}});
		}
		
	}
}