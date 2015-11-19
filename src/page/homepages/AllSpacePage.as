package page.homepages
{

	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	import com.shangyi.component.scrollerRelated.SY_Scroller;
	import com.shangyi.component.scrollerRelated.Scroller;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import json.JsonData;
	import json.JsonDecoder;
	
	public class AllSpacePage extends Page
	{
		private var spaceContainer:SY_Scroller = new SY_Scroller(1200,750,1080,750,0xffffff,1);
		private var label:Label = new Label("空间选择",20);
		public function AllSpacePage()
		{
			label.x = 55;
			label.y = 10;
			addChild(label);
			spaceContainer.y = 55;
			addChild(spaceContainer);
			drawBack(Common.MAX_WIDTH,Common.MAX_HEIGHT-80);
			Common.loadURL("furniture/action/space/iosSpaceBefore",handleSpace,null);
			//setCloseBtn(Common.MAX_WIDTH-60,0);
		}
		
		private function onSpaceClick(e:MouseEvent):void{
			this.visible = false;
			var img:Image = e.currentTarget as Image;
			HomePage.roomSelectpage.visible = true;
			HomePage.roomSelectpage.showRooms(e.currentTarget.info.sp_id);
		}
		
		private function handleSpace(e:Event):void{
			trace("space");
			var data:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			if(data.success){
				var urlList:Array = new Array();
				var dataList:Array = data.dataValue.datavalue as Array;
				
				for each(var obj:Object in dataList){
					urlList.push(Common.url+"furniture/images/"+obj.sp_logo+".jpg");
				}
				
				spaceContainer.dataSource(urlList,80,15,null,0,6,45);
				spaceContainer.setRoundImages();
				var index:int = 0;
				for each(var img:Image in spaceContainer.scroller.btnArr){
					img.info = dataList[index];
					img.addEventListener(MouseEvent.CLICK,onSpaceClick);
					
					//生成空间名字label
					img.addEventListener(Image.GET_DATA,function(evt:Event):void{
						
						var nameLebel:Label = new Label(evt.currentTarget.info.sp_name,18/evt.currentTarget.scaleY);
						nameLebel.color = 0x646464;
						//nameLebel
						nameLebel.width = 150/evt.currentTarget.scaleY;
						nameLebel.height = 40/evt.currentTarget.scaleY;
						nameLebel.x = 3;
						nameLebel.y = 140/evt.currentTarget.scaleY;
						evt.currentTarget.addChild(nameLebel)
					});
					if(img.back.bitmapData != null){
						img.dispatchEvent(new Event(Image.GET_DATA));
					}
					index++;
				}
				
			}
		}
	}
}