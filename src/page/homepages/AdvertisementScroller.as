package page.homepages
{
	import com.greensock.BlitMask;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class AdvertisementScroller extends Page
	{
		
		private var imageContainer:Page = new Page();
		
		private var btnContainer:Page = new Page();
		
		private var blitMask1:BlitMask;// = new BlitMask( imageContainer, 0,0, 1200, 340, true, true, 0xffff00, true);
		
		private var max:int;
		private var mask1:Sprite = new Sprite();
		private var adverTimer:Timer = new Timer(5000);
		private var eventMask:Sprite = new Sprite();
		public function AdvertisementScroller()
		{
			mask1.graphics.beginFill(0,0);
			mask1.graphics.drawRect(0,0,1200,340);
			mask1.graphics.endFill();
			addChild(mask1);
			mask = mask1;
			imageContainer.x = 300;
			addChild(imageContainer);
			addChild(btnContainer);
			adverTimer.addEventListener(TimerEvent.TIMER,onAdverTimer);
			adverTimer.start();
			
			
			eventMask.graphics.beginFill(0,0);
			eventMask.graphics.drawRect(0,0,1200,340);
			eventMask.graphics.endFill();
			addChild(eventMask);
			eventMask.visible = false;
			
			
		}
		
		private var tweening:Boolean = false;
		private function onAdverTimer(e:TimerEvent):void
		{
			if(tweening)return;
			tweening = true;
			if(currentNum == max-1){
				TweenLite.to(imageContainer,1,{x:((currentNum+1)*-600)+300,onComplete:onEndComplete});
			}else{
				TweenLite.to(imageContainer,1,{x:((currentNum+1)*-600)+300,onComplete:onComplete});
			}
			
			for each(var b:AdverPointBtn in btnList){
				b.selected = false;
			}
			
			
			currentNum++;
			if(currentNum > (max - 1)){
				currentNum = 0;
			}	
			btnList[currentNum].selected = true;
		}
		
		public var currentNum:int = 0;
		private var btnList:Array = new Array();
		public function setData(imgList:Array,dataList:Array,f:Function):void{
			max = imgList.length;
			
			//添加点按钮
			for (var i:int = 0; i < max; i++) 
			{
				var btn:AdverPointBtn = new AdverPointBtn(5);
				btn.index = i;
				btn.x = i*30+540;
				btn.y = 300;
				btnContainer.addChild(btn);
				btn.addEventListener(MouseEvent.CLICK,onClick);
				btnList.push(btn);
			}
			btnList[0].selected = true;
			
			var index:int = 0;
			//开头结尾加一张
			
			var imge:Image = new Image(imgList[imgList.length - 1]);
			imge.width = 600;
			imge.height = 340;
			imge.x = -600;
			imge.info = dataList[dataList.length - 1];
			imge.addEventListener(MouseEvent.CLICK,f);
			imageContainer.addChild(imge);
			for each(var path:String in imgList){
				var img:Image = new Image(path);
				img.width = 600;
				img.height = 340;
				img.x = 600*index;
				img.info = dataList[index];
				imageContainer.addChild(img);
				img.addEventListener(MouseEvent.CLICK,f);
				index++;
			}
			
			var imgs:Image = new Image(imgList[0]);
			imgs.width = 600;
			imgs.height = 340;
			imgs.x = 600*index;
			imgs.info = dataList[0];
			imageContainer.addChild(imgs);
			imgs.addEventListener(MouseEvent.CLICK,f);
			index++;
			imgs = new Image(imgList[1]);
			imgs.width = 600;
			imgs.height = 340;
			imgs.x = 600*index;
			imgs.info = dataList[1];
			imageContainer.addChild(imgs);
			imgs.addEventListener(MouseEvent.CLICK,f);
			
		}
		
		private function onClick(e:MouseEvent):void{
			adverTimer.stop();
			adverTimer.start();
			if(tweening)return;
			tweening = true;
			currentNum = e.currentTarget.index;
			imageContainer.x = ((currentNum)*-600)+300;
			for each(var b:AdverPointBtn in btnList){
				b.selected = false;
			}
			btnList[currentNum].selected = true;
			tweening = false;
		}
		
		private function onComplete():void{
			tweening = false;
		}
		
		private function onEndComplete():void{
			imageContainer.x = 300;
			tweening = false;
			//TweenLite.to(imageContainer,.5,{x:300});
		}
		
//		private function createBtn(data:Object):AdverPointBtn{
//			return null;
//		}
		
	}
}