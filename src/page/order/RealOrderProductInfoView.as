package page.order
{
	import com.shangyi.component.imageRelated.Image;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import page.alertpage.Confirm;
	import page.room.RoomPage;
	
	
	public class RealOrderProductInfoView extends Sprite
	{
		//private var companyLabel:Label = new Label();
		private var brandLabel:Label = new Label();
		private var productTotalPriceLabel:Label = new Label();
		private var productTypeLabel:Label = new Label();
		private var numLabel:Label = new Label();
		private var priceLabel:Label = new Label();
		public var data:Object;
		public var type:String;
		private var deleteBtn:Image = new Image(Main.basePath + "data/img/close.png");
		private var plusBtn:Image = new Image(Main.basePath + "data/img/plus.png");
		private var minusBtn:Image = new Image(Main.basePath + "data/img/minus.png");
		
		private var offsetX:Number = -20;
		public function RealOrderProductInfoView(data:Object)
		{
			//this.type = data["sc_name"];
			this.data = data;
			brandLabel.x = offsetX + 0;				
			productTypeLabel.x = offsetX + 300;
			priceLabel.x = offsetX + 560;
			numLabel.x = offsetX + 760;				
			productTotalPriceLabel.x = offsetX + 970;
			
			deleteBtn.x = offsetX + 1060;
			plusBtn.x = offsetX + 800;
			minusBtn.x = offsetX + 700;
			
			brandLabel.text = data["sc_name"];
			productTotalPriceLabel.text = (Number(data["sc_money"])*Number(data["sc_number"])).toString();
			productTypeLabel.text = data["sc_guige"];
			priceLabel.text = data["sc_money"];
			numLabel.text = data["sc_number"];
			minusBtn.visible = (numLabel.text != "1");
			brandLabel.width = 240;
			productTotalPriceLabel.width = 170;
			productTypeLabel.width = 240;
			
			
			brandLabel.size = "20";
			productTotalPriceLabel.size = "20";
			productTypeLabel.size = "20";
			numLabel.size = "20";
			priceLabel.size = "20";
			
			brandLabel.mouseChildren = productTotalPriceLabel.mouseChildren = productTypeLabel.mouseChildren = numLabel.mouseChildren = priceLabel.mouseChildren = false;
			brandLabel.mouseEnabled = productTotalPriceLabel.mouseEnabled = productTypeLabel.mouseEnabled = numLabel.mouseEnabled = priceLabel.mouseEnabled = false;
			
			addChild(plusBtn);
			addChild(minusBtn);
			
			
			addChild(brandLabel);
			addChild(productTotalPriceLabel);
			addChild(productTypeLabel);
			addChild(numLabel);
			addChild(priceLabel);
			addChild(deleteBtn);
			//				addChild(priceLabel);
			
			plusBtn.addEventListener(MouseEvent.CLICK,onClick);
			minusBtn.addEventListener(MouseEvent.CLICK,onClick);
			deleteBtn.addEventListener(MouseEvent.CLICK,onClick);
			
		}
		
		private function onClick(e:MouseEvent):void{
			switch(e.currentTarget){
				case plusBtn:
					var num:Number = Number(numLabel.text);
					num++;
					numLabel.text = num.toString();
					data["sc_number"] = num.toString();
					productTotalPriceLabel.text = (Number(data["sc_money"])*Number(data["sc_number"])).toString();
					minusBtn.visible = true;
					OrderDetailPage.instance.setZongjia();
					break;
				case minusBtn:
					var num:Number = Number(numLabel.text);
					num--;
					if(num == 1){
						minusBtn.visible = false;
					}
					numLabel.text = num.toString();
					data["sc_number"] = num.toString();
					productTotalPriceLabel.text = (Number(data["sc_money"])*Number(data["sc_number"])).toString();
					OrderDetailPage.instance.setZongjia();
					break;
				case deleteBtn:
					Confirm.confirm("确认删除",this);
					break;
			}
		}
		
		public function clear():void{
			if(parent){
				parent.removeChild(this);
			}
		}
		
	}
}