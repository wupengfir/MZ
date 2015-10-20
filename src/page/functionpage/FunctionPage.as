package page.functionpage
{
	import com.shangyi.component.base.Page;
	
	import flash.events.MouseEvent;
	
	import page.functionpage.update.UpdatePage;
	
	public class FunctionPage extends Page
	{
		
		//private var updatepage:UpdatePage;
		
		public function FunctionPage()
		{
			initPage();
		}
		
		private function initPage():void{
			this.y = 830;
			this.backSource = "data/img/ui/gongnengjian3.png";
			this.x = 200;
			this.backImage.width = 800;
			this.backImage.height = 70;
			this.addEventListener(MouseEvent.CLICK,onthisClick);
		}
		
		private function onthisClick(e:MouseEvent):void{
			if(Common.checkClick(120/this.backImage.scaleX,0,70/this.backImage.scaleX,65/this.backImage.scaleY,e)){
				trace("1");
			}
			if(Common.checkClick(220/this.backImage.scaleX,0,70/this.backImage.scaleX,65/this.backImage.scaleY,e)){
				trace("2");
			}
			if(Common.checkClick(320/this.backImage.scaleX,0,70/this.backImage.scaleX,65/this.backImage.scaleY,e)){
				trace("3");
			}
			if(Common.checkClick(420/this.backImage.scaleX,0,70/this.backImage.scaleX,65/this.backImage.scaleY,e)){
				trace("4");
			}
			if(Common.checkClick(520/this.backImage.scaleX,0,70/this.backImage.scaleX,65/this.backImage.scaleY,e)){
				trace("5");
			}
			if(Common.checkClick(620/this.backImage.scaleX,0,70/this.backImage.scaleX,65/this.backImage.scaleY,e)){
				var updatepage:UpdatePage = new UpdatePage();
				//updatepage.x = -150;
				//updatepage.y = -500;
				Common.MAIN.addChild(updatepage);
			}
		}
		
	}
}