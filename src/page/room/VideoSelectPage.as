package page.room
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import user.UserInfo;
	
	public class VideoSelectPage extends Page
	{
		public static var vpage:VideoSelectPage;
		private var path:String;
		private var video:VideoContainer = new VideoContainer(false);
		private var data:XML;
		private var state:String;
		private var currentDic:Dictionary;
		private var btnContainer:Sprite = new Sprite;
		public var back:Image = new Image("data/img/roompic/back.png",true);
		public function VideoSelectPage()
		{
			vpage = this;
			state="normal";
			backImage.scaleMax();
			addChild(video);
			addChild(btnContainer);
			back.x = back.y = 10;
			addChild(back);
			back.addEventListener(MouseEvent.CLICK,onBack);
			video.addEventListener(VideoContainer.COMPLETE,onPlayEnd);
//			backImage.addEventListener(Image.GET_DATA,function(e:Event):void{
//				video.visible = false;
//			});
			loadXml();
		}
		
		private function onBack(e:MouseEvent):void{
			if(currentDic["type"] == "root"){
				clear();
				return;
			}
			video.visible = true;
			video.playSt(Common.getVideoPath(currentDic["source"]+"_back"));
			currentDic = Common.currentRoomDicDic[currentDic["prent"]];
		}
		
		private function loadXml():void{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(Main.basePath+"data/img/"+Common.currentPath+"/"+Common.currentPath+"_"+UserInfo.userName+".plist"));
			urlLoader.addEventListener(Event.COMPLETE,onLoadComplete);
		}
		
		private function onPlayEnd(e:Event):void{
			if(currentDic["type"]=="normal"||currentDic["type"]=="root"){
				backSource = Common.getBigImagePath(currentDic["stayat"].toString());
				btnContainer.removeChildren();
				if(currentDic["video"]!=null){
					for each(var xml:Dictionary in currentDic["video"]){
						var btn:Image = new Image("data/img/videopic/" + xml["btnsource"]);
						btn.x = Number(xml["x"]);
						btn.y = Number(xml["y"]);
						btnContainer.addChild(btn);
						btn.info = xml;
						btn.addEventListener(MouseEvent.CLICK,onBtnClick);
					}
				}			
			}else if(currentDic["type"]=="final"){
				Common.MAIN.roomLayer.addChild(new RoomPage(currentDic["name"]));
			}
			setTimeout(function(){video.visible = false;},200);
		}
		
		private function onBtnClick(e:MouseEvent):void{
			video.visible = true;
			currentDic = e.currentTarget.info;
			video.playSt(Common.getVideoPath(currentDic["source"]));
		}
		
		private function onLoadComplete(e:Event):void{
			data = new XML(e.target.data);
			Common.plistToDictionary(data);
			currentDic = Common.currentRoomData[Common.currentPath+"_video"];
			video.playSt(Common.getVideoPath(currentDic["source"]));
			
		//	addChild(new RoomPage("canting"));
			
		}	
		
	}
}