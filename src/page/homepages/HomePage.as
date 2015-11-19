package page.homepages
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.buttonRelated.SimpleButton;
	import com.shangyi.component.imageRelated.Image;
	import com.shangyi.component.scrollerRelated.SY_Scroller;
	import com.shangyi.component.scrollerRelated.Scroller;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import json.JsonData;
	import json.JsonDecoder;
	
	import page.functionpage.FunctionPage;
	import page.room.RoomSelectPage;
	import page.room.VideoSelectPage;
	
	import user.UserInfo;
	
	public class HomePage extends Page
	{
		
		public static var functionBar:FunctionPage = new FunctionPage();
		public static var roomSelectpage:RoomSelectPage = new RoomSelectPage();
		public static var allSpacePage:AllSpacePage;// = new AllSpacePage();
		public static var homeRoot:HomePage;
		//private var advertiseContainer:SY_Scroller = new SY_Scroller(1200,340,1200,340);
		private var advertiseContainer:AdvertisementScroller = new AdvertisementScroller();
		private var lifeStyleContainer:SY_Scroller = new SY_Scroller(1200,150,1200,150,0xffffff,0,false);
		private var spaceContainer:SY_Scroller = new SY_Scroller(1200,130,1200,130,0xffffff,0,false);
		
		
		
		private var video:VideoContainer = new VideoContainer();
		
		private var webview:StageWebView = new StageWebView();
		
		private var imageViewer:ImageViewer;
		
		private var downloadpageDic:Dictionary = new Dictionary();
		
		private var AdverTimer:Timer = new Timer(5000);
		
		private var fullScreenBtn:Image = new Image("data/img/max.png");
		
		private var label1:Label = new Label("情景.生活");
		private var label2:Label = new Label("空间选择");
		private var showAllSpaceBtn:SimpleButton = new SimpleButton(80,30,false,0,0,15);
		public function HomePage()
		{
			homeRoot = this;
			loadData();
			addChild(label1);
			addChild(label2);
			addChild(showAllSpaceBtn);
			addChild(advertiseContainer);
					
			lifeStyleContainer.y = 380;
			lifeStyleContainer.scroller.setmasksize(0,200);
			addChild(lifeStyleContainer);
			
			spaceContainer.y = 650;
			spaceContainer.scroller.setmasksize(0,180);
			addChild(spaceContainer);
			addChild(functionBar);
			addChild(fullScreenBtn);
			addChild(roomSelectpage);
			roomSelectpage.visible = false;
			
			
			//initFunctionBar();
			
			video.addEventListener(Event.COMPLETE,function(e:Event):void{
				removeChild(video);
			});
			
			AdverTimer.addEventListener(TimerEvent.TIMER,onTimer);
			AdverTimer.start();		
			
			drawBack();
			
			fullScreenBtn.x = 1108;
			fullScreenBtn.y = 840;
			
			fullScreenBtn.addEventListener(MouseEvent.CLICK,onFullScreen);
			
			addEventListener(Event.ENTER_FRAME,changeFullBtnState);
			
			uploadLocalOrders();
			
			label1.x = 10;label1.y = 350;
			label2.x = 10;label2.y = 610;
			showAllSpaceBtn.x = 1080;showAllSpaceBtn.y = 604;
			showAllSpaceBtn.label = "显示全部 >";
			
			drawLine(0,590,1200,590,0x646464);
			showAllSpaceBtn.addEventListener(MouseEvent.CLICK,onAllSpaceClick);
		}
		
		private function onAllSpaceClick(e:MouseEvent):void{
			if(allSpacePage == null){
				allSpacePage = new AllSpacePage();
				addChild(allSpacePage);
			}else{
				allSpacePage.visible = true;
				addChild(allSpacePage);
			}
		}
		
		private function uploadLocalOrders():void{
			var so:SharedObject = UserInfo.userLocalOrderData;
			//so.clear();
			if(so.data.orderlist == null){
				return;
			}
			var orderList:Array = new Array();
			var flag:Boolean = false;
			var first:Boolean = true;
			var temp:String = "[";
			for each(var js:String in so.data.orderlist){
				if(js == ""){
					continue;
				}
				if(first){
					temp+=js;
					first = false;
				}else{
					temp+=(","+js);
				}
				
				//orderList.push(js);
				flag = true;
			}
			temp+="]";
			if(flag){
				Common.loadURL("furniture/action/order/iosSaveTempOrder?JSESSIONID="+UserInfo.sessionID+"&ordersJson="+temp,onSaveUploaded,null);	
			}

		}
		
		private function onSaveUploaded(e:Event):void{
			var data:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			trace(e.currentTarget.data);
			if(data.success){
				var so:SharedObject = UserInfo.userLocalOrderData
				for each(var obj:Object in data.dataValue.orders){					
					so.data.orderlist[obj.orderNo] = "";				
				}
				so.flush();
			}
			//Alert.alert("订单已上传");
		}
		
		private function changeFullBtnState(e:Event):void
		{
			if(stage.displayState == StageDisplayState.FULL_SCREEN){
				fullScreenBtn.source = "data/img/real.png"
			}else{
				fullScreenBtn.source = "data/img/max.png"
			}
		}
		
		private function onFullScreen(e:MouseEvent):void{
			if(stage.displayState != StageDisplayState.FULL_SCREEN){
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}else{
				stage.displayState = StageDisplayState.NORMAL;
			}
			
		}
		
		private function onTimer(e:TimerEvent):void{
			
		}
		
		private function play(path:String):void{
			addChild(video);
			video.playSt(path);
		}
		
		private function stop(path:String):void{
			video.stopSt(path);
			removeChild(video);
		}
		
		private function loadData():void{
			Common.loadURL("furniture/action/davert/iosAdvert",handleAdvertise,reload1);
			Common.loadURL("furniture/action/lifeway/iosLifewayBefore",handleLifewayBefore,reload2);
			Common.loadURL("furniture/action/space/iosSpaceBefore",handleSpace,reload3);
		}
		
		private function reload1(e:IOErrorEvent):void{
			Common.loadURL("furniture/action/davert/iosAdvert",handleAdvertise,null);
		}
		
		private function reload2(e:IOErrorEvent):void{
			Common.loadURL("furniture/action/lifeway/iosLifewayBefore",handleLifewayBefore,null);
		}
		
		private function reload3(e:IOErrorEvent):void{
			Common.loadURL("furniture/action/space/iosSpaceBefore",handleSpace,null);
		}
		
		private function handleAdvertise(e:Event):void{
			trace("adver");
			var data:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			if(data.success){
				var urlList:Array = new Array();
				var dataList:Array = data.dataValue.datavalue as Array;
				
				for each(var obj:Object in dataList){
					urlList.push(Common.url+"furniture/images/"+obj.ad_logo+".jpg");
				}
				advertiseContainer.setData(urlList,dataList,onAdvertiseClick);
//				
//				advertiseContainer.dataSource(urlList,600,0,onAdvertiseClick);
//				
//				var index:int = 0;
//				for each(var img:Image in advertiseContainer.scroller.btnArr){
//					img.info = dataList[index];
//					index++;
//				}
				
			}
		}
		
		public function clickLifewayByName(no:String):void{
			for each(var img:Image in lifeStyleContainer.scroller.btnArr){
				if(img.info.li_No == no){
					img.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
			}
		}
		
		private function handleLifewayBefore(e:Event):void{
			trace("lifeway");
			var data:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			if(data.success){
				var updatePlistFlag:Boolean = false;
				var urlList:Array = new Array();
				var dataList:Array = data.dataValue.datavalue as Array;
				//检测是否需要同步
				for each(var obj:Object in dataList){
					urlList.push(Common.url+"furniture/images/"+obj.li_logo+".jpg");
					if(UserInfo.diyDataLoaded.indexOf(obj.li_No) != -1){
						if(new File(File.applicationDirectory.resolvePath("data/img/"+obj.li_No+"/"+obj.li_No+"_"+UserInfo.userName+".plist").nativePath).exists){
						
						}else{
							updatePlistFlag = true;
						}
					}
				}
				
//				if(updatePlistFlag){
//					functionBar.sync();
//				}
				/////////////////////////
				lifeStyleContainer.dataSource(urlList,290,12,null);
				lifeStyleContainer.setRoundImages();
				var index:int = 0;
//				UserInfo.diyDataLoaded.push("mzchunjing");
//				UserInfo.diyDataLoaded.push("mzdzh");
//				UserInfo.diyDataLoaded.push("mzflx");
//				UserInfo.userData.data.diyDataLoaded = UserInfo.diyDataLoaded;
//				UserInfo.userData.flush();
				for each(var img:Image in lifeStyleContainer.scroller.btnArr){
					img.info = dataList[index];
					if(!(new File(File.applicationDirectory.nativePath+"/data/img/"+img.info.li_No).exists)){
						if((UserInfo.diyDataLoaded.indexOf(img.info.li_No) != -1)){
							for(var i:int = 0;i<UserInfo.diyDataLoaded.length;i++){
								if(UserInfo.diyDataLoaded[i] == img.info.li_No){
									UserInfo.diyDataLoaded.splice(i,1);
									UserInfo.userData.data.diyDataLoaded = UserInfo.diyDataLoaded;
									UserInfo.userData.flush();
									break;
								}
								
							}
						}
						
					}
					if((UserInfo.diyDataLoaded.indexOf(img.info.li_No) == -1)){//!new File(File.applicationDirectory.nativePath+"/data/img/"+img.info.li_No).exists){
						img.addEventListener(MouseEvent.CLICK,onLoadClick);
						img.addEventListener(Image.GET_DATA,function(evt:Event):void{
							var nameLebel:Label = new Label(evt.currentTarget.info.li_name,15/evt.currentTarget.scaleY);
							nameLebel.color = 0x646464;
							nameLebel.width = 150/evt.currentTarget.scaleY;
							nameLebel.height = 30/evt.currentTarget.scaleY;
							nameLebel.x = 3;
							nameLebel.y = 160/evt.currentTarget.scaleY;
							evt.currentTarget.addChild(nameLebel);
						});
						if(img.back.bitmapData != null){
							img.dispatchEvent(new Event(Image.GET_DATA));
						}
						var filter:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.6,0,0,0,0.3,0.6,0,0,0,0.3,0.6,0,0,0,0,0,0,1,0]) ;
						img.filters = [filter];
					}else{
						img.addEventListener(MouseEvent.CLICK,onLifeWayClick);
						img.addEventListener(Image.GET_DATA,function(evt:Event):void{
							var nameLebel:Label = new Label(evt.currentTarget.info.li_name,15/evt.currentTarget.scaleY);
							nameLebel.color = 0x646464;
							nameLebel.width = 150/evt.currentTarget.scaleY;
							nameLebel.height = 30/evt.currentTarget.scaleY;
							nameLebel.x = 3;
							nameLebel.y = 160/evt.currentTarget.scaleY;
							evt.currentTarget.addChild(nameLebel)
						});
						if(img.back.bitmapData != null){
							img.dispatchEvent(new Event(Image.GET_DATA));
						}
					}
					index++;
				}
				
			}
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
				
				spaceContainer.dataSource(urlList,170,12,null);
				spaceContainer.setRoundImages();
				var index:int = 0;
				for each(var img:Image in spaceContainer.scroller.btnArr){
					img.info = dataList[index];
					img.addEventListener(MouseEvent.CLICK,onSpaceClick);
					
					//生成空间名字label
					img.addEventListener(Image.GET_DATA,function(evt:Event):void{
						
						var nameLebel:Label = new Label(evt.currentTarget.info.sp_name,15/evt.currentTarget.scaleY);
						nameLebel.color = 0x646464;
						nameLebel.width = 150/evt.currentTarget.scaleY;
						nameLebel.height = 40/evt.currentTarget.scaleY;
						nameLebel.x = 3;
						nameLebel.y = 140/evt.currentTarget.scaleY;
						evt.currentTarget.addChild(nameLebel)
						
//						var nameLebel:Label = new Label(evt.currentTarget.info.sp_name,18);
//						nameLebel.x = 3;
//						nameLebel.y = 160/evt.currentTarget.scaleY;
//						evt.currentTarget.addChild(nameLebel)
					});
					if(img.back.bitmapData != null){
						img.dispatchEvent(new Event(Image.GET_DATA));
					}
					index++;
				}
				
			}
		}
		
		//点击未下载状态生活方式
		private function onLoadClick(e:MouseEvent):void{
			var img:Image = e.currentTarget as Image;
			Common.loadURL("furniture/action/lifeway/iosLifewayEject?lifeNo="+img.info.li_id,handleLifewayData,null);
		}
		
		private function handleLifewayData(e:Event):void{
			var data:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			trace(e.currentTarget.data);
			if(data.success){
				var downloadpage:DownloadPage;
				if(downloadpageDic[data.dataValue.datavalue[0].li_id] == undefined){
					downloadpage = new DownloadPage();
					downloadpage.addEventListener(DownloadPage.DATA_READY,onDataReady);
					downloadpageDic[data.dataValue.datavalue[0].li_id] = downloadpage;
				}
				downloadpage = downloadpageDic[data.dataValue.datavalue[0].li_id] as DownloadPage;
				downloadpage.x = 300;
				downloadpage.y = 150;
				
				downloadpage.graphics.beginFill(0,.5);
				downloadpage.graphics.drawRect(-300,-150,Common.MAX_WIDTH,Common.MAX_HEIGHT);
				downloadpage.graphics.endFill();
				downloadpage.graphics.beginFill(0xffffff,1);
				downloadpage.graphics.drawRect(0,0,600,550);
				downloadpage.graphics.endFill();
				
				
				addChild(downloadpage);
				downloadpage.visible = true;
				downloadpage.showData(data.dataValue);
			}
		}
		
		public function onDataReady(e:Event):void{
			for each(var img:Image in lifeStyleContainer.scroller.btnArr){
				if(UserInfo.diyDataLoaded.indexOf(img.info.li_No) == -1){
					img.removeEventListener(MouseEvent.CLICK,onLoadClick);
					img.removeEventListener(MouseEvent.CLICK,onLifeWayClick);
					img.addEventListener(MouseEvent.CLICK,onLoadClick);
					var filter:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.6,0,0,0,0.3,0.6,0,0,0,0.3,0.6,0,0,0,0,0,0,1,0]) ;
					img.filters = [filter];
				}else{
					img.removeEventListener(MouseEvent.CLICK,onLoadClick);
					img.removeEventListener(MouseEvent.CLICK,onLifeWayClick);
					img.addEventListener(MouseEvent.CLICK,onLifeWayClick);
					img.filters = [];
				}
			}
		}
		
		
		
		
		//点击普通状态生活方式
		private function onLifeWayClick(e:MouseEvent):void{
			var img:Image = e.currentTarget as Image;
			Common.currentPath = img.info.li_No;
			Common.MAIN.roomLayer.addChild(new VideoSelectPage());
//			roomSelectpage.visible = true;
//			roomSelectpage.showRooms(e.currentTarget.info.sp_id);
		}
		
		private function onSpaceClick(e:MouseEvent):void{
			var img:Image = e.currentTarget as Image;
			roomSelectpage.visible = true;
			roomSelectpage.showRooms(e.currentTarget.info.sp_id);
		}
		
		//点击广告
		private function onAdvertiseClick(e:MouseEvent):void{
//			play(Common.url+"furniture/uploadMp4/"+"8bb945cb-ef14-45af-9599-35054382730a.mp4");
//			return;
			var img:Image = e.currentTarget as Image;
			switch(img.info.status){
				case 1:
					navigateToURL(new URLRequest(img.info.url));
					
//					webview.stage = Common.MAIN.stage;
//					webview.viewPort = new Rectangle( 0, 50, stage.stageWidth, stage.stageHeight);
//					webview.loadURL(img.info.url);
					break;
				case 2:
					addChild(new ImageViewer(Common.url+"furniture/images/"+img.info.url+".jpg"));
					break;
				case 3:
//					webview.stage = Common.MAIN.stage;
//					webview.viewPort = new Rectangle( 0, 50, stage.stageWidth, stage.stageHeight);
//					webview.loadURL(Common.url+"furniture/uploadMp4/"+img.info.url);
//					navigateToURL(new URLRequest(Common.url+"furniture/uploadMp4/"+img.info.url));
					play(Common.url+"furniture/uploadMp4/"+img.info.url);
					break;
				case 4:
					break;
			}
		}
			
	}
}














