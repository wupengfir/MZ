package page.room
{
	import com.as3xls.xls.ExcelFile;
	import com.greensock.TweenLite;
	import com.shangyi.component.base.Page;
	import com.shangyi.component.buttonRelated.Button;
	import com.shangyi.component.buttonRelated.ImageButton;
	import com.shangyi.component.buttonRelated.SimpleButton;
	import com.shangyi.component.imageRelated.Image;
	import com.shangyi.component.scrollerRelated.SY_Scroller;
	import com.shangyi.component.scrollerRelated.ScrollableSprite;
	import com.shangyi.component.scrollerRelated.Scroller;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.CameraRoll;
	import flash.net.FileReference;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import user.UserConfig;

	
	public class RoomPage extends Page
	{
		public static var products:Dictionary = new Dictionary();
		public static const CHANGE:String = "change";
		public static var MAIN:RoomPage;
		public static const scx:Number = Common.MAX_WIDTH/1024;
		public static const scy:Number = Common.MAX_HEIGHT/768;
		//		public static var DownBar:DownBarPage;
		//logo
		public static var logo:Image = new Image();
		//样板间路径
		private var path:String;
		//相对路径
		private var path_1:String;
		
		//可点击图片容器,也用于保存图片
		public var selectableImageContainer:Sprite;
		//不变层
		private var buttomImg:Image = new Image();
		
		private var btnScroller:Scroller = new Scroller(190*Common.MAX_WIDTH/1024,180*Common.MAX_HEIGHT/768,1);
		
		private var right:Sprite = new Sprite();
		private var buttom:Sprite = new Sprite();
		private var up:Sprite = new Sprite();
		
		private var rightScroller:SY_Scroller = new SY_Scroller(170*Common.MAX_WIDTH/1024,530*Common.MAX_HEIGHT/768,135*Common.MAX_WIDTH/1024,445*Common.MAX_HEIGHT/768,0xffffff,1);
		public var rightBtn:Button = new Button(80,30,860,15);
		
		
		//首选产品的xml
		private var data:XML;
		//当前样板间存在的产品
		private var existProducts:Array = new Array();
		private var initInfo:Dictionary;
		
		private var back:Image = new Image("data/img/roompic/back.png",true);
		private var closeHotPoint:Image = new Image("data/img/roompic/hotpoint.png",true);
		private var selectColorBtn:Image = new Image("data/img/roompic/color.png",true);
		private var selectKongjianBtn:Image = new Image("data/img/roompic/kongjian.png",true);
		private var pingmianBtn:Image = new Image("data/img/roompic/pingmian.png",true);
		private var pingleiBtn:Image = new Image("data/img/roompic/pinglei.png",true);
		private var pingleiMask:Sprite = new Sprite();
		private var downSelect:Image = new Image("data/img/roompic/downselect.jpg",true);
		private var saveBtn:Image = new Image("data/img/roompic/save.png",true);
		private var downBack:Sprite = new Sprite();
		
		private var biaojiBtn:Image = new Image();
		private var jiajuBtn:Button = new Button(115,30,0,0);
		private var shipinBtn:Button = new Button(115,30,115,0);
		private var jiancaiBtn:Button = new Button(115,30,115,0);
		private var qiangmianBtn:Button = new Button(115,30,230,0);
		private var dimianBtn:Button = new Button(115,30,345,0);
		private var downBtn:Button = new Button(80,40,200,-15);
		private var kongjian:String;
		private var yindex:Number = 675;
		private var biaojiLabel:Label = new Label("产品暂无存货");
		private var quxiaobiaojiLabel:Label = new Label("产品已有存货");
		private var addtoorderLabel:Label = new Label("已加入订单");
		private var xiadanBtn:Image = new Image("data/img/roompic/xiadan.png",true);
		private var qingdanBtn:Image = new Image("data/img/roompic/qingdan.png",true);
		
		private var roomVideoData:Dictionary;
		private var roomData:Array;
		private var roomDefaultData:Dictionary;
		private var imgCountDic:Dictionary = new Dictionary();
		private var imgCurrentCountDic:Dictionary = new Dictionary();
		private var backtoVideo:Boolean;
		
		private var hotPointLayer:Sprite = new Sprite();
		public function RoomPage(roomName:String,initInfo:Dictionary = null,backtoVideo:Boolean = true)
		{
			backImage.scaleMax();
			this.backtoVideo = backtoVideo;
			getVideo(Common.currentRoomData[Common.currentPath+"_video"],roomName);
			roomData = Common.currentRoomData[roomName+"_data"];
			roomDefaultData = Common.currentRoomData[roomName+"_default"];
			this.alpha = 0;
			TweenLite.to(this,.7,{alpha:1,onComplete:function():void{
				NoticePage.notice.show();
			}});
			MAIN = this;	
			this.path = File.applicationDirectory.resolvePath("data/img/"+Common.currentPath+"/"+Common.currentColor).nativePath;
			path_1 = path;
			kongjian = roomName;
			selectableImageContainer = new Sprite();
			this.graphics.beginFill(0xffffff,1);
			this.graphics.drawRect(0,0,Common.MAX_WIDTH,Common.MAX_HEIGHT);
			this.graphics.endFill();
			addChild(selectableImageContainer);	
			addChild(hotPointLayer);
			//selectableImageContainer.addChild(buttomImg);
			backImage.source = Common.getBigImagePath(Common.currentPath+"_"+kongjian+"_solid.png");
			right.addChild(new Image("data/img/roompic/cebian.png",false,0,Common.MAX_HEIGHT,true));
			rightScroller.graphics.clear();
//			loadXml();
			back.x = back.y = 20*Common.MAX_HEIGHT/768;
			addChild(back);
			back.addEventListener(MouseEvent.CLICK,onBack);
			this.initInfo = initInfo;
			
			addChild(selectColorBtn);
			selectColorBtn.x = 100*Common.MAX_HEIGHT/768;
			selectColorBtn.y = 20*Common.MAX_HEIGHT/768;
			selectColorBtn.visible = (roomVideoData["shuangse"] == "1");//new File(path.replace("shense","qianse")).exists;
			selectColorBtn.addEventListener(MouseEvent.CLICK,changeRoomColor);
			
			addChild(closeHotPoint);
			closeHotPoint.x = 20*Common.MAX_HEIGHT/768;
			closeHotPoint.y = yindex*Common.MAX_HEIGHT/768;
			closeHotPoint.addEventListener(MouseEvent.CLICK,closePoints);
			
			addChild(selectKongjianBtn);
			selectKongjianBtn.x = 100*Common.MAX_HEIGHT/768;
			selectKongjianBtn.y = yindex*Common.MAX_HEIGHT/768;
			selectKongjianBtn.addEventListener(MouseEvent.CLICK,showKongjian);
			
			addChild(pingmianBtn);
			pingmianBtn.x = 180*Common.MAX_HEIGHT/768;
			pingmianBtn.y = 20*Common.MAX_HEIGHT/768;
			pingmianBtn.visible = (roomVideoData["pingmian"] == "1");
			pingmianBtn.addEventListener(MouseEvent.CLICK,addpingmian);
			
			addChild(pingleiBtn);
			pingleiBtn.x = 180*Common.MAX_HEIGHT/768;
			pingleiBtn.y = yindex*Common.MAX_HEIGHT/768;
			pingleiBtn.addEventListener(MouseEvent.CLICK,showpinglei);
			
			addChild(xiadanBtn);
			xiadanBtn.x = 954*Common.MAX_HEIGHT/768;
			xiadanBtn.y = yindex*Common.MAX_HEIGHT/768;
			xiadanBtn.addEventListener(MouseEvent.CLICK,xiadan);
			
			addChild(qingdanBtn);
			qingdanBtn.x = 874*Common.MAX_HEIGHT/768;
			qingdanBtn.y = yindex*Common.MAX_HEIGHT/768;
			qingdanBtn.addEventListener(MouseEvent.CLICK,showqingdan);
			
			loadXml();
		}
		
		private function getVideo(dic:Dictionary,s:String):void{
			if(dic["name"] == s){
				roomVideoData = dic;
				return;
			}
			if(dic["video"] != null){
				for each(var d:Dictionary in dic["video"]){
					getVideo(d,s);
				}
			}
		}
		
		private function getBigImagePath(fileName:String):String{
			return Common.getBigImagePath(Common.currentPath+"_"+kongjian+"_bigImg_"+fileName+".png");
		}
		
		private function getThumbImagePath(fileName:String):String{
			return Common.getThumbImagePath(Common.currentPath+"_"+kongjian+"_thumb_"+fileName+".jpg");
		}
		
		private function getZoomImagePath(fileName:String):String{
			return Common.getZoomImagePath(Common.currentPath+"_"+kongjian+"_zoomout_"+fileName+".png");
		}
		
		private function getStoryPath(fileName:String):String{
			return Common.getZoomImagePath(Common.currentPath+"_"+kongjian+"_"+fileName+".png");
		}
		
		private function getVideoPath(fileName:String):String{
			return Common.getZoomImagePath(Common.currentPath+"_"+kongjian+"_"+fileName+".flv");
		}
		
		private var orderImageForSave:BitmapData;
		private function showqingdan(e:MouseEvent):void{
//			addChild(saveContainer);
//			saveContainer.visible = true;
//			saveState.visible = true;
//			
//			productInfoScroller.clearContent();
//			var i:int = 0;
//			for(var key:String in orderInfoDic){
//				var array:Array = sharedObject.data.array;
//				var list:Dictionary = orderInfoDic[key];
//				var label:Label = new Label(Main.yangbanjianNameInfo.yangbanjian.(@id == key.split("_")[1])[0].attribute("name").toString());
//				label.size = 20;
//				label.y = i*50;
//				i++;
//				productInfoScroller.addChild(label);
//				for(var innerKey:String in list){
//					var xml1:XML = list[innerKey];
//					if(key == FenggeSelectPage.currentPath+"_"+kongjian){
//						var xml:XML = hotPointXmlDic[innerKey];
//						var soldOut:Boolean = false;
//						if(!xml.hasOwnProperty("@relatedTo")){
//							var imagePath:String = path_1 + "zoomout/" + innerKey + "/" + getImageByName(innerKey).info.fileName;						
//							sharedObject = SharedObject.getLocal("product");
//							
//							if(array.indexOf(imagePath)==-1){
//								soldOut = false;
//								xml1.@soldout = "false";
//							}else{
//								soldOut = true;
//								xml1.@soldout = "true";
//							}
//						}else{
//							var imagePath:String = path_1 + "zoomout/" + innerKey + "/" + getImageByName(xml.attribute("relatedTo").toString()).info.fileName;						
//							sharedObject = SharedObject.getLocal("product");
//							if(array.indexOf(imagePath)==-1){
//								soldOut = false;
//								xml1.@soldout = "false";
//							}else{
//								soldOut = true;
//								xml1.@soldout = "true";
//							}
//						}
//					}else{
//						if(xml1.hasOwnProperty("@soldout")){
//							soldOut = xml1.attribute("soldout").toString() == "true";
//						}else{
//							soldOut = false;
//						}
//					}					
//					var info:ProductInfo = new ProductInfo(xml1,innerKey,soldOut);
//					info.addEventListener("deleted",function(e:Event){
//						var pi:ProductInfo = e.currentTarget as ProductInfo;
//						delete orderInfoDic[FenggeSelectPage.currentPath+"_"+kongjian][pi.type];
//						showqingdan(null);
//					});
//					info.y = i*50;
//					i++;
//					productInfoScroller.addChild(info);
//				}
//			}
//			setZongjia();
		}
		
		public static var orderInfoDic:Dictionary = new Dictionary();
		private var productInfoData:XML;
		private function xiadan(e:MouseEvent):void{
//			orderInfoDic[FenggeSelectPage.currentPath+"_"+kongjian] = new Dictionary();
//			for each(var p:pointMc in hotPointDic){
//				if(!p.visible)continue;
//				var img:Image = getImageByName(p.name);
//				if(img == null){
//					img = getImageByName(hotPointXmlDic[p.name].attribute("relatedTo").toString());
//				}
//				var idx:String = new File(img.sourceURL).name.split(".")[0];
//				var proData:XML = productInfoData.product.(@name == p.name).(@id == idx)[0];
//				orderInfoDic[FenggeSelectPage.currentPath+"_"+kongjian][p.name] = proData;
//			}
//			
//			saveData.draw(selectableImageContainer);
//			saveImage.bitmapData = saveData;saveImage.scaleX = saveImage.scaleY = 1;saveImage.x = saveImage.y = 0;
//			stage.addChild(saveImage);
//			TweenLite.to(saveImage,1,{x:xiadanBtn.x+20,y:xiadanBtn.y+20,scaleX:0,scaleY:0});
		}
		
		private var showed:Boolean = false;
		private function showpinglei(e:MouseEvent):void{
			if(!showed){
				TweenLite.to(downBack,1,{x:pingleiBtn.x+30});
				showed = true
			}else{
				TweenLite.to(downBack,1,{x:-200});
				showed = false
			}
		}
		
		private var kongjianContainer:Sprite;
		private var kongjianScroller:SY_Scroller = new SY_Scroller(Common.MAX_WIDTH,414,Common.MAX_WIDTH-100,385);
		private function showKongjian(e:MouseEvent):void{
			if(!kongjianContainer){
				kongjianContainer = new Sprite();
				kongjianContainer.graphics.beginFill(0,.6);
				kongjianContainer.graphics.drawRect(0,0,Common.MAX_WIDTH,Common.MAX_HEIGHT);
				kongjianContainer.graphics.endFill();
				kongjianScroller.y = 240;
				kongjianScroller.selectAble = false;
				kongjianContainer.addChild(kongjianScroller);
				kongjianScroller.setLeftArrowY(178);
				
				var file:Array = Common.currentRoomData["space"];
				var array:Array = new Array();
				var dataarray:Array = new Array();
				for each(var f:Dictionary in file){
					array.push(Common.getBigImagePath(Common.currentPath+"_"+f["name"]+".png"));
					dataarray.push(f);
				}
				var index:int = 0;
				
				kongjianScroller.dataSource(array,100,30,function(e:MouseEvent):void{
					//Main.currentColor = "shense";
					var img:ImageButton = e.currentTarget as ImageButton;
					var tp:String = img.info["name"];
					RoomPage.MAIN.remove();	
					Common.MAIN.roomLayer.addChild(new RoomPage(tp,null,RoomPage.MAIN.backtoVideo));
					
				});
				for each(var i:ImageButton in kongjianScroller.scroller.btnArr){
					i.info = dataarray[index];
					index++;
				}
				addChild(kongjianContainer);
				addChild(selectKongjianBtn);
			}else{
				kongjianContainer.visible = !kongjianContainer.visible;
			}					
		}
		
		
		
		private function initPage():void{
			selectableImageContainer.addEventListener(MouseEvent.CLICK,onImageClick);
//			var tempPath:String = path + "bigImg";
//			var dir:File = new File(path + "bigImg");
//			var dirs:Array = dir.getDirectoryListing();
//			for each(var f:File in dirs){
//				if(f.isDirectory){
//					existProducts.push(f.name);
//				}
//			}
			//createBtns();
			createImages();
			
			initRightScroller();
			createArrowBtn();
//			createSave();
			createKongjianBtn();
			createHotPoint();
		}
		
		private function addpingmian(e:MouseEvent):void{
//			var dic:Dictionary = new Dictionary();
//			for(var i:int = selectableImageContainer.numChildren-1;i>=0;i--){
//				var img:Image = selectableImageContainer.getChildAt(i) as Image;
//				try{
//					dic[img.info.name] = img.info.fileName;
//				}catch(e:Error){
//					continue;
//				}
//				
//			}
//			addChild(new PingmianPage(path.substr(0,path.length - 1) + "_pingmian/",dic));
		}
		
		public function changeItem(dic:Dictionary):void{
			for each(var xml:XML in data.image){
				var img:Image = getImageByName(xml.attribute("name").toString());
				img.source = path + "bigImg/" + xml.attribute("name").toString() + "/"+ dic[xml.attribute("name").toString()];
				img.info = {name:xml.attribute("name").toString(),fileName:dic[xml.attribute("name").toString()]};
			}
			var image:Image;
			var xml:XML;
			for (var j:int = 0; j < data.image.length(); j++) 
			{
				xml = data.image[j];
				if(xml.hasOwnProperty("@relatedTo")){
					if(xml.hasOwnProperty("@disappear")){
						var tempImage:Image = getImageByName(xml.attribute("relatedTo").toString());
						var names:Array = xml.attribute("disappear").toString().split(",");
						for each(var tempName:String in names){
							if(tempName == tempImage.info.fileName.split(".")[0]){
								image = getImageByName(xml.attribute("name").toString());
								image.visible = false;
							}else{
								image = getImageByName(xml.attribute("name").toString());
								image.visible = true;
							}
						}
					}
				}
				
			}
		}
		
		private function changeRoomColor(e:MouseEvent):void{
//			Main.currentColor = Main.currentColor == "qianse"?"shense":"qianse";
//			var dic:Dictionary = new Dictionary();
//			for(var i:int = selectableImageContainer.numChildren-1;i>=0;i--){
//				var img:Image = selectableImageContainer.getChildAt(i) as Image;
//				try{
//					dic[img.info.name] = img.info.fileName;
//				}catch(e:Error){
//					continue;
//				}
//				
//			}
//			YangBanJianPage.MAIN.remove();
//			var tp:String = Main.basePath + "img/fengge/" + FenggeSelectPage.currentPath +"/"+ Main.currentColor +"/"+kongjian+"/";
//			Common.MAIN.addChild(new YangBanJianPage(tp,dic));
		}
		
		private var hotClosed:Boolean = false;
		public function closePoints(e:MouseEvent):void{
//			if(hotClosed){
//				for each(var p:pointMc in hotPointDic){
//					p.scaleX = p.scaleY = 1;
//					TweenLite.to(p,.6,{x:hotPointPosDic[p.name].x,y:hotPointPosDic[p.name].y});
//				}
//				hotClosed = false;
//			}else{
//				for each(var p:pointMc in hotPointDic){
//					TweenLite.to(p,.6,{x:closeHotPoint.x + 10,y:closeHotPoint.y + 10,onComplete:function():void{
//						for each(var p1:pointMc in hotPointDic){
//							p1.scaleX = p1.scaleY = 0;
//						}
//					}});
//				}
//				hotClosed = true;
//			}	
			hotPointLayer.visible = !hotPointLayer.visible;
		}
		
		private function onBack(e:MouseEvent):void{		
			RoomPage.MAIN.remove();
			if(backtoVideo){
				VideoSelectPage.vpage.back.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}		
			Common.currentColor = "shense";
		}
		
		public function remove():void{
			clearAll(this);
			saveData.dispose();
			parent.removeChild(this);
			for each(var a:Array in hotPointDic){
				for each(var p:pointMc in a){
					p.removeEventListener(MouseEvent.CLICK,onHotPointClick);
				}
			}
			
		}
		
		private function createArrowBtn():void{
			rightBtn.buttonSource = ["data/img/roompic/fangxiangjiantou.png"];
			rightBtn.x = -28;
			rightBtn.y = 350;
			right.addChild(rightBtn);
			rightBtn.addEventListener(MouseEvent.CLICK,onRight);
		}
		
		private function loadXml():void{
			
//			var urlLoader:URLLoader = new URLLoader();
//			urlLoader.load(new URLRequest(path + "default.xml"));
//			urlLoader.addEventListener(Event.COMPLETE,onLoadComplete);
//			
//			var urlLoader1:URLLoader = new URLLoader();
//			urlLoader1.load(new URLRequest(path + "data.xml"));
//			urlLoader1.addEventListener(Event.COMPLETE,onLoadComplete1);
			initPage();
		}
		
		
		private function onLoadComplete1(e:Event):void{
			productInfoData = new XML(e.target.data);
			for each(var xml:XML in productInfoData.product){
				xml.@num = "1";
			}
		}
		
		private function onLoadComplete(e:Event):void{
			data = new XML(e.target.data);			
			initPage();
		}
		//选择被点击的产品
		private function onImageClick(e:MouseEvent):void{
			var flag:Boolean = false;
			for(var i:int = selectableImageContainer.numChildren-1;i>=0;i--){
				var img:Image = selectableImageContainer.getChildAt(i) as Image;
				try{
					if((img.back.bitmapData.getPixel32(e.localX,e.localY)>>24&255) > 200){
						img.dispatchEvent(new Event(CHANGE));
						flag = true;
//						for each(var p:pointMc in hotPointDic){
//							p.dispatchEvent(new Event(CHANGE));
//						}
						break;
					}
				}catch(e:Error){
					continue;
				}
				
			}
		}
		
		
		
		private function createKongjianBtn():void{
			downSelect.alpha = 0;
			downSelect.mouseEnabled = downSelect.mouseChildren = false;
			addChild(downBack);
			downBack.y = yindex;
			downBack.x = -200;
			pingleiMask.graphics.beginFill(0,0);
			pingleiMask.graphics.drawRect(0,0,500,50);
			pingleiMask.graphics.endFill();
			pingleiMask.x = 250;
			pingleiMask.y = yindex;
			addChild(pingleiMask);
			downBack.mask = pingleiMask;
			var dic:Dictionary = new Dictionary();
			for each(var xml:Dictionary in roomDefaultData["image"]){
				var type:String = xml["type"];
				dic[type] = 1;
			}
			jiajuBtn.buttonSource = ["data/img/roompic/jiaju.png"];
			qiangmianBtn.buttonSource = ["data/img/roompic/qiangmian.png"];
			dimianBtn.buttonSource = ["data/img/roompic/dimian.png"];
			shipinBtn.buttonSource = ["data/img/roompic/shipin.png"];
			jiancaiBtn.buttonSource = ["data/img/roompic/jiancai.png"];
			var xIndex:Number = 40;
			if(dic["jiaju"] == 1){
				jiajuBtn.x = xIndex;
				downBack.addChild(jiajuBtn);
				xIndex += 70;
			}
			
			if(dic["qiangmian"] == 1){
				qiangmianBtn.x = xIndex;
				downBack.addChild(qiangmianBtn);
				xIndex += 70;
			}
			if(dic["dimian"] == 1){
				dimianBtn.x = xIndex;
				downBack.addChild(dimianBtn);
				xIndex += 70;
			}
			if(dic["shipin"] == 1){
				shipinBtn.x = xIndex;
				downBack.addChild(shipinBtn);
				xIndex += 70;
			}
			if(dic["jiancai"] == 1){
				jiancaiBtn.x = xIndex;
				downBack.addChild(jiancaiBtn);
				xIndex += 70;
			}
			
			jiajuBtn.addEventListener(MouseEvent.CLICK,onKongjinaClick);
			shipinBtn.addEventListener(MouseEvent.CLICK,onKongjinaClick);
			qiangmianBtn.addEventListener(MouseEvent.CLICK,onKongjinaClick);
			dimianBtn.addEventListener(MouseEvent.CLICK,onKongjinaClick);
			downBtn.addEventListener(MouseEvent.CLICK,onKongjinaClick);
			saveBtn.addEventListener(MouseEvent.CLICK,onKongjinaClick);
			jiajuBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			savelabel.mouseEnabled = savelabel.mouseChildren = false;
			savelabel.textWidth = 200;
		}
		
		private var downed:Boolean = false;
		private var saveAble:Boolean = true;
		private var savelabel:Label = new Label("已保存至相册");
		private function onKongjinaClick(e:MouseEvent):void{
			switch(e.currentTarget){
				case downBtn:
					if(downed){
						TweenLite.to(downBack,.5,{y:720});
						downed = false;
					}else{
						TweenLite.to(downBack,.5,{y:750});
						downed = true;
					}
					break;
				case jiajuBtn:
					btnScroller.clearContent();
					var index:int = 0;
					var clicked:Boolean = false;					
					for each(var dic:Dictionary in roomDefaultData["image"]){
					if(dic["type"] == "jiaju"){
						var btnsim:SimpleButton = new SimpleButton(160,35);
						btnsim.textColor = 0xffffff;
						btnsim.y = index*45;
						btnsim.label = dic["nametext"];
						btnsim.name = dic["name"];
						btnsim.addEventListener(MouseEvent.CLICK,onBtnClick);
						btnScroller.addChild(btnsim);
						index++;
						if(!clicked){
							btnsim.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
							clicked = true;
						}
					}
					
				}
					
					btnScroller.y = 30;
					right.addChild(btnScroller);
					downSelect.x = 5;
					downSelect.y = 20;
					downBack.addChild(downSelect);
					break;
				case jiancaiBtn:
					btnScroller.clearContent();
					var index:int = 0;
					var clicked:Boolean = false;					
					for each(var dic:Dictionary in roomDefaultData["image"]){
					if(dic["type"] == "jiancai"){
						var btnsim:SimpleButton = new SimpleButton(160,35);
						btnsim.textColor = 0xffffff;
						btnsim.y = index*45;
						btnsim.label = dic["nametext"];
						btnsim.name = dic["name"];
						btnsim.addEventListener(MouseEvent.CLICK,onBtnClick);
						btnScroller.addChild(btnsim);
						index++;
						if(!clicked){
							btnsim.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
							clicked = true;
						}
					}
					
				}
					
					btnScroller.y = 30;
					right.addChild(btnScroller);
					downSelect.x = 120;
					downSelect.y = 20;
					downBack.addChild(downSelect);
					break;
				case shipinBtn:
					btnScroller.clearContent();
					var index:int = 0;
					var clicked:Boolean = false;					
					for each(var dic:Dictionary in roomDefaultData["image"]){
					if(dic["type"] == "shipin"){
						var btnsim:SimpleButton = new SimpleButton(160,35);
						btnsim.textColor = 0xffffff;
						btnsim.y = index*45;
						btnsim.label = dic["nametext"];
						btnsim.name = dic["name"];
						btnsim.addEventListener(MouseEvent.CLICK,onBtnClick);
						btnScroller.addChild(btnsim);
						index++;
						if(!clicked){
							btnsim.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
							clicked = true;
						}
					}
					
				}
					
					btnScroller.y = 30;
					right.addChild(btnScroller);
					downSelect.x = 120;
					downSelect.y = 20;
					downBack.addChild(downSelect);
					break;
				case qiangmianBtn:
					btnScroller.clearContent();
					var index:int = 0;
					var clicked:Boolean = false;					
					for each(var dic:Dictionary in roomDefaultData["image"]){
					if(dic["type"] == "qiangmian"){
						var btnsim:SimpleButton = new SimpleButton(160,35);
						btnsim.textColor = 0xffffff;
						btnsim.y = index*45;
						btnsim.label = dic["nametext"];
						btnsim.name = dic["name"];
						btnsim.addEventListener(MouseEvent.CLICK,onBtnClick);
						btnScroller.addChild(btnsim);
						index++;
						if(!clicked){
							btnsim.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
							clicked = true;
						}
					}
					
				}
					
					btnScroller.y = 30;
					right.addChild(btnScroller);
					downSelect.x = 240;
					downSelect.y = 20;
					downBack.addChild(downSelect);
					break;
				case dimianBtn:
					btnScroller.clearContent();
					var index:int = 0;
					var clicked:Boolean = false;					
					for each(var dic:Dictionary in roomDefaultData["image"]){
					if(dic["type"] == "dimian"){
						var btnsim:SimpleButton = new SimpleButton(160,35);
						btnsim.textColor = 0xffffff;
						btnsim.y = index*45;
						btnsim.label = dic["nametext"];
						btnsim.name = dic["name"];
						btnsim.addEventListener(MouseEvent.CLICK,onBtnClick);
						btnScroller.addChild(btnsim);
						index++;
						if(!clicked){
							btnsim.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
							clicked = true;
						}
					}
					
				}
					
					btnScroller.y = 30;
					right.addChild(btnScroller);
					downSelect.x = 355;
					downSelect.y = 20;
					downBack.addChild(downSelect);
					break;
				case saveBtn:
					if(saveAble){
						if(CameraRoll.supportsAddBitmapData){ 
							saveData.draw(selectableImageContainer);
							cameraRoll.addBitmapData(saveData);
						}
						saveAble = false;
						setTimeout(changeSaveAble,5000);
						savelabel.x = 620;savelabel.y = 22;
						savelabel.size = 20;
						savelabel.color = "0x0000ff";
						savelabel.alpha = 1;
						downBack.addChild(savelabel);
						TweenLite.to(savelabel,2,{alpha:0});
					}					
					break;
			}
		}
		
		private function changeSaveAble():void{
			saveAble = true;
		}
		
		public var zoomContainer:Sprite = new Sprite();
		private var zoomScroller:Scroller = new Scroller(Common.MAX_WIDTH,715);
		private var zoomImage:Image = new Image();
		private var closeZoomBtn:Image = new Image("data/img/close.png");
		private var closeStoryBtn:Image = new Image("data/img/close.png");
		private var animeBtn:Button = new Button(100,50,500,700);
		private var video:VideoContainer = new VideoContainer(false,false);
		private var storyContainer:Sprite = new Sprite();
		private var storyImage:Image = new Image();
		
		private var hotPointDic:Dictionary = new Dictionary();//存储热点	
		private var hotPointPosDic:Dictionary = new Dictionary();//存储热点	
		private var hotPointXmlDic:Dictionary = new Dictionary();//存储热点的对应xml		
		private var appearPointDic:Dictionary = new Dictionary();//存储根据图片决定是否显示的热点
		private var addToOrderBtn:Image = new Image(Main.basePath + "img/addtoorder.png");
		private var sharedObject:SharedObject;
		private var biaojied:Boolean = false;
		
		private var hotpointFunctionsContainer:Sprite = new Sprite();
		private var storyBtn:Image = new Image("data/img/roompic/txt.png");
		private var zoomInfoBtn:Image = new Image("data/img/roompic/out.png");
		private var jiageBack:Image = new Image("data/img/roompic/jiage1.png");
		private var jiageLabel:Label = new Label("",20);
		private function createHotPoint():void{

			zoomContainer.visible = false;
			zoomContainer.graphics.beginFill(0,.6);
			zoomContainer.graphics.drawRect(0,0,Common.MAX_WIDTH,Common.MAX_HEIGHT);
			zoomContainer.graphics.endFill();
			addChild(zoomContainer);
			
			zoomInfoBtn.y = 70;
			jiageBack.y = 140;
			jiageLabel.x = 60;
			jiageLabel.y = 150;
			hotpointFunctionsContainer.addChild(storyBtn);
			hotpointFunctionsContainer.addChild(zoomInfoBtn);
			hotpointFunctionsContainer.addChild(jiageBack);
			hotpointFunctionsContainer.addChild(jiageLabel);
			storyBtn.buttonMode = zoomInfoBtn.buttonMode = true;
			storyBtn.addEventListener(MouseEvent.CLICK,onStoryClick);
			zoomInfoBtn.addEventListener(MouseEvent.CLICK,onZoomInfoClick);
			zoomContainer.addChild(hotpointFunctionsContainer);
			
			zoomScroller.y = 120;
			zoomContainer.addChild(zoomScroller);		
			zoomScroller.addChild(zoomImage);
			zoomScroller.visible = false;
			
			storyContainer.addChild(storyImage);
			storyContainer.addChild(video);
			zoomContainer.addChild(storyContainer);
			storyContainer.visible = false;
			
//			video.y = 24;
//			zoomContainer.addChild(video);
			zoomImage.width = storyImage.width = 1024*scx;
			zoomImage.height = storyImage.height = 510*scy;
			storyImage.y = 120;
			video.setSize(800,600);
			video.x = 200;video.y = 150;
			closeZoomBtn.x = closeStoryBtn.x = 1140/scx;
			closeZoomBtn.y = closeStoryBtn.y = 0;
			zoomImage.addChild(closeZoomBtn);
			storyImage.addChild(closeStoryBtn);


			closeZoomBtn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				zoomScroller.visible = false;
				

			});
			
			closeStoryBtn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				storyContainer.visible = false;				
			});
			zoomContainer.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				if(e.target == zoomContainer){
					zoomContainer.visible = false;
					right.visible = true;
					downBack.visible = true;
					currentPMC.lineLayer.graphics.clear();
				}				
			});

			video.addEventListener(VideoContainer.COMPLETE,onPlayEnd);
		}
		
		private function onStoryClick(e:MouseEvent):void{
			storyContainer.visible = true;
			storyImage.visible = video.visible = false;
			if(currentPMC.info["storyisvideo"] == "0"){
				storyImage.visible = true;
				storyImage.source = getStoryPath(currentPMC.info["story"]);
			}else{
				video.visible = true;
				video.playSt(getVideoPath(currentPMC.info["story"]));;
			}
		}
		
		private function onZoomInfoClick(e:MouseEvent):void{
			zoomScroller.visible = true;
			zoomImage.source = getZoomImagePath(currentPMC.info["zoomout"]);
		}
		
		private function playAnime(e:MouseEvent):void{
			video.visible = true;
			video.playSt(animePath);
		}
		
		private function onPlayEnd(e:Event):void{
			video.visible = false;
		}
		
		private function onBaseImageChange(e:Event):void{
			var p:pointMc = e.currentTarget as pointMc;
			if(p){
				var img:Image = getImageByName(hotPointXmlDic[p.name].attribute("relatedTo").toString());
				var imgName:String = img.info.fileName.split(".")[0];
				p.visible = false;
				for each(var s:String in appearPointDic[p.name]){
					if(imgName == s){
						p.visible = true;
					}
				}
			}
		}
		
		private var currentPMC:pointMc = null;
		private var animePath:String = "";
		private function onHotPointClick(e:MouseEvent):void{
			(e.currentTarget as pointMc).drawLine();
			currentPMC = (e.currentTarget as pointMc);
			zoomContainer.visible = true;
			hotpointFunctionsContainer.alpha = 0;			
			hotpointFunctionsContainer.x = Number(currentPMC.info["endX"]);
			hotpointFunctionsContainer.y = Number(currentPMC.info["endY"]);
//			zoomContainer.visible = true;
//			right.visible = false;
//			downBack.visible = false;
//			var pName:String = e.currentTarget.name;
//			var imagePath:String = "";
//			var xml:XML = hotPointXmlDic[pName];
//			currentPMC = e.currentTarget as pointMc;
//			if(xml.attribute("type").toString() == "solid"){
//				imagePath = path_1 + "zoomout/" + pName + "/" +pName+ ".jpg";
//				zoomImage.source = imagePath;
//				animePath = imagePath.replace(".png",".flv");
//				animeBtn.visible = new File(animePath).exists;
//				sharedObject = SharedObject.getLocal("product");
//				var array:Array = sharedObject.data.array;
//				if(array.indexOf(imagePath)==-1){
//					biaojied = false;
//					biaojiBtn.source = Main.basePath + "img/biaoji.png";
//				}else{
//					biaojied = true;
//					biaojiBtn.source = Main.basePath + "img/quxiaobiaoji.png";
//				}
//				return;
//			}
//			if(!xml.hasOwnProperty("@relatedTo")){
//				imagePath = path_1 + "zoomout/" + pName + "/" + getImageByName(pName).info.fileName;
//				zoomImage.source = imagePath;
//				animePath = imagePath.replace(".png",".flv");
//				animeBtn.visible = new File(animePath).exists;
//				sharedObject = SharedObject.getLocal("product");
//				var array:Array = sharedObject.data.array;
//				if(array.indexOf(imagePath)==-1){
//					biaojied = false;
//					biaojiBtn.source = Main.basePath + "img/biaoji.png";
//				}else{
//					biaojied = true;
//					biaojiBtn.source = Main.basePath + "img/quxiaobiaoji.png";
//				}
//				return;
//			}
//			var image:Image;
//			var xml1:XML;
//			for (var j:int = 0; j < data.image.length(); j++) 
//			{
//				xml1 = data.image[j];
//				image = getImageByName(pName);
//				if(image == null)
//					break;
//				if(image.info.name == xml1.attribute("name").toString()){
//					imagePath = path_1 + "zoomout/" + pName + "/" + getImageByName(pName).info.fileName;
//					zoomImage.source = imagePath;
//					animePath = imagePath.replace(".png",".flv");
//					animeBtn.visible = new File(animePath).exists;
//					sharedObject = SharedObject.getLocal("product");
//					var array:Array = sharedObject.data.array;
//					if(array.indexOf(imagePath)==-1){
//						biaojied = false;
//						biaojiBtn.source = Main.basePath + "img/biaoji.png";
//					}else{
//						biaojied = true;
//						biaojiBtn.source = Main.basePath + "img/quxiaobiaoji.png";
//					}
//					return;
//				}
//			}
//			
//			imagePath = path_1 + "zoomout/" + pName + "/" + getImageByName(xml.attribute("relatedTo").toString()).info.fileName;
//			animePath = imagePath.replace(".png",".flv");
//			animeBtn.visible = new File(animePath).exists;
//			zoomImage.source = imagePath;
//			sharedObject = SharedObject.getLocal("product");
//			var array:Array = sharedObject.data.array;
//			if(array.indexOf(imagePath)==-1){
//				biaojied = false;
//				biaojiBtn.source = Main.basePath + "img/biaoji.png";
//			}else{
//				biaojied = true;
//				biaojiBtn.source = Main.basePath + "img/quxiaobiaoji.png";
//			}
		}
		
		private function  createPointMc():pointMc{
			var p:pointMc = new pointMc();
			return p;
		}
		
		//保存图片
		//		private var saveContainer:Sprite = new Sprite();
		//		private var saveData:BitmapData = new BitmapData(Common.MAX_WIDTH,Common.MAX_HEIGHT);
		//		private var saveImage:Bitmap = new Bitmap();
		//		private var saveImageBtn:Button = new Button(100,50,670,645);
		//		private var saveState:Image = new Image();
		//		private var savedState:Image = new Image();
		//		private var closeBtn:Button = new Button(100,50,800,645);
		private var cameraRoll:CameraRoll = new CameraRoll();
		//		private function createSave():void{
		//			saveContainer.graphics.beginFill(0,.6);
		//			saveContainer.graphics.drawRect(0,0,Common.MAX_WIDTH,Common.MAX_HEIGHT);
		//			saveContainer.graphics.endFill();
		//			addChild(saveContainer);
		//			saveImage.x = 125;
		//			saveImage.y = 95;
		//			saveImage.scaleX = 1552/2048;
		//			saveImage.scaleY = 1552/2048;
		//			saveContainer.addChild(saveImage);
		//			saveState.x = savedState.x = 125;
		//			saveState.y = savedState.y = 640;
		//			saveContainer.addChild(saveState);
		//			saveContainer.addChild(saveImageBtn);
		//			saveContainer.addChild(savedState);
		//			saveContainer.addChild(closeBtn);
		//			saveContainer.visible = false;
		//			savedState.visible = false;
		//			saveImageBtn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
		//				if(CameraRoll.supportsAddBitmapData){	////////苹果系统专用，用于将图像保存到起相机卷中
		//					cameraRoll.addBitmapData(saveData);
		//				}
		//				savedState.visible = true;
		//			});
		//			closeBtn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
		//				saveContainer.visible = false;
		//				savedState.visible = false;
		//			});
		//		}
		
		private var saveContainer:Image = new Image();
		private var closeImage:Image = new Image(Main.basePath + "img/close.png");
		private var saveData:BitmapData = new BitmapData(Common.MAX_WIDTH,Common.MAX_HEIGHT);
		private var saveImage:Bitmap = new Bitmap();
		//private var saveImageBtn:Button = new Button(110,50,110,675);
		private var saveState:Image = new Image(Main.basePath + "img/save.png");
		private var savedState:Image = new Image(Main.basePath + "img/saved.png");
		//private var closeBtn:Button = new Button(100,50,860,675);
		
		private var userNameText:TextField = new TextField();
		private var userPhoneText:TextField = new TextField();
		private var buildAddressText:TextField = new TextField();
		private var userAddressText:TextField = new TextField();
		
		private var noticeLabel:Label = new Label("姓名与联系电话为必填项");
		private var productInfoScroller:Scroller = new Scroller(1000,400,1);
		
		private var zongjia:Label = new Label();
		private function createSave():void{
			
			//			saveData.draw(selectableImageContainer);
			//			saveImage.bitmapData = saveData;
			saveContainer.addChild(closeImage);
			saveContainer.graphics.beginFill(0,.6);
			saveContainer.graphics.drawRect(-300,-300,Common.MAX_WIDTH*2,Common.MAX_HEIGHT*2);
			saveContainer.graphics.endFill();
			addChild(saveContainer);
			saveContainer.source =Main.basePath + "img/saveback.png";
			saveContainer.x = 0;
			saveContainer.y = 0;
			saveState.x = savedState.x = 134;
			saveState.y = savedState.y = 710;
			saveContainer.addChild(saveState);
			//saveContainer.addChild(saveImageBtn);
			saveContainer.addChild(savedState);
			//saveContainer.addChild(closeBtn);
			saveContainer.addChild(userAddressText);
			saveContainer.addChild(userNameText);
			saveContainer.addChild(userPhoneText);
			saveContainer.addChild(buildAddressText);
			saveContainer.addChild(productInfoScroller);
			saveContainer.addChild(zongjia);
			zongjia.height = 40;
			closeImage.x = 54;
			closeImage.y = 710;
			zongjia.x = 798+42;
			zongjia.y = 190;
			zongjia.size = 20;
			zongjia.color="0xFF6600";
			saveContainer.visible = false;
			savedState.visible = false;
			
			userAddressText.type = userNameText.type = userPhoneText.type = buildAddressText.type = TextFieldType.INPUT;
			userNameText.x = 140;
			userNameText.y = 89;
			var format:TextFormat = new TextFormat();
			format.size = 20;
			userNameText.defaultTextFormat = format;
			userAddressText.x = 607;
			userAddressText.y = 143;
			
			userPhoneText.x = 390;
			userPhoneText.y = 89;
			format = new TextFormat();
			format.size = 20;
			userPhoneText.defaultTextFormat = format;
			buildAddressText.x = 140;
			buildAddressText.y = 154;
			format = new TextFormat();
			format.size = 20;
			buildAddressText.defaultTextFormat = format;
			userNameText.width = 150;
			userAddressText.width = 260;
			userPhoneText.width = 150;
			buildAddressText.width = 440+374;			
			productInfoScroller.x = 12;
			productInfoScroller.y = 220;
			//productInfoScroller.setSlider(true,-30);
			
			noticeLabel.x = 500;
			noticeLabel.y = 680;
			noticeLabel.color="0xffff0000";
			noticeLabel.size = 12;
			noticeLabel.width = 250;
			noticeLabel.visible = false;
			saveContainer.addChild(noticeLabel);
			
			saveState.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				var h1:Number = 220;
				var sp:Sprite = new Sprite();
				
				
				
				var i:int = 0;
//				for(var key:String in orderInfoDic){
//					var array:Array = sharedObject.data.array;
//					var list:Dictionary = orderInfoDic[key];
//					var label:Label = new Label(Main.yangbanjianNameInfo.yangbanjian.(@id == key.split("_")[1])[0].attribute("name").toString());
//					label.size = 12;
//					label.x = 480;
//					label.y = i*50;
//					i++;
//					sp.addChild(label);
//					for(var innerKey:String in list){
//						var xml1:XML = list[innerKey];
//						if(key == FenggeSelectPage.currentPath+"_"+kongjian){
//							var xml:XML = hotPointXmlDic[innerKey];
//							var soldOut:Boolean = false;
//							if(!xml.hasOwnProperty("@relatedTo")){
//								var imagePath:String = path_1 + "zoomout/" + innerKey + "/" + getImageByName(innerKey).info.fileName;						
//								sharedObject = SharedObject.getLocal("product");
//								
//								if(array.indexOf(imagePath)==-1){
//									soldOut = false;
//									xml1.@soldout = "false";
//								}else{
//									soldOut = true;
//									xml1.@soldout = "true";
//								}
//							}else{
//								var imagePath:String = path_1 + "zoomout/" + innerKey + "/" + getImageByName(xml.attribute("relatedTo").toString()).info.fileName;						
//								sharedObject = SharedObject.getLocal("product");
//								if(array.indexOf(imagePath)==-1){
//									soldOut = false;
//									xml1.@soldout = "false";
//								}else{
//									soldOut = true;
//									xml1.@soldout = "true";
//								}
//							}
//						}else{
//							if(xml1.hasOwnProperty("@soldout")){
//								soldOut = xml1.attribute("soldout").toString() == "true";
//							}else{
//								soldOut = false;
//							}
//						}					
//						var info:ProductInfo = new ProductInfo(xml1,innerKey,soldOut,"save");
//						info.x = 100;
//						info.y = i*50;
//						i++;
//						sp.addChild(info);
//					}
//				}
				
				
				
				
				var imageHeight:Number = h1+sp.height + 100;
				var imageWidth:Number = Common.MAX_WIDTH;
				var temp1:BitmapData = new BitmapData(imageWidth,h1);
				var temp2:BitmapData = new BitmapData(imageWidth,sp.height);
				temp1.draw(saveContainer);
				temp2.draw(sp);
				orderImageForSave = new BitmapData(imageWidth,imageHeight);
				orderImageForSave.copyPixels(temp1,new Rectangle(0,0,1024,h1),new Point(0,0));
				orderImageForSave.copyPixels(temp2,new Rectangle(0,0,1024,sp.height),new Point(0,h1));
				saveState.visible = false;
				savedState.visible = true;
				if(CameraRoll.supportsAddBitmapData){	////////苹果系统专用，用于将图像保存到起相机卷中
					cameraRoll.addBitmapData(orderImageForSave);
				}else{
					var file1:File = new File(File.documentsDirectory.resolvePath("ddd/order.jpg").nativePath);
					var byteArray:ByteArray = new ByteArray();
					orderImageForSave.encode(new Rectangle(0,0,imageWidth,imageHeight), new JPEGEncoderOptions(), byteArray); 
					var nstream1:FileStream = new FileStream();
					nstream1.open(file1,FileMode.WRITE);
					nstream1.writeBytes(byteArray);
					nstream1.close();
				}
				
				temp1.dispose();
				temp2.dispose();
				orderImageForSave.dispose();
			});
			closeImage.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				saveContainer.visible = false;
				savedState.visible = false;
			});
		}
		
		public function setZongjia():void{
			var total:Number = 0;
			for(var key:String in orderInfoDic){
				var array:Array = sharedObject.data.array;
				var list:Dictionary = orderInfoDic[key];
				for(var innerKey:String in list){
					var xml1:XML = list[innerKey];					
					total += Number(xml1.attribute("price"))*Number(xml1.attribute("num"));
				}
			}
			zongjia.text = "总价: " + total;
		}
		
		//设计说明
		private var shejiContainer:Sprite = new Sprite();
		private var shejiImage:Image = new Image();
		private var shejiReturnBtn:Button = new Button(170,90,900,700);
		
		private function createShejiShuoMing():void{
			addChild(shejiContainer);
			shejiContainer.graphics.beginFill(0,.6);
			shejiContainer.graphics.drawRect(0,0,Common.MAX_WIDTH,Common.MAX_HEIGHT);
			shejiContainer.graphics.endFill();
			shejiImage.x = 60;
			shejiImage.y = 80;
			shejiContainer.addChild(shejiImage);
			shejiContainer.addChild(shejiReturnBtn);
			shejiContainer.visible = false;
			shejiReturnBtn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				shejiContainer.visible = false;
			});
		}
		
		
		
		private function createBtns():void{
			var index:int = 0;
			var clicked:Boolean = false;
			for each(var fileName:String in existProducts){
				var btn:Button = new Button(133,35,30,index*45);
				btn.buttonSource = [Main.basePath + "img/btn/"+fileName+"_1.png",Main.basePath + "img/btn/"+fileName+"_2.png"];
				btn.name = fileName;
				btn.addEventListener(MouseEvent.CLICK,onBtnClick);
				btnScroller.addChild(btn);
				index++;
				if(!clicked){
					btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					clicked = true;
				}
			}
			btnScroller.y = 30;
			btnScroller.x = -15;
			right.addChild(btnScroller);
		}
		
		private function onBtnClick(e:MouseEvent):void{
			var currentDir:String = e.currentTarget.name;
			rightScroller.scroller.clearContent();
			var arr:Array = new Array();
			var arr1:Array = new Array();			
			for (var i:int = 1; i <= imgCountDic[currentDir]; i++) 
			{
				arr.push(getThumbImagePath(currentDir + "_0" + i));
				arr1.push(i);
			}
			
			
			rightScroller.dataSource(arr,140,15,onRightGuitiThumbClick);
			for(var index:int = 0;index<rightScroller.scroller.btnArr.length;index++){
				(rightScroller.scroller.btnArr[index] as ImageButton).info = arr1[index];
				(rightScroller.scroller.btnArr[index] as ImageButton).name = e.currentTarget.name
			}
		}
		private var soldOutlabel:Label = new Label("该商品已售完");
		private function onRightGuitiThumbClick(e:MouseEvent):void{
			var currentChangeImg:Image = getImageByName(e.currentTarget.name);
			var pinlei:String = e.currentTarget.name;
			if(currentChangeImg == null)return;
			
			if(Number(e.currentTarget.info) == 1){
				imgCurrentCountDic[pinlei] = imgCountDic[pinlei];
			}else{
				imgCurrentCountDic[pinlei] = Number(e.currentTarget.info) - 1;
			}
			
			currentChangeImg.dispatchEvent(new Event(CHANGE));
		}
		
		private function onGetData(e:Event):void{
			e.currentTarget.alpha = 1;
			e.currentTarget.removeEventListener(Image.GET_DATA,onGetData);
			eventAccept = true;
		}
		//换图刷新热点
		private function onImageGetDataChangeHotPoint(e:Event):void{
			var img:Image = e.target as Image;
			var pinlei:String = img.info.name;
			var id:String = img.info.fileName;
			var dic:Dictionary = getHotPontDicById(id);
			if(dic == null)return;
			for each(var op:pointMc in hotPointDic[pinlei]){
				op.clear();
			}
			var np:pointMc;
			hotPointDic[pinlei] = new Array();
			if((dic["child"] as Array).length>0){
				for each(var d:Dictionary in dic["child"]){
				 	np = new pointMc();
					np.info = d;
					np.parentInfo = dic;
					np.x = Number(d["x"])*scx;
					np.y = Number(d["y"])*scy; 
					hotPointLayer.addChild(np);
					hotPointDic[pinlei].push(np);
					np.addEventListener(MouseEvent.CLICK,onHotPointClick);
					np.addEventListener(Event.COMPLETE,onHotPointLineComplete);
				}
			}
			np = new pointMc();
			np.info = dic;
			np.x = Number(dic["x"])*scx;
			np.y = Number(dic["y"])*scy; 
			hotPointLayer.addChild(np);
			hotPointDic[pinlei].push(np);
			np.addEventListener(MouseEvent.CLICK,onHotPointClick);
			np.addEventListener(Event.COMPLETE,onHotPointLineComplete);
		}
		
		private function getProductDataById(id:String):Dictionary{
			for each(var d:Dictionary in roomData){
				if(d["id"] == id){
					return d;
				}
			}
			return null;
		}
		
		private function onHotPointLineComplete(e:Event):void{
			if(!UserConfig.showPrice){
				jiageBack.visible = jiageLabel.visible = false;								
			}else{
				jiageBack.visible = jiageLabel.visible = true;
				jiageLabel.text = getProductDataById(currentPMC.info["zoomout"])["price"];
			}
			TweenLite.to(hotpointFunctionsContainer,1,{alpha:1});
		}
		
		private function getHotPontDicById(id:String):Dictionary{
			var flag:Boolean = false;
			var result:Dictionary = null;
			for each(var dic:Dictionary in roomDefaultData["hotpoint"]){
				if(flag)break;
				if(dic["zoomout"] == id){
					result = dic;
					break;
				}
				if(dic["child"].length>0){
					for each(var dic1:Dictionary in dic["child"]){
						if(dic1["zoomout"] == id){
							result = dic1;
							flag = true;
							break;
						}
					}
				}
			}
			return result;
		}
		
		//创建产品图片
		private function createImages():void{
			if(initInfo == null){
				for each(var xml:Dictionary in roomDefaultData.image){
					var img:Image = new Image();
					img.addEventListener(Image.GET_DATA,onImageGetDataChangeHotPoint);
					img.source = getBigImagePath(xml["source"]);
					img.info = {name:xml["name"],fileName:xml["source"]};
					img.width = Common.MAX_WIDTH;
					img.height = Common.MAX_HEIGHT;
					imgCountDic[xml["name"]] = Number(xml["imgCout"]);
					imgCurrentCountDic[xml["name"]] = 1;
					selectableImageContainer.addChild(img);
					img.addEventListener(CHANGE,onChange);
					
				}
//				var image:Image;
//				var xml:XML;
//				for (var j:int = 0; j < data.image.length(); j++) 
//				{
//					xml = data.image[j];
//					if(xml.hasOwnProperty("@relatedTo")){
//						if(xml.hasOwnProperty("@disappear")){
//							var tempImage:Image = getImageByName(xml.attribute("relatedTo").toString());
//							var names:Array = xml.attribute("disappear").toString().split(",");
//							for each(var tempName:String in names){
//								if(tempName == tempImage.info.fileName.split(".")[0]){
//									image = getImageByName(xml.attribute("name").toString());
//									image.visible = false;
//								}else{
//									image = getImageByName(xml.attribute("name").toString());
//									image.visible = true;
//								}
//							}
//						}
//					}
//					
//				}
			}
			else{
//				for each(var xml:Dictionary in roomDefaultData.image){
//					var img:Image = new Image();
//					img.source = path + "bigImg/" + xml.attribute("name").toString() + "/"+ initInfo[xml.attribute("name").toString()];
//					img.info = {name:xml.attribute("name").toString(),fileName:initInfo[xml.attribute("name").toString()]};
//					selectableImageContainer.addChild(img);
//					img.addEventListener(CHANGE,onChange);
//				}
//				var image:Image;
//				var xml:XML;
//				for (var j:int = 0; j < data.image.length(); j++) 
//				{
//					xml = data.image[j];
//					if(xml.hasOwnProperty("@relatedTo")){
//						if(xml.hasOwnProperty("@disappear")){
//							var tempImage:Image = getImageByName(xml.attribute("relatedTo").toString());
//							var names:Array = xml.attribute("disappear").toString().split(",");
//							for each(var tempName:String in names){
//								if(tempName == tempImage.info.fileName.split(".")[0]){
//									image = getImageByName(xml.attribute("name").toString());
//									image.visible = false;
//								}else{
//									image = getImageByName(xml.attribute("name").toString());
//									image.visible = true;
//								}
//							}
//						}
//					}
//					
//				}
			}
		}
		
		private function getImageByName(s:String):Image{
			for(var i:int = selectableImageContainer.numChildren-1;i>=0;i--){
				var img:Image = selectableImageContainer.getChildAt(i) as Image;
				if(img.info.name == s){
					return img;
				}
			}
			return null;
		}
		
		private function onChange(e:Event):void{
			var img:Image = e.currentTarget as Image;
			var currentDir:String = e.currentTarget.info.name;
			var flag:Boolean = false;
			var first:Boolean = true;
			var temp:Dictionary = null;
			if(imgCurrentCountDic[currentDir] == imgCountDic[currentDir]){
				imgCurrentCountDic[currentDir] = 1;
			}else{
				imgCurrentCountDic[currentDir]++;			
			}
			var next:String = currentDir + "_0" + imgCurrentCountDic[currentDir];
			
			img.info.fileName = next;
			eventAccept = false;
			TweenLite.to(img,.4,{alpha:0,onComplete:function():void{
				img.addEventListener(Image.GET_DATA,onGetData);
				if(img.sourceURL == getBigImagePath(next)){
					img.dispatchEvent(new Event(Image.GET_DATA));
					return;
				}
				img.source = getBigImagePath(next);				
			}});		
			
//			var image:Image;
//			var xml:XML;
//			for (var j:int = 0; j < data.image.length(); j++) 
//			{
//				xml = data.image[j];
//				if(xml.attribute("relatedTo").toString() == img.info.name){
//					if(xml.hasOwnProperty("@disappear")){
//						var tempImage:Image = img;
//						var names:Array = xml.attribute("disappear").toString().split(",");
//						for each(var tempName:String in names){
//							if(tempName == img.info.fileName.split(".")[0]){
//								image = getImageByName(xml.attribute("name").toString());
//								image.visible = false;
//							}else{
//								image = getImageByName(xml.attribute("name").toString());
//								image.visible = true;
//							}
//						}
//					}
//				}
//			}
			
			
		}
		
		private function initRightScroller():void{
			
			right.x = Common.MAX_WIDTH-190;
			rightScroller.setLeftArrowX(15);
			//rightScroller.rightArrowBaseX = 65;
			addChild(right);
			rightScroller.x = 8;
			rightScroller.y = 200;
			right.addChild(rightScroller);
		}
		
		private function initButtomScroller():void{
			
		}
		//右侧缩进
		private function onRight(e:MouseEvent):void{
			if(right.x <=(Common.MAX_WIDTH-185*Common.MAX_HEIGHT/768)){
				TweenLite.to(right,.6,{x:Common.MAX_WIDTH});
			}else{
				TweenLite.to(right,.6,{x:(Common.MAX_WIDTH-185*Common.MAX_HEIGHT/768)});
			}
		}
		
		
	}
}












