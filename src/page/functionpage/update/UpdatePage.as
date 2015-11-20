package page.functionpage.update
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	import com.shangyi.component.scrollerRelated.Scroller;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filters.ColorMatrixFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import json.JsonData;
	import json.JsonDecoder;
	
	import page.alertpage.Alert;
	import page.alertpage.Confirm;
	import page.homepages.HomePage;
	
	import user.UserInfo;
	
	public class UpdatePage extends Page
	{
		
		private var scroller:Scroller = new Scroller(Common.MAX_WIDTH,Common.MAX_HEIGHT*3/4);
		private var quanxuanBtn:Image = new Image("data/img/quanxuan.png");
		private var shanchuBtn:Image = new Image("data/img/shanchu.png");
		public function UpdatePage()
		{
			drawBack(Common.MAX_WIDTH,Common.MAX_HEIGHT-80);
			addChild(scroller);
			shanchuBtn.x = 300;
			shanchuBtn.y = 740;
			quanxuanBtn.x = 700;
			quanxuanBtn.y = 740;
			quanxuanBtn.width = shanchuBtn.width = 170;
			quanxuanBtn.height = shanchuBtn.height = 45;
			addChild(quanxuanBtn);
			addChild(shanchuBtn);
			Common.loadURL("furniture/action/lifeway/iosLifewayBefore",handleLifewayBefore,null);
			
			shanchuBtn.addEventListener(MouseEvent.CLICK,onItendDelete);
			shanchuBtn.addEventListener(Confirm.YES,onShanchu);
			
			quanxuanBtn.addEventListener(MouseEvent.CLICK,onQuanxuan);
			
		}
		private function onItendDelete(e:MouseEvent):void{
			var flag:Boolean = false;
			for each(var u:UpdateSpace in scroller.btnArr){
				if(u.checkBox.selected){
					flag = true;
					break;
				}
			}
			
			if(flag){
				Confirm.confirm("确认删除",shanchuBtn);
			}else{
				Alert.alert("请选择需删除项");
			}
			
		}
		private function onShanchu(e:Event):void{

			for each(var u:UpdateSpace in scroller.btnArr){
				if(u.checkBox.selected){
					var liName:String = u.dataObj.datavalue[0].li_no;
					var file:File = new File(Common.dataDir.resolvePath("data/img/" + liName).nativePath);
					if(file.exists){
						
						
						if(UserInfo.diyDataLoaded.indexOf(liName) != -1){
							UserInfo.diyDataLoaded.splice(UserInfo.diyDataLoaded.indexOf(liName),1);
							UserInfo.userData.data.diyDataLoaded = UserInfo.diyDataLoaded;
							delete UserInfo.updateTimeDic[liName];
							UserInfo.userData.data.updateTimeDic = UserInfo.updateTimeDic;
							UserInfo.userData.flush();
							
						}			
						file.deleteDirectory(true);
					}
				}
			}
			HomePage.homeRoot.onDataReady(null);
			reFresh();
		}
		
		public function reFresh():void{
			scroller.clearContent();
			Common.loadURL("furniture/action/lifeway/iosLifewayBefore",handleLifewayBefore,null);
			Alert.alert("删除成功");
		}
		
		private function onQuanxuan(e:MouseEvent):void{
			for each(var u:UpdateSpace in scroller.btnArr){
				u.checkBox.selected = true;
			}
		}
		
		private function handleUpdate(e:Event):void{
			var data:JsonData = JsonDecoder.decoderToJsonData(e.currentTarget.data);
			if(data.success){
				var dataList:Array = data.dataValue as Array;
				for each(var obj:Object in dataList){	
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
						var o:Object = {"ui_li_no":obj.li_No,"ui_time":Number(UserInfo.updateTimeDic[obj.li_No])/1000};//-3600*24*15};
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
						update.y = index*150;
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









