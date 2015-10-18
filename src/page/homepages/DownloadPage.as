package page.homepages
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.buttonRelated.Button;
	import com.shangyi.component.imageRelated.Image;
	import com.shangyi.component.scrollerRelated.SY_Scroller;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import json.JsonData;
	import json.JsonDecoder;
	
	import newfunction.BigFileDownload;
	import newfunction.UnZip;
	
	import user.UserInfo;
	
	public class DownloadPage extends Page
	{
		
		public var labelName:Label = new Label("",20);
		public var imageLogo:Image = new Image();
		public var labelNeirong:Label = new Label("",20);
		public var labelNeirongText:Label = new Label("",20);
		public var scroller:SY_Scroller = new SY_Scroller(580,200,570,200,0xffffff,0,false);		
		public var btnDownload:Image = new Image("data/img/xiazaianniu.png");
		public var labelProgress:Label = new Label("",20);
		
		private var totalSize:Number;
		private var downloadList:Array;
		private var dataObj:Object;
		private var progressDic:Dictionary;
		private var completeDic:Dictionary;
		private var currentPath:String;
		private var loading:Boolean = false;
		private var liNo:String;
		public var currentIndex:int = 0;
		public var completeNum:int = 0;
		private var ps:XML = 
			<root>
				<object name="labelName" x="230" y="20"/>
				<object name="labelProgress" x="300" y="110"/>
				<object name="imageLogo" x="20" y="20"/>
				<object name="btnDownload" x="230" y="100"/>
				<object name="scroller" x="10" y="150"/>	
				<object name="labelNeirong" x="10" y="350"/>
				<object name="labelNeirongText" x="10" y="380"/>
			</root>
//<root>
//<object name="labelName" x="200" y="20"/>
//<object name="imageLogo" x="20" y="20"/>
//<object name="scroller" x="10" y="300"/>	
//<object name="labelNeirong" x="50" y="500/>
//<object name="labelNeirongText" x="50" y="530"/>
//</root>
		public function DownloadPage()
		{
			initByPageScript(ps);		
			
			drawBack(600,550,0x00ffff);
			
			btnDownload.width = 50;
			btnDownload.height = 50;
			imageLogo.width = 180;
			imageLogo.height = 100;
			labelNeirongText.width = 600;
			labelNeirongText.height = 100;
			labelProgress.width = 300;
			labelNeirongText.textField.wordWrap = true;
			
			btnDownload.addEventListener(MouseEvent.CLICK,onDownloadClick);
		}
		
		private function onDownloadClick(e:MouseEvent):void{
			if(loading){
				return;
			}
			//trace("furniture/action/lifeway/iosLifewayDownload?JSESSIONID="+UserInfo.sessionID+"&lifeNo="+dataObj.datavalue[0].li_no);
			Common.loadURL("furniture/action/lifeway/iosLifewayDownload?JSESSIONID="+UserInfo.sessionID+"&lifeNo="+dataObj.datavalue[0].li_no,handleDownload,null);
		}
		
		private function handleDownload(e:Event):void{
			var data:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			trace(e.currentTarget.data);
			if(data.success){	
				progressDic = new Dictionary();
				completeDic = new Dictionary();
				downloadList = data.dataValue.lifewayData;
				totalSize = data.dataValue.filesize;
				
				
				
				for each(var o:Object in downloadList){
					var dl:BigFileDownload = new BigFileDownload("data/img/"+o.li_no+"/"+o.ui_name,Common.url+"furniture/data/"+o.li_no+"/"+o.ui_name);
					dl.addEventListener(ProgressEvent.PROGRESS,onProgress);
					dl.addEventListener(Event.COMPLETE,onComplete);					
					liNo = o.li_no;
					progressDic[dl] = 0;
					completeDic[dl] = 0;
					currentPath = "data/img/"+o.li_no+"/";
					loading = true;
				}
				//unzipByIndex(0);
			}
		}
		
		private function onComplete(e:Event):void{
			completeDic[e.currentTarget] = 1;
			
			var flag:Boolean = true;
			
			for each(var n:Number in completeDic){
				if(n == 0){
					flag = false;
					break;
				}
			}
			
			if(flag){
				unZip();
				loading = false;
			}
			
		}
		
		private function unZip():void{
			labelProgress.text = "文件解压中";
			removeChild(btnDownload);
			
			unzipByIndex(currentIndex);
			
		}
		
		private function unzipByIndex(index:int):void{
			if(index<downloadList.length){
				var obj:Object = downloadList[index];
				var zip:UnZip = new UnZip(File.applicationDirectory.resolvePath(currentPath + obj.ui_name).nativePath);
//				zip.addEventListener(ProgressEvent.PROGRESS,function(e:ProgressEvent):void{
//					labelProgress.text = "文件解压中"+e.currentTarget.progress;
//				});
				currentIndex++;
				zip.addEventListener(Event.COMPLETE,function(e:Event):void{
					unzipByIndex(currentIndex);
					completeNum++;
					labelProgress.text = "文件解压中:"+completeNum+"/"+downloadList.length;
				});
				
			}else{
				if(UserInfo.diyDataLoaded.indexOf(liNo) == -1){
					UserInfo.diyDataLoaded.push(liNo);
					UserInfo.userData.data.diyDataLoaded = UserInfo.diyDataLoaded;
					UserInfo.userData.flush();
				}
			}
			
		}
		
		
		
		private function onProgress(event:ProgressEvent):void{
			
			
			progressDic[event.currentTarget] = (event.currentTarget as BigFileDownload).endpos;
			
			var loadedTotal:Number = 0;
			for each(var n:Number in progressDic){
				loadedTotal += n;
			}
			
			labelProgress.text = ((loadedTotal/totalSize)*100).toFixed(2)+"%已下载";
			
		}
		
		public function showData(data:Object):void{
			this.dataObj = data;
			imageLogo.source = Common.getImageUrljpg(data.datavalue[0].li_logo);
			labelName.text = data.datavalue[0].li_name;
			labelNeirong.text = "内容提要";
			labelNeirongText.text = data.datavalue[0].li_explain;
			
			var urlList:Array = new Array();
			var dataList:Array = data.datavalue[0].image as Array;
			
			for each(var obj:Object in dataList){
				urlList.push(Common.url+"furniture/images/"+obj.i_name+".jpg");
			}
			
			scroller.dataSource(urlList,300,30,null);
			
		}
	}
		
	}	




















