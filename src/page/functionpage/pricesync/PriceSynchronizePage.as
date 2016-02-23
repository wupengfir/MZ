package page.functionpage.pricesync
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import json.JsonData;
	import json.JsonDecoder;
	
	import newfunction.BigFileDownload;
	import newfunction.UnZip;
	
	import page.alertpage.Alert;
	import page.functionpage.FunctionPage;
	
	import user.UserInfo;
	
	public class PriceSynchronizePage extends Page
	{
		private var image:Image = new Image("data/img/qianqiantongbu.png");
		public function PriceSynchronizePage()
		{
			addChild(image);
			
			image.addEventListener(MouseEvent.CLICK,onClick);
			addEventListener(MouseEvent.CLICK,onBackClick);
			synchronize();
		}
		
		private function onBackClick(e:MouseEvent):void{
			if(e.target != image)visible = false;
		}
		
		private function onClick(e:MouseEvent):void{
			Common.MAIN.loading = true;
			var array:Array = new Array();
			var names:String = "";
			var index:int = 1;
			for each(var s:String in UserInfo.diyDataLoaded){
				if(s==null||s==""){
					continue;
				}
				if(names != ""){
					names +=",";
				}			
				var json:Object = {"li_no":s};
				array.push(json);
				names += s;
				
			}
			
			
			Common.loadSyncURL("ProductsService.svc/GetProduct?DealerID="+UserInfo.userName+"&Styles="+names,handleSync,null);
			//Common.loadURL("furniture/action/product/iosPriceSynchro?JSESSIONID="+UserInfo.sessionID+"&lifeNoJson="+JSON.stringify(array),handleSync,null);

		}
		
		public function synchronize():void{
			
			image.y = 200;
			TweenLite.to(image,.5,{y:0});
			
		}
		
		var total:int = 0;
		private function handleSync(e:Event):void{
			Common.MAIN.loading = false;
			trace(e.currentTarget.data);
			var jd:String = e.currentTarget.data//"{\"data\":[{\"address\":\"http:\/\/mzlive.zsmz.com:8080\/furniture\/data\/mzcj\/mzcj_CID002.plist\",\"fengge\":\"mzcj\"}],\"message\":null,\"success\":\"0\"}"//new XML(e.currentTarget.data).text().toString();
			trace(jd);
			var data:JsonData = JsonDecoder.decoderPriceSyncToJsonData(jd);
			
			if(data.success){
				for each(var obj:Object in data.dataValue){
					total++;
//					var dl:BigFileDownload = new BigFileDownload("data/img/"+obj.li_no+"/"+obj.ui_name,Common.url+"furniture/data/"+obj.li_no+"/"+obj.ui_name);
//					dl.info = "data/img/"+obj.li_no+"/"+obj.ui_name;
					var filename:String = (obj.address as String).split("/").pop();
					var dl:BigFileDownload = new BigFileDownload("data/img/"+obj.fengge+"/"+filename,obj.address+"?data="+(new Date().time.toString()));
					dl.info = "data/img/"+obj.fengge+"/"+filename;
					dl.addEventListener(Event.COMPLETE,onComplete);		
				}
			}
		}
		
		private function onComplete(e:Event):void{
			total--;
			
			var p:String = e.target.nPath;
			var f:File = new File(p);
			var fs:FileStream = new FileStream();
			fs.open(f,FileMode.READ);
			var data:String = fs.readMultiByte(fs.bytesAvailable,"gb2312");
			fs.close();
			fs.open(f,FileMode.WRITE);
			fs.writeMultiByte(data,"utf-8");
			fs.close();
			if(total == 0){
				FunctionPage.syncpage.visible = false;
				Alert.alert("更新完成");
			}
//			var zip:UnZip = new UnZip(Common.dataDir.resolvePath(e.target.info).nativePath);			
//			zip.addEventListener(Event.COMPLETE,function(e:Event):void{
//				total--;
//				if(total == 0){
//					FunctionPage.syncpage.visible = false;
//					Alert.alert("更新完成");
//				}
//			});
			
		}
		
	}
}












