package page.functionpage
{
	import com.shangyi.component.base.Page;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	import page.functionpage.changeuser.ChangeUserPage;
	import page.functionpage.config.ConfigPage;
	import page.functionpage.pricesync.PriceSynchronizePage;
	import page.functionpage.update.UpdatePage;
	import page.homepages.HomePage;
	import page.order.XorderListPage;
	
	public class FunctionPage extends Page
	{
		
		public static var updatepage:UpdatePage;
		public static var changeUserpage:ChangeUserPage;
		public static var syncpage:PriceSynchronizePage;
		public static var configpage:ConfigPage;
		public static var orderpage:XorderListPage;
		public static var instance:FunctionPage;
		
		public var updateSignal:Shape = new Shape();
		public function FunctionPage()
		{
			initPage();
			instance = this;
			
			updateSignal.graphics.beginFill(0xff0000,1);
			updateSignal.graphics.drawCircle(0,0,5);
			updateSignal.graphics.endFill();
			updateSignal.x = 660/this.backImage.scaleX;
			updateSignal.y = 20;
			updateSignal.visible = false;
			addChild(updateSignal);
			//为了显示更新红点，先实例化
			//updatepage = new UpdatePage();
		}
		
		//public function showUpdate
		
		private function initPage():void{
			this.y = 830;
			this.backSource = "data/img/ui/gongnengjian3.png";
			this.x = 200;
			this.backImage.width = 800;
			this.backImage.height = 70;
			this.addEventListener(MouseEvent.CLICK,onthisClick);
		}
		
		public function sync():void{
			if(!syncpage){
				syncpage = new PriceSynchronizePage();
				syncpage.x = 500;
				syncpage.y = 400;
				syncpage.graphics.beginFill(0,.5);
				syncpage.graphics.drawRect(-500,-400,Common.MAX_WIDTH,Common.MAX_HEIGHT-80);
				syncpage.graphics.endFill();
			}else{
				syncpage.visible = true;
				syncpage.synchronize();
			}
			
			(Common.MAIN as Main).functionLayer.addChild(syncpage);
		}
		
		public function showHomePage():void{
			for(var i:int = 0;i<(Common.MAIN as Main).functionLayer.numChildren;i++){
				(Common.MAIN as Main).functionLayer.getChildAt(i).visible = false;
			}
			(Common.MAIN as Main).functionLayer.visible = false;
			if(HomePage.allSpacePage){
				HomePage.allSpacePage.visible = false;
			}
			
		}
		
		private function onthisClick(e:MouseEvent):void{
			(Common.MAIN as Main).functionLayer.visible = true;
			
			
			if(Common.checkClick(120/this.backImage.scaleX,0,70/this.backImage.scaleX,65/this.backImage.scaleY,e)){
				showHomePage();
			}
			
			
			if(Common.checkClick(220/this.backImage.scaleX,0,70/this.backImage.scaleX,65/this.backImage.scaleY,e)){
				if(!orderpage){
					orderpage = new XorderListPage();
				}else{
					orderpage.visible = true;
					orderpage.loadOrders();
				}
				
				(Common.MAIN as Main).functionLayer.addChild(orderpage);
			}
			
			
			if(Common.checkClick(320/this.backImage.scaleX,0,70/this.backImage.scaleX,65/this.backImage.scaleY,e)){
				sync();
			}
			
			
			if(Common.checkClick(420/this.backImage.scaleX,0,70/this.backImage.scaleX,65/this.backImage.scaleY,e)){
				if(!configpage){
					configpage = new ConfigPage();
					configpage.x = 0;
					configpage.y = 760;				
				}else{
					configpage.visible = !configpage.visible;
					if(configpage.stage == null){
						configpage.visible = true;
					}
				}
				
				(Common.MAIN as Main).functionLayer.addChild(configpage);
			}
			
			
			if(Common.checkClick(520/this.backImage.scaleX,0,70/this.backImage.scaleX,65/this.backImage.scaleY,e)){
				if(!changeUserpage){
					changeUserpage = new ChangeUserPage();
					changeUserpage.x = 290;
					changeUserpage.y = 120;
					changeUserpage.graphics.beginFill(0,.5);
					changeUserpage.graphics.drawRect(-290,-120,Common.MAX_WIDTH,Common.MAX_HEIGHT);
					changeUserpage.graphics.endFill();
					
				}else{
					changeUserpage.visible = true;
				}
				
				(Common.MAIN as Main).functionLayer.addChild(changeUserpage);
			}
			
			
			if(Common.checkClick(620/this.backImage.scaleX,0,70/this.backImage.scaleX,65/this.backImage.scaleY,e)){
				if(!updatepage){
					updatepage = new UpdatePage();
				}else{
					updatepage.visible = true;
					updateSignal.visible = false;
				}
				
				(Common.MAIN as Main).functionLayer.addChild(updatepage);
			}
			
			
		}
		
	}
}