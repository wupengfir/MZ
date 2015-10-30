package page.room
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class NoticePage extends Page
	{
		
		public static var notice:NoticePage = new NoticePage();
		private var sign3:Image = new Image(File.documentsDirectory.url+"/data/" + "img/click.png");
		public function NoticePage()
		{
			graphics.beginFill(0,.6);
			graphics.drawRect(0,0,Common.MAX_WIDTH,Common.MAX_HEIGHT);
			graphics.endFill();	
			

			//sign3.x = 400;
//			sign3.y = 300;

			addChild(sign3);
			
			addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				clearTimeout(i);
				hide();
			});
		}
		
		private var i:uint;
		public function show():void{
			Common.MAIN.stage.addChild(notice);
			i = setTimeout(hide,4000);
			
			RoomPage.MAIN.rightBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			RoomPage.MAIN.closePoints(null);
		}
		
		public function hide():void{
			notice.visible = false;
		}
		
	}
}