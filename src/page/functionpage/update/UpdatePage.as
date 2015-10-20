package page.functionpage.update
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	import com.shangyi.component.scrollerRelated.Scroller;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
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
			trace(e.currentTarget.data);
		}
		
		private function handleLifewayBefore(e:Event):void{
			var data:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			if(data.success){
				var urlList:Array = new Array();
				var dataList:Array = data.dataValue.datavalue as Array;
				var array:Array = new Array();
				var index:int = 0;
				for each(var obj:Object in dataList){
					if(UserInfo.diyDataLoaded.indexOf(obj.li_No) != -1){
						var update:UpdateSpace = new UpdateSpace(obj);
						update.y = index*120;
						scroller.addChild(update);
						index++;
						var o:Object = {"ui_li_no":obj.li_No,"ui_time":UserInfo.updateTimeDic[obj.li_No]}
						array.push(o);
					}
					
					
				}
				Common.loadURL("furniture/action/lifeway/iosLifewayUpdatePrompt?JSESSIONID="+UserInfo.sessionID+"&lifewayJson="+JSON.stringify(array),handleUpdate,null);
			}
		}
		
	}
}









