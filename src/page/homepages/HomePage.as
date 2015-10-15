package page.homepages
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	import com.shangyi.component.scrollerRelated.SY_Scroller;
	import com.shangyi.component.scrollerRelated.Scroller;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import json.JsonData;
	import json.JsonDecoder;
	
	public class HomePage extends Page
	{
		
		private var advertiseContainer:SY_Scroller = new SY_Scroller(1200,250,1200,250);
		private var lifeStyleContainer:SY_Scroller = new SY_Scroller(1200,250,1200,250,0xffffff,0,false);
		private var spaceContainer:SY_Scroller = new SY_Scroller(1200,250,1200,250);
		
		private var functionBar:Sprite = new Sprite();
		
		private var video:VideoContainer = new VideoContainer();
		
		private var webview:StageWebView = new StageWebView();
		
		private var imageViewer:ImageViewer;
		
		private var downloadpage:DownloadPage = new DownloadPage();
		public function HomePage()
		{
			loadData();
			
			addChild(advertiseContainer);
					
			lifeStyleContainer.y = 300;
			addChild(lifeStyleContainer);
			
			spaceContainer.y = 600;
			addChild(spaceContainer);
			
			functionBar.y = 800;
			addChild(functionBar);
			
			downloadpage.visible = false;
			downloadpage.x = 300;
			downloadpage.y = 225;
			addChild(downloadpage);
			
			video.addEventListener(Event.COMPLETE,function(e:Event):void{
				removeChild(video);
			});
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
			Common.loadURL("furniture/action/davert/iosAdvert",handleAdvertise,null);
			Common.loadURL("furniture/action/lifeway/iosLifewayBefore",handleLifewayBefore,null);
		}
		
		private function handleAdvertise(e:Event):void{
			var data:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			//trace(e.currentTarget.data);
			if(data.success){
				var urlList:Array = new Array();
				var dataList:Array = data.dataValue.datavalue as Array;
				
				for each(var obj:Object in dataList){
					urlList.push(Common.url+"furniture/images/"+obj.ad_logo+".jpg");
				}
				
				advertiseContainer.dataSource(urlList,200,0,onAdvertiseClick);
				
				var index:int = 0;
				for each(var img:Image in advertiseContainer.scroller.btnArr){
					img.info = dataList[index];
					index++;
				}
				
			}
		}
		
		private function handleLifewayBefore(e:Event):void{
			var data:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			if(data.success){
				var urlList:Array = new Array();
				var dataList:Array = data.dataValue.datavalue as Array;
				
				for each(var obj:Object in dataList){
					urlList.push(Common.url+"furniture/images/"+obj.li_logo+".jpg");
				}
				
				lifeStyleContainer.dataSource(urlList,400,30,null);
				
				var index:int = 0;
				for each(var img:Image in lifeStyleContainer.scroller.btnArr){
					img.info = dataList[index];
					if(!new File(File.applicationDirectory.nativePath+"/data/img/"+img.info.li_No).exists){
						img.addEventListener(MouseEvent.CLICK,onLoadClick);
						var filter:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.6,0,0,0,0.3,0.6,0,0,0,0.3,0.6,0,0,0,0,0,0,1,0]) ;
						img.filters = [filter];
					}else{
						img.addEventListener(MouseEvent.CLICK,onLifeWayClick);
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
				downloadpage.visible = true;
				downloadpage.showData(data.dataValue);
			}
		}
		
		//点击普通状态生活方式
		private function onLifeWayClick(e:MouseEvent):void{
			var img:Image = e.currentTarget as Image;
			
		}
		
		
		//点击广告
		private function onAdvertiseClick(e:MouseEvent):void{
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














