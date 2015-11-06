package page.homepages
{
	import com.greensock.BlitMask;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class AdvertisementScroller extends Page
	{
		
		private var imageContainer:Page = new Page();
		
		private var btnContainer:Page = new Page();
		
		private var blitMask1:BlitMask;// = new BlitMask( imageContainer, 0,0, 1200, 340, true, true, 0xffff00, true);
		
		private var max:int;
		private var mask1:Sprite = new Sprite();
		public function AdvertisementScroller()
		{
			mask1.graphics.beginFill(0,0);
			mask1.graphics.drawRect(0,0,1200,340);
			mask1.graphics.endFill();
			addChild(mask1);
			mask = mask1;
			addChild(imageContainer);
			addChild(btnContainer);
			addEventListener(MouseEvent.CLICK,onClick)
			//blitMask1 = new BlitMask( imageContainer, 0,0, 1200, 340, true, true, 0xffff00, true);
		}
		
		public var currentNum:int = -1;
		public function setData(imgList:Array,dataList:Array):void{
			max = imgList.length;
			var index:int = 0;
			//开头结尾加一张
			
			var imge:Image = new Image(imgList[imgList.length - 1]);
			imge.width = 600;
			imge.height = 340;
			imge.x = -600;
			imge.info = dataList[dataList.length - 1];
			imageContainer.addChild(imge);
			for each(var path:String in imgList){
				var img:Image = new Image(path);
				img.width = 600;
				img.height = 340;
				img.x = 600*index;
				img.info = dataList[index];
				imageContainer.addChild(img);
				index++;
			}
			
			var imgs:Image = new Image(imgList[0]);
			imgs.width = 600;
			imgs.height = 340;
			imgs.x = 600*index;
			imgs.info = dataList[0];
			imageContainer.addChild(imgs);
			
			onClick(null);
		}
		
		//private var i:int = 0;
		private function onClick(e:MouseEvent):void{
			TweenLite.to(imageContainer,1,{x:(currentNum*-600)-300,onComplete:onComplete});
			currentNum++;
			if(currentNum > (max - 2)){
				currentNum = -1;
			}
		}
		
		private function onComplete():void{
			
		}
		
		private function createBtn(data:Object):Sprite{
			return null;
		}
		
	}
}