package page.functionpage.update
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.buttonRelated.SimpleButton;
	import com.shangyi.component.imageRelated.Image;
	
	import fl.controls.CheckBox;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import json.JsonData;
	import json.JsonDecoder;
	
	import page.homepages.DownloadPage;
	
	import user.UserInfo;

	public class UpdateSpace extends Page
	{
		
		public static const GOT_DATA:String = "GOT_DATA";
		
		public var checkBox:CheckBox = new CheckBox();
		public var image:Image = new Image();
		public var nameLabel:Label = new Label("",20);
		public var descLabel:Label = new Label("",16);
		public var button:SimpleButton = new SimpleButton(100,40,false,0xffffff,1);
		public var deleteButton:Image = new Image("data/img/delete.jpg");
		public var updateAble:Boolean = false;
		public var dataObj:Object;
		
		private var ps:XML = 
			<root>
				<object name="checkBox" x="10" y="40"/>
				<object name="image" x="50" y="10"/>
				<object name="nameLabel" x="180" y="20"/>
				<object name="descLabel" x="360" y="20"/>	
				<object name="button" x="960" y="40"/>	
				<object name="deleteButton" x="1100" y="10"/>	
			</root>
		
		public function UpdateSpace(data:Object)
		{
			initByPageScript(ps);
			drawLine(100,140,Common.MAX_WIDTH,140);
			
			checkBox.label = "";
			image.width = 125;
			image.height = 100;
			
			descLabel.width = 440;
			descLabel.height = 100;
			
			button.addEventListener(MouseEvent.CLICK,onUpdateClick);
			Common.loadURL("furniture/action/lifeway/iosLifewayEject?lifeNo="+data.li_id,handleLifewayData,null);
			//addEventListener(GOT_DATA,);
		}
		
		private function onUpdateClick(e:MouseEvent):void{
			if(updateAble){
				
			}
		}
		
		private function handleLifewayData(e:Event):void{
			var data1:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			var data:Object = data1.dataValue;
			if(data1.success){
				this.dataObj = data;
				image.source = Common.getImageUrljpg(data.datavalue[0].li_logo);
				nameLabel.text = data.datavalue[0].li_name;
				descLabel.text = data.datavalue[0].li_explain;
			}
			dispatchEvent(new Event(GOT_DATA));
		}
		
		
		
	}
}













