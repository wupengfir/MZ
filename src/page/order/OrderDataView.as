package page.order
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	
	public class OrderDataView extends Page
	{
		
		public var img:Image = new Image("data/img/ui/wawa.png");
		public var customerNameLabel:Label = new Label("",18);
		public var customerAddressLabel:Label = new Label("",18);
		public var customerPhoneLabel:Label = new Label("",18);
		public var customerReceiverNameLabel:Label = new Label("",18);
		
		public var data:OrderData;
		private var ps:XML = 
			<root>
				<object name="img" x="18" y="15"/>
				<object name="customerNameLabel" x="90" y="15"/>
				<object name="customerPhoneLabel" x="90" y="70"/>
				<object name="customerAddressLabel" x="400" y="70"/>
				<object name="customerReceiverNameLabel" x="960" y="40"/>
			</root>
		
		public function OrderDataView(_data:OrderData)
		{
			this.data = _data;
			initByPageScript(ps);
			customerNameLabel.text = data.customerName;
			customerAddressLabel.text = data.customerAddress;
			customerAddressLabel.width = 500;
			customerPhoneLabel.width = 200;
			customerPhoneLabel.text = data.customerPhone;
			customerReceiverNameLabel.text = data.customerReceiverName;
			//drawBack(1000,100,0x00ffff);
			img.scaleX = img.scaleY = 1/2;
			drawLine(100,100,1200,100);
		}
	}
}





















