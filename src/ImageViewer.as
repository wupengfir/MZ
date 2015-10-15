package
{
	import com.greensock.TweenLite;
	import com.shangyi.component.imageRelated.Image;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.GesturePhase;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	public class ImageViewer extends Sprite
	{
		private var image:Image;
		private var downX:Number;
		private var downY:Number;
		private var beforeDownX:Number;
		private var beforeDownY:Number;

		private var text1:TextField = new TextField  ;
		private var text2:TextField = new TextField  ;

		private var scale_xy:Number = 0;

		public function ImageViewer(imagePath:String)
		{
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			this.graphics.beginFill(0x000000,0.9);
			this.graphics.drawRect(0,0,Common.MAX_WIDTH,Common.MAX_HEIGHT);
			this.graphics.endFill();

			image = new Image  ;
			image.doubleClickEnabled = true;
			image.source = imagePath;
			addChild(image);
//			image.x = (1024-image.width)/2;
//			image.y = (768-image.height)/2;
			image.addEventListener(Image.GET_DATA,function(e:Event):void{
				var img:Image = e.currentTarget as Image;
//				img.x = (1024-img.width)/2;
//				img.y = (768-img.height)/2;
			});
			this.addEventListener(TransformGestureEvent.GESTURE_ZOOM,onZoom);
			//this.addEventListener(Event.ENTER_FRAME,onFrame);
			this.addEventListener(MouseEvent.DOUBLE_CLICK,onClose);
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		/*private function onFrame(e:Event):void
		{
			trace(image.scaleX+ "xxxxxxxxxxxxx",image.scaleY);
		}*/

		private function onClose(e:MouseEvent):void{
			image.clear();
			parent.removeChild(this);
		}
		
		private function onAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			this.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}

		public function changeMuitiMode():void
		{
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			//this.removeEventListener(Event.ENTER_FRAME,onFrame);
		}
		private function onDown(e:MouseEvent):void
		{
			downX = e.stageX;
			downY = e.stageY;
			beforeDownX = image.x;
			beforeDownY = image.y;
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
		}

		private function onUp(e:MouseEvent = null):void
		{
			zooming = false;
			if (image.scaleY < 1)
			{
				TweenLite.to(image,0.5,{x:512-(1500*scale_xy)/2,y:0,scaleX:1,scaleY:1});
			}
			if (image.scaleY > 2)
			{
				TweenLite.to(image,0.5,{x:beforeX,y:beforeY,scaleX:2,scaleY:2,onComplete:onUp});
			}
			checked = false;
			this.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
		}
		private function onMove(e:MouseEvent):void
		{
			if (! zooming)
			{
				var tempX = beforeDownX + e.stageX - downX;
				var tempY = beforeDownY + e.stageY - downY;
				image.x = tempX;
				image.y = tempY;
			}
		}
		private var zooming:Boolean = false;
		private var beforeX:Number = 0;
		private var beforeY:Number = 0;
		private var checked:Boolean = false;
		private function onZoom(event:TransformGestureEvent):void
		{
			zooming = true;
			var locX:Number = event.localX;
			var locY:Number = event.localY;
			var stX:Number = event.stageX;
			var stY:Number = event.stageY;
			var prevScaleX:Number = image.scaleX;
			var prevScaleY:Number = image.scaleY;
			var mat:Matrix;
			var externalPoint = new Point(stX,stY);
			var internalPoint = new Point(locX,locY);
			var centerX:Number = image.width;
			var centerY:Number = image.height;

			var temp:Number = 0;//image.scaleY;
			image.scaleX *=  (event.scaleY+temp);
			image.scaleY *=  (event.scaleY+temp);

			if (image.scaleY >= 2 && ! checked)
			{
				beforeX = image.x;
				beforeY = image.y;
				checked = true;
			}
			if (event.scaleX < 1 && image.scaleX < 0.2)
			{
				image.scaleX = prevScaleX;
				image.scaleY = prevScaleY;
			}
			if (event.scaleY < 1 && image.scaleY < 0.2)
			{
				image.scaleX = prevScaleX;
				image.scaleY = prevScaleY;
			}
			//trace(image.scaleX+"            ",image.scaleY);
			//调整坐标
//			mat = image.transform.matrix.clone();
//			MatrixTransformer.matchInternalPointWithExternal(mat,internalPoint,externalPoint);
//			image.transform.matrix = mat;
			image.x -= (locX*image.scaleX - locX*prevScaleX)/1;
			image.y -= (locY*image.scaleY - locY*prevScaleY)/1;
		}
	}
}