package
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	
	import flash.events.Event;
	
	public class LoadingMc extends Page
	{
		
		private var img:Image = new com.shangyi.component.imageRelated.Image("data/img/loading.png");
		private var r:Number = 0;
		public function LoadingMc()
		{
			drawBack(Common.MAX_WIDTH,Common.MAX_HEIGHT,0,.6);
			addChild(img);
			addEventListener(Event.ENTER_FRAME,onFrame);
			img.addEventListener(Image.GET_DATA,locate);
		}
		
		private function locate(e:Event):void{
			img.back.x = - img.back.width/2;
			img.back.y = - img.back.height/2;
			img.x = (Common.MAX_WIDTH)/2;
			img.y=  (Common.MAX_HEIGHT)/2;
		}
		
		private function onFrame(e:Event):void{
			r += 12;
			if(r>360)r=0;
			img.rotation = r;
		}
		
	}
}