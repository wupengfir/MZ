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

	
	public class ProductInfo extends Sprite
	{
		//private var companyLabel:Label = new Label();
		private var brandLabel:Label = new Label();
		private var productTotalPriceLabel:Label = new Label();
		private var productTypeLabel:Label = new Label();
		private var numLabel:Label = new Label();
		private var priceLabel:Label = new Label();
		public var info:Dictionary;
		public var type:String;
		private var deleteBtn:Image = new Image(Main.basePath + "data/img/close.png");
		private var plusBtn:Image = new Image(Main.basePath + "data/img/plus.png");
		private var minusBtn:Image = new Image(Main.basePath + "data/img/minus.png");
		
		private var offsetX:Number = -20;
		public function ProductInfo(data:Dictionary)
		{
				this.type = data["name"];
				info = data;
				brandLabel.x = offsetX + 0;				
				productTypeLabel.x = offsetX + 300;
				priceLabel.x = offsetX + 560;
				numLabel.x = offsetX + 760;				
				productTotalPriceLabel.x = offsetX + 970;

				deleteBtn.x = offsetX + 1060;
				plusBtn.x = offsetX + 800;
				minusBtn.x = offsetX + 700;
				
				brandLabel.text = data["brandName"];
				productTotalPriceLabel.text = (Number(data["price"])*Number(data["num"])).toString();
				productTypeLabel.text = data["guige"];
				priceLabel.text = data["price"];
				numLabel.text = data["num"];
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
					info["num"] = num.toString();
					productTotalPriceLabel.text = (Number(info["price"])*Number(info["num"])).toString();
					minusBtn.visible = true;
					RoomPage.MAIN.setZongjia();
					break;
				case minusBtn:
					var num:Number = Number(numLabel.text);
					num--;
					if(num == 1){
						minusBtn.visible = false;
					}
					numLabel.text = num.toString();
					info["num"] = num.toString();
					productTotalPriceLabel.text = (Number(info["price"])*Number(info["num"])).toString();
					RoomPage.MAIN.setZongjia();
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