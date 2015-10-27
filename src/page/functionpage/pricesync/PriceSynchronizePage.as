package page.functionpage.pricesync
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
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
			
			synchronize();
		}
		
		private function onClick(e:MouseEvent):void{
			Common.MAIN.loading = true;
			var array:Array = new Array();
			for each(var s:String in UserInfo.diyDataLoaded){
				if(s==null||s==""){
					continue;
				}
				var json:Object = {"li_no":s};
				array.push(json);
			}
			Common.loadURL("furniture/action/product/iosPriceSynchro?JSESSIONID="+UserInfo.sessionID+"&lifeNoJson="+JSON.stringify(array),handleSync,null);

		}
		
		public function synchronize():void{
			
			image.y = 200;
			TweenLite.to(image,.5,{y:0});
			
		}
		
		var total:int = 0;
		private function handleSync(e:Event):void{
			Common.MAIN.loading = false;
			var data:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			trace(e.currentTarget.data);
			if(data.success){
				for each(var obj:Object in data.dataValue.lifewayData){
					total++;
					var dl:BigFileDownload = new BigFileDownload("data/img/"+obj.li_no+"/"+obj.ui_name,Common.url+"furniture/data/"+obj.li_no+"/"+obj.ui_name);
					dl.info = "data/img/"+obj.li_no+"/"+obj.ui_name;
					dl.addEventListener(Event.COMPLETE,onComplete);		
				}
			}
		}
		
		private function onComplete(e:Event):void{
			var zip:UnZip = new UnZip(File.applicationDirectory.resolvePath(e.target.info).nativePath);			
			zip.addEventListener(Event.COMPLETE,function(e:Event):void{
				total--;
				if(total == 0){
					FunctionPage.syncpage.visible = false;
					Alert.alert("更新完成");
				}
			});
			
		}
		
	}
}












