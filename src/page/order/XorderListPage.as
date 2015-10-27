package page.order
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.scrollerRelated.Scroller;
	
	public class XorderListPage extends Page
	{
		private var scroller:Scroller = new Scroller(Common.MAX_WIDTH,800);
		private var orderList:Array;
		public function XorderListPage()
		{
			backSource = "data/img/ui/orderlistback.png";
			backImage.height = 800;
			scroller.y = 100;
			addChild(scroller);
			showList();
		}
		
		public function showList():void{
			scroller.clearContent();
			orderList = getOrderData();
			var index:int = 0;
			for each(var data:OrderData in orderList){
				var view:OrderDataView = new OrderDataView(data);
				view.y = index*75;
				index++;
				scroller.addChild(view);
			}		
		}
		
		private function getOrderData():Array{
			var o:OrderData = new OrderData();
			o.customerAddress = "dizhi";
			o.customerName = "司思思";
			o.customerPhone = "13545672345";
			o.customerReceiverName = "搜懂得";
			
			var a:Array = new Array();
			a.push(o);
			return a;	
		}
		
	}
}