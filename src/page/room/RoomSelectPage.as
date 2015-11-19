package page.room
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.buttonRelated.Button;
	import com.shangyi.component.imageRelated.Image;
	import com.shangyi.component.scrollerRelated.SY_Scroller;
	import com.shangyi.component.scrollerRelated.Scroller;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import json.JsonData;
	import json.JsonDecoder;
	
	import page.alertpage.Confirm;
	import page.homepages.HomePage;
	
	import user.UserInfo;
	
	public class RoomSelectPage extends Page
	{
		
		private var scroller:Scroller = new Scroller(Common.MAX_WIDTH,Common.MAX_HEIGHT*3/4+120,1);
		private var exit:Button = new Button(75,60,1100,820);
		public function RoomSelectPage()
		{
			backSource = "data/img/roomselectback.jpg";
			scroller.graphics.beginFill(0xffffff,1);
			scroller.graphics.drawRect(0,0,Common.MAX_WIDTH,Common.MAX_HEIGHT*3/4+120);
			scroller.graphics.endFill();
			addChild(scroller);
			addChild(exit);
			exit.addEventListener(MouseEvent.CLICK,exitf);
		}
		
		private function exitf(e:MouseEvent):void{
			this.visible = false;
		}
		
		public function showRooms(id:String):void{
			Common.loadURL("furniture/action/space/iosLifewayAndSpace?spaceid="+id,handleSelect,null);
		}
		
		private function showLoadAlert(e:MouseEvent):void{
			Confirm.confirm("返回首页下载？",e.currentTarget as EventDispatcher);
		}
		
		private function onload(e:Event):void{
			this.visible = false;
			HomePage.homeRoot.clickLifewayByName(e.currentTarget.info.li_no);
		}
		
		private function handleSelect(e:Event):void{
			scroller.clearContent();
			var data:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			trace(e.currentTarget.data);
			if(data.success){
				var i:int = 0;
				for each(var obj:Object in data.dataValue.lifeWays){
					var container:Page = new Page();
					container.info = obj;
					var logo:Image = new Image(Common.getImageUrljpg(obj.li_logo));
					logo.setRoundMask();
					var label:Label = new Label(obj.li_name,20);
					var roomScroller:SY_Scroller = new SY_Scroller(Common.MAX_WIDTH,140,Common.MAX_WIDTH,140);
					roomScroller.x = 10;
					var array:Array = new Array();
					for each(var o:Object in obj.spaces){
						array.push(Common.getImageUrljpg(o.sp_logo));
					}
					roomScroller.dataSource(array,300,15,onRoomClick);
					roomScroller.setRoundImages();
					var index:int = 0;
					for each(var img:Image in roomScroller.scroller.btnArr){
						img.info = obj.spaces[index];
						index++;
						if(UserInfo.diyDataLoaded.indexOf(img.info.li_no) == -1){
							img.removeEventListener(MouseEvent.CLICK,onRoomClick);
							img.addEventListener(MouseEvent.CLICK,showLoadAlert);
							img.addEventListener(Confirm.YES,onload);
							img.setGray();
						}
						
					}
					logo.width = 100;
					logo.height = 75;
					logo.x = 10;
					label.x = 150;
					label.width = 200;
					roomScroller.y = 80;
					container.addChild(logo);
					container.addChild(label);
					container.addChild(roomScroller);
					container.drawLine(0,230,Common.MAX_WIDTH,230);
					container.y = i*240;
					i++;
					scroller.addChild(container);
				}
			}
		}
		private var currentImg:Image;
		private function onRoomClick(e:MouseEvent):void{
			currentImg = e.currentTarget as Image;
			Common.currentPath = currentImg.info.li_no;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(Main.basePath+"data/img/"+Common.currentPath+"/"+Common.currentPath+"_"+UserInfo.userName+".plist"));
			urlLoader.addEventListener(Event.COMPLETE,onLoadComplete);
		}
		
		private function onLoadComplete(e:Event):void{
			Common.plistToDictionary(new XML(e.target.data));
//			currentDic = Common.currentRoomData[Common.currentPath+"_video"];
//			video.playSt(Common.getVideoPath(currentDic["source"]));
			
			Common.MAIN.roomLayer.addChild(new RoomPage(currentImg.info.sp_No,null,false));
			
		}	
		
	}
}
















