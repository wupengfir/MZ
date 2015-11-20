package page.functionpage.update
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.buttonRelated.SimpleButton;
	import com.shangyi.component.imageRelated.Image;
	
	import fl.controls.CheckBox;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import json.JsonData;
	import json.JsonDecoder;
	
	import newfunction.BigFileDownload;
	import newfunction.UnZip;
	
	import page.alertpage.Alert;
	import page.alertpage.Confirm;
	import page.functionpage.FunctionPage;
	import page.homepages.DownloadPage;
	import page.homepages.HomePage;
	
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
		public var labelProgress:Label = new Label("",20);
		public var dataObj:Object;
		private var progressDic:Dictionary;
		private var completeDic:Dictionary;
		private var ps:XML = 
			<root>
				<object name="checkBox" x="10" y="40"/>
				<object name="image" x="50" y="10"/>
				<object name="nameLabel" x="180" y="20"/>
				<object name="descLabel" x="360" y="20"/>
				<object name="labelProgress" x="850" y="40"/>	
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
			nameLabel.width = 130;
			descLabel.width = 440;
			descLabel.height = 100;
			deleteButton.buttonMode = true;
			button.addEventListener(MouseEvent.CLICK,onUpdateClick);
			deleteButton.addEventListener(MouseEvent.CLICK,onItendDelete);
			deleteButton.addEventListener(Confirm.YES,onDelete);
			Common.loadURL("furniture/action/lifeway/iosLifewayEject?lifeNo="+data.li_id,handleLifewayData,null);
		}
		
		private function onItendDelete(e:MouseEvent):void{
			Confirm.confirm("确认删除",deleteButton);
		}
		
		private function onDelete(e:Event):void{
			var liName:String = dataObj.datavalue[0].li_no;
			var file:File = new File(Common.dataDir.resolvePath("data/img/" + liName).nativePath);
			if(file.exists){
				
				
				if(UserInfo.diyDataLoaded.indexOf(liName) != -1){
					var a:Array = UserInfo.diyDataLoaded;
					var b:Object = UserInfo.updateTimeDic;
					UserInfo.diyDataLoaded.splice(UserInfo.diyDataLoaded.indexOf(liName),1);
					UserInfo.userData.data.diyDataLoaded = UserInfo.diyDataLoaded;
//					delete UserInfo.updateTimeDic[liName];
//					UserInfo.userData.data.updateTimeDic = UserInfo.updateTimeDic;
//					return;
					UserInfo.userData.flush();
					HomePage.homeRoot.onDataReady(null);
					FunctionPage.updatepage.reFresh();
				}
				file.deleteDirectory(true);
				Alert.alert("删除成功");
			}
		}
		
		private function onUpdateClick(e:MouseEvent):void{
			if(updateAble){
				Common.loadURL("furniture/action/lifeway/iosLifewayUpdate?JSESSIONID="+UserInfo.sessionID+"&lifeNo="+dataObj.datavalue[0].li_no+"&lastRefreshTime="+(Number(UserInfo.updateTimeDic[dataObj.datavalue[0].li_no])/1000).toString(),handleUpdate,null);
			}
		}
		private var totalSize:Number;
		private var downloadList:Array;
		private var dataGot:Boolean = false;
		private function handleUpdate(e:Event):void{
			if(dataGot){
				return;
			}else{
				dataGot = true;
			}
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
		private var liNo:String;
		public var currentIndex:int = 0;
		public var completeNum:int = 0;
		private var loading:Boolean = false;
		private var currentPath:String;
		private function unZip():void{
			labelProgress.text = "文件解压中";
			button.removeEventListener(MouseEvent.CLICK,onUpdateClick);
			button.label = "已完成";
			unzipByIndex(currentIndex);
			
		}
		
		
		private function unzipByIndex(index:int):void{
			if(index<downloadList.length){
				var obj:Object = downloadList[index];
				try{
					var zip:UnZip = new UnZip(Common.dataDir.resolvePath(currentPath + obj.ui_name).nativePath);
				}catch(e:Error){
					labelProgress.text = "解压失败";
					return;
				}
				
				currentIndex++;
				zip.addEventListener(Event.COMPLETE,function(e:Event):void{
					completeNum++;
					labelProgress.text = "文件解压中:"+completeNum+"/"+downloadList.length;
					unzipByIndex(currentIndex);					
				});
				
			}else{			
					UserInfo.updateTimeDic[liNo] = new Date().getTime().toString();
					UserInfo.userData.data.updateTimeDic = UserInfo.updateTimeDic;
					UserInfo.userData.flush();
					labelProgress.text = "解压完成";
					dispatchEvent(new Event(DownloadPage.DATA_READY));
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













