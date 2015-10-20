package page.functionpage.update
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	import com.shangyi.component.scrollerRelated.Scroller;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import json.JsonData;
	import json.JsonDecoder;
	
	import user.UserInfo;
	
	public class UpdatePage extends Page
	{
		
		private var scroller:Scroller = new Scroller(Common.MAX_WIDTH,Common.MAX_HEIGHT*3/4);
		
		public function UpdatePage()
		{
			drawBack(Common.MAX_WIDTH,Common.MAX_HEIGHT-80);
			addChild(scroller);
			Common.loadURL("furniture/action/lifeway/iosLifewayBefore",handleLifewayBefore,null);
		}
		
		private function handleUpdate(e:Event):void{
			var data:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			if(data.success){
				var dataList:Array = data.dataValue as Array;
				for each(var obj:Object in dataList){	
					trace("!!!!!!!!!!!!!!");
					var update:UpdateSpace = getUpdateSpace(obj.li_no);
					if(update){
						if(obj.hasUpdate == 1){
							update.button.label = "已完成";
						}else{
							update.button.label = "更新";
							update.updateAble = true;
						}
					}
				}
			}
		}
		
		private function getUpdateSpace(n:String):UpdateSpace{
			
			var up:UpdateSpace = null;
			for each(var u:UpdateSpace in scroller.btnArr){
				if(u.dataObj.datavalue[0].li_no == n){
					up = u;
					break;
				}
			}
			return up;
		}
		
		//已获取数据的updatespace数
		private var loadedNum:int = 0;
		private var totalload:int = 0;
		private function intendupdate(e:Event):void{
			loadedNum++;
			if(loadedNum == totalload){
				var array:Array = new Array();
				for each(var obj:Object in dl){
					if(UserInfo.diyDataLoaded.indexOf(obj.li_No) != -1){
						var o:Object = {"ui_li_no":obj.li_No,"ui_time":Number(UserInfo.updateTimeDic[obj.li_No])/1000};
						array.push(o);
					}
					
					
				}
				Common.loadURL("furniture/action/lifeway/iosLifewayUpdatePrompt?JSESSIONID="+UserInfo.sessionID+"&lifewayJson="+JSON.stringify(array),handleUpdate,null);

			}			
		}
		private var dl:Array;
		private function handleLifewayBefore(e:Event):void{
			var data:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			if(data.success){
				var urlList:Array = new Array();
				var dataList:Array = data.dataValue.datavalue as Array;
				dl = dataList;
				var array:Array = new Array();
				var index:int = 0;
				for each(var obj:Object in dataList){
					if(UserInfo.diyDataLoaded.indexOf(obj.li_No) != -1){
						var update:UpdateSpace = new UpdateSpace(obj);
						update.addEventListener(UpdateSpace.GOT_DATA,intendupdate);
						totalload++;
						update.y = index*120;
						scroller.addChild(update);
						index++;
//						var o:Object = {"ui_li_no":obj.li_No,"ui_time":Number(UserInfo.updateTimeDic[obj.li_No])/1000};
//						array.push(o);
					}
					
					
				}
				//Common.loadURL("furniture/action/lifeway/iosLifewayUpdatePrompt?JSESSIONID="+UserInfo.sessionID+"&lifewayJson="+JSON.stringify(array),handleUpdate,null);
			}
		}
		
	}
}









