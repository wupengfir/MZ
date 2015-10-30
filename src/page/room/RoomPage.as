package page.room
{
	import com.as3xls.xls.ExcelFile;
	import com.greensock.TweenLite;
	import com.shangyi.component.base.Page;
	import com.shangyi.component.buttonRelated.Button;
	import com.shangyi.component.buttonRelated.ImageButton;
	import com.shangyi.component.imageRelated.Image;
	import com.shangyi.component.scrollerRelated.SY_Scroller;
	import com.shangyi.component.scrollerRelated.ScrollableSprite;
	import com.shangyi.component.scrollerRelated.Scroller;
	import flash.text.TextFormat;
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
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	
	public class RoomPage extends Page
	{
		public static var products:Dictionary = new Dictionary();
		public static const CHANGE:String = "change";
		public static var MAIN:RoomPage;
		
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
		
		private var btnScroller:Scroller = new Scroller(190,180,1);
		
		private var right:Sprite = new Sprite();
		private var buttom:Sprite = new Sprite();
		private var up:Sprite = new Sprite();
		
		private var rightScroller:SY_Scroller = new SY_Scroller(170,530,135,445,0xffffff,1);
		public var rightBtn:Button = new Button(80,30,860,15);
		
		
		//首选产品的xml
		private var data:XML;
		//当前样板间存在的产品
		private var existProducts:Array = new Array();
		private var initInfo:Dictionary;
		
		private var back:Image = new Image(Main.basePath + "img/back.png");
		private var closeHotPoint:Image = new Image(Main.basePath + "img/hotpoint.png");
		private var selectColorBtn:Image = new Image(Main.basePath + "img/color.png");
		private var selectKongjianBtn:Image = new Image(Main.basePath + "img/kongjian.png");
		private var pingmianBtn:Image = new Image(Main.basePath + "img/pingmian.png");
		private var pingleiBtn:Image = new Image(Main.basePath + "img/pinglei.png");
		private var pingleiMask:Sprite = new Sprite();
		private var downSelect:Image = new Image(Main.basePath + "img/downselect.jpg");
		private var saveBtn:Image = new Image(Main.basePath + "img/save.png");
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
		private var xiadanBtn:Image = new Image(Main.basePath + "img/xiadan.png");
		private var qingdanBtn:Image = new Image(Main.basePath + "img/qingdan.png");
		public function RoomPage(path:String,initInfo:Dictionary = null)
		{
			this.alpha = 0;
			TweenLite.to(this,.7,{alpha:1,onComplete:function():void{
				NoticePage.notice.show();
			}});
			MAIN = this;
			this.path = path;
			path_1 = path;
			kongjian = new File(path).name;
			selectableImageContainer = new Sprite();
			this.graphics.beginFill(0xffffff,1);
			this.graphics.drawRect(0,0,1024,768);
			this.graphics.endFill();
			addChild(selectableImageContainer);	
			//selectableImageContainer.addChild(buttomImg);
			backImage.source = path+"solid.png";
			right.addChild(new Image(Main.basePath + "img/cebian.png"));
			rightScroller.graphics.clear();
			loadXml();
			back.x = back.y = 20;
			addChild(back);
			back.addEventListener(MouseEvent.CLICK,onBack);
			this.initInfo = initInfo;
			
			addChild(selectColorBtn);
			selectColorBtn.x = 100;
			selectColorBtn.y = 20;
			selectColorBtn.visible = new File(path.replace("shense","qianse")).exists;
			selectColorBtn.addEventListener(MouseEvent.CLICK,changeRoomColor);
			
			addChild(closeHotPoint);
			closeHotPoint.x = 20;
			closeHotPoint.y = yindex;
			closeHotPoint.addEventListener(MouseEvent.CLICK,closePoints);
			
			addChild(selectKongjianBtn);
			selectKongjianBtn.x = 100;
			selectKongjianBtn.y = yindex;
			selectKongjianBtn.addEventListener(MouseEvent.CLICK,showKongjian);
			
			addChild(pingmianBtn);
			pingmianBtn.x = 180;
			pingmianBtn.y = 20;
			pingmianBtn.visible = new File(path.substr(0,path.length - 1) + "_pingmian/").exists;
			pingmianBtn.addEventListener(MouseEvent.CLICK,addpingmian);
			
			addChild(pingleiBtn);
			pingleiBtn.x = 180;
			pingleiBtn.y = yindex;
			pingleiBtn.addEventListener(MouseEvent.CLICK,showpinglei);
			
			addChild(xiadanBtn);
			xiadanBtn.x = 954;
			xiadanBtn.y = yindex;
			xiadanBtn.addEventListener(MouseEvent.CLICK,xiadan);
			
			addChild(qingdanBtn);
			qingdanBtn.x = 874;
			qingdanBtn.y = yindex;
			qingdanBtn.addEventListener(MouseEvent.CLICK,showqingdan);
			
			//			setTimeout(function(){
			//				rightBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			//			},2000);
			
		}
		private var orderImageForSave:BitmapData;
		private function showqingdan(e:MouseEvent):void{
			addChild(saveContainer);
			saveContainer.visible = true;
			saveState.visible = true;
			
			productInfoScroller.clearContent();
			var i:int = 0;
			for(var key:String in orderInfoDic){
				var array:Array = sharedObject.data.array;
				var list:Dictionary = orderInfoDic[key];
				var label:Label = new Label(Main.yangbanjianNameInfo.yangbanjian.(@id == key.split("_")[1])[0].attribute("name").toString());
				label.size = 20;
				label.y = i*50;
				i++;
				productInfoScroller.addChild(label);
				for(var innerKey:String in list){
					var xml1:XML = list[innerKey];
					if(key == FenggeSelectPage.currentPath+"_"+kongjian){
						var xml:XML = hotPointXmlDic[innerKey];
						var soldOut:Boolean = false;
						if(!xml.hasOwnProperty("@relatedTo")){
							var imagePath:String = path_1 + "zoomout/" + innerKey + "/" + getImageByName(innerKey).info.fileName;						
							sharedObject = SharedObject.getLocal("product");
							
							if(array.indexOf(imagePath)==-1){
								soldOut = false;
								xml1.@soldout = "false";
							}else{
								soldOut = true;
								xml1.@soldout = "true";
							}
						}else{
							var imagePath:String = path_1 + "zoomout/" + innerKey + "/" + getImageByName(xml.attribute("relatedTo").toString()).info.fileName;						
							sharedObject = SharedObject.getLocal("product");
							if(array.indexOf(imagePath)==-1){
								soldOut = false;
								xml1.@soldout = "false";
							}else{
								soldOut = true;
								xml1.@soldout = "true";
							}
						}
					}else{
						if(xml1.hasOwnProperty("@soldout")){
							soldOut = xml1.attribute("soldout").toString() == "true";
						}else{
							soldOut = false;
						}
					}					
					var info:ProductInfo = new ProductInfo(xml1,innerKey,soldOut);
					info.addEventListener("deleted",function(e:Event){
						var pi:ProductInfo = e.currentTarget as ProductInfo;
						delete orderInfoDic[FenggeSelectPage.currentPath+"_"+kongjian][pi.type];
						showqingdan(null);
					});
					info.y = i*50;
					i++;
					productInfoScroller.addChild(info);
				}
			}
			setZongjia();
		}
		
		public static var orderInfoDic:Dictionary = new Dictionary();
		private var productInfoData:XML;
		private function xiadan(e:MouseEvent):void{
			orderInfoDic[FenggeSelectPage.currentPath+"_"+kongjian] = new Dictionary();
			for each(var p:pointMc in hotPointDic){
				if(!p.visible)continue;
				var img:Image = getImageByName(p.name);
				if(img == null){
					img = getImageByName(hotPointXmlDic[p.name].attribute("relatedTo").toString());
				}
				var idx:String = new File(img.sourceURL).name.split(".")[0];
				var proData:XML = productInfoData.product.(@name == p.name).(@id == idx)[0];
				orderInfoDic[FenggeSelectPage.currentPath+"_"+kongjian][p.name] = proData;
			}
			
			saveData.draw(selectableImageContainer);
			saveImage.bitmapData = saveData;saveImage.scaleX = saveImage.scaleY = 1;saveImage.x = saveImage.y = 0;
			stage.addChild(saveImage);
			TweenLite.to(saveImage,1,{x:xiadanBtn.x+20,y:xiadanBtn.y+20,scaleX:0,scaleY:0});
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
		private var kongjianScroller:SY_Scroller = new SY_Scroller(1024,414,904,385);
		private function showKongjian(e:MouseEvent):void{
			if(!kongjianContainer){
				kongjianContainer = new Sprite();
				kongjianContainer.graphics.beginFill(0,.6);
				kongjianContainer.graphics.drawRect(0,0,1024,768);
				kongjianContainer.graphics.endFill();
				kongjianScroller.y = 200;
				kongjianScroller.selectAble = false;
				kongjianContainer.addChild(kongjianScroller);
				kongjianScroller.setLeftArrowY(178);
				
				var file:File = new File(Main.basePath+"img/fengge/"+FenggeSelectPage.currentPath+"/shense");
				var array:Array = new Array();
				for each(var f:File in file.getDirectoryListing()){
					if(f.isDirectory&&f.name.indexOf("_pingmian")==-1){
						array.push(f.url + ".png");
					}
				}
				kongjianScroller.dataSource(array,100,30,function(e:MouseEvent):void{
					Main.currentColor = "shense";
					var img:ImageButton = e.currentTarget as ImageButton;
					var tp:String = img.sourceURL.replace(".png","")+"/";
					YangBanJianPage.MAIN.remove();	
					Common.MAIN.addChild(new YangBanJianPage(tp));
					
				});
				addChild(kongjianContainer);
				addChild(selectKongjianBtn);
			}else{
				kongjianContainer.visible = !kongjianContainer.visible;
			}					
		}
		
		
		
		private function initPage():void{
			selectableImageContainer.addEventListener(MouseEvent.CLICK,onImageClick);
			var tempPath:String = path + "bigImg";
			var dir:File = new File(path + "bigImg");
			var dirs:Array = dir.getDirectoryListing();
			for each(var f:File in dirs){
				if(f.isDirectory){
					existProducts.push(f.name);
				}
			}
			//createBtns();
			createImages();
			createHotPoint();
			initRightScroller();
			createArrowBtn();
			createSave();
			createKongjianBtn();
			
		}
		
		private function addpingmian(e:MouseEvent):void{
			var dic:Dictionary = new Dictionary();
			for(var i:int = selectableImageContainer.numChildren-1;i>=0;i--){
				var img:Image = selectableImageContainer.getChildAt(i) as Image;
				try{
					dic[img.info.name] = img.info.fileName;
				}catch(e:Error){
					continue;
				}
				
			}
			addChild(new PingmianPage(path.substr(0,path.length - 1) + "_pingmian/",dic));
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
			Main.currentColor = Main.currentColor == "qianse"?"shense":"qianse";
			var dic:Dictionary = new Dictionary();
			for(var i:int = selectableImageContainer.numChildren-1;i>=0;i--){
				var img:Image = selectableImageContainer.getChildAt(i) as Image;
				try{
					dic[img.info.name] = img.info.fileName;
				}catch(e:Error){
					continue;
				}
				
			}
			YangBanJianPage.MAIN.remove();
			var tp:String = Main.basePath + "img/fengge/" + FenggeSelectPage.currentPath +"/"+ Main.currentColor +"/"+kongjian+"/";
			Common.MAIN.addChild(new YangBanJianPage(tp,dic));
		}
		
		private var hotClosed:Boolean = false;
		public function closePoints(e:MouseEvent):void{
			if(hotClosed){
				for each(var p:pointMc in hotPointDic){
					p.scaleX = p.scaleY = 1;
					TweenLite.to(p,.6,{x:hotPointPosDic[p.name].x,y:hotPointPosDic[p.name].y});
				}
				hotClosed = false;
			}else{
				for each(var p:pointMc in hotPointDic){
					TweenLite.to(p,.6,{x:closeHotPoint.x + 10,y:closeHotPoint.y + 10,onComplete:function():void{
						for each(var p1:pointMc in hotPointDic){
							p1.scaleX = p1.scaleY = 0;
						}
					}});
				}
				hotClosed = true;
			}		
		}
		
		private function onBack(e:MouseEvent):void{		
			YangBanJianPage.MAIN.remove();
			VideoSelectPage.vpage.back.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			Main.currentColor = "shense";
		}
		
		public function remove():void{
			clearAll(this);
			saveData.dispose();
			parent.removeChild(this);
			for each(var p:pointMc in hotPointDic){
				p.removeEventListener(MouseEvent.CLICK,onHotPointClick);
			}
		}
		
		private function createArrowBtn():void{
			rightBtn.buttonSource = [Main.basePath + "img/fangxiangjiantou.png"];
			rightBtn.x = -28;
			rightBtn.y = 350;
			right.addChild(rightBtn);
			rightBtn.addEventListener(MouseEvent.CLICK,onRight);
		}
		
		private function loadXml():void{
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(path + "default.xml"));
			urlLoader.addEventListener(Event.COMPLETE,onLoadComplete);
			
			var urlLoader1:URLLoader = new URLLoader();
			urlLoader1.load(new URLRequest(path + "data.xml"));
			urlLoader1.addEventListener(Event.COMPLETE,onLoadComplete1);
			
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
						//trace(img.info.name+"__clicked"+(img.back.bitmapData.getPixel32(e.localX,e.localY)>>24&255));
						img.dispatchEvent(new Event(CHANGE));
						flag = true;
						for each(var p:pointMc in hotPointDic){
							p.dispatchEvent(new Event(CHANGE));
						}
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
			for each(var xml:XML in data.image){
				var type:String = xml.attribute("type").toString();
				dic[type] = 1;
			}
			jiajuBtn.buttonSource = [Main.basePath + "img/jiaju.png"];
			qiangmianBtn.buttonSource = [Main.basePath + "img/qiangmian.png"];
			dimianBtn.buttonSource = [Main.basePath + "img/dimian.png"];
			shipinBtn.buttonSource = [Main.basePath + "img/shipin.png"];
			jiancaiBtn.buttonSource = [Main.basePath + "img/jiancai.png"];
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
					for each(var xml:XML in data.image.(@type == "jiaju")){
					var btn:Button = new Button(133,35,30,index*45);
					var fileName:String = xml.attribute("name").toString();
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
					downSelect.x = 5;
					downSelect.y = 20;
					downBack.addChild(downSelect);
					break;
				case jiancaiBtn:
					btnScroller.clearContent();
					var index:int = 0;
					var clicked:Boolean = false;					
					for each(var xml:XML in data.image.(@type == "jiancai")){
					var btn:Button = new Button(133,35,30,index*45);
					var fileName:String = xml.attribute("name").toString();
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
					downSelect.x = 120;
					downSelect.y = 20;
					downBack.addChild(downSelect);
					break;
				case shipinBtn:
					btnScroller.clearContent();
					var index:int = 0;
					var clicked:Boolean = false;					
					for each(var xml:XML in data.image.(@type == "shipin")){
					var btn:Button = new Button(133,35,30,index*45);
					var fileName:String = xml.attribute("name").toString();
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
					downSelect.x = 120;
					downSelect.y = 20;
					downBack.addChild(downSelect);
					break;
				case qiangmianBtn:
					btnScroller.clearContent();
					var index:int = 0;
					var clicked:Boolean = false;					
					for each(var xml:XML in data.image.(@type == "qiangmian")){
					var btn:Button = new Button(133,35,30,index*45);
					var fileName:String = xml.attribute("name").toString();
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
					downSelect.x = 240;
					downSelect.y = 20;
					downBack.addChild(downSelect);
					break;
				case dimianBtn:
					btnScroller.clearContent();
					var index:int = 0;
					var clicked:Boolean = false;					
					for each(var xml:XML in data.image.(@type == "dimian")){
					var btn:Button = new Button(133,35,30,index*45);
					var fileName:String = xml.attribute("name").toString();
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
		
		private var zoomContainer:Sprite = new Sprite();
		private var zoomScroller:Scroller = new Scroller(1024,715);
		private var zoomImage:Image = new Image();
		private var closeZoomBtn:Button = new Button(100,50,800,700);
		
		private var animeBtn:Button = new Button(100,50,500,700);
		private var video:VideoContainer = new VideoContainer();
		
		private var hotPointDic:Dictionary = new Dictionary();//存储热点	
		private var hotPointPosDic:Dictionary = new Dictionary();//存储热点	
		private var hotPointXmlDic:Dictionary = new Dictionary();//存储热点的对应xml		
		private var appearPointDic:Dictionary = new Dictionary();//存储根据图片决定是否显示的热点
		private var addToOrderBtn:Image = new Image(Main.basePath + "img/addtoorder.png");
		private var sharedObject:SharedObject;
		private var biaojied:Boolean = false;
		private function createHotPoint():void{
			closeZoomBtn.buttonSource = [Main.basePath + "img/close.png"];
			animeBtn.buttonSource = [Main.basePath + "img/anime.png"];
			for each(var xml:XML in data.hotpoint){
				var p:pointMc = createPointMc();
				
				var xStr:String = xml.attribute("x").toString();
				if(xStr.indexOf("*") == -1){
					p.x = Number(xStr);
				}else{
					p.x = Number(xStr.split("*")[0])*Number(xStr.split("*")[1]);
				}
				var yStr:String = xml.attribute("y").toString();
				if(yStr.indexOf("*") == -1){
					p.y = Number(yStr);
				}else{
					p.y = Number(yStr.split("*")[0])*Number(yStr.split("*")[1]);
				}	
				p.name = xml.attribute("name").toString();
				hotPointXmlDic[p.name] = xml;
				p.addEventListener(MouseEvent.CLICK,onHotPointClick);
				hotPointDic[p.name] = p;
				hotPointPosDic[p.name] = new Point(p.x,p.y);
				if(xml.hasOwnProperty("@appear")){
					appearPointDic[p.name] = xml.attribute("appear").toString().split(",");
					p.addEventListener(CHANGE,onBaseImageChange);
					p.dispatchEvent(new Event(CHANGE));
				}
				addChild(p);
			}
			zoomContainer.visible = false;
			zoomContainer.graphics.beginFill(0,.6);
			zoomContainer.graphics.drawRect(0,0,Common.MAX_WIDTH,Common.MAX_HEIGHT);
			zoomContainer.graphics.endFill();
			addChild(zoomContainer);
			//			zoomImage.x = 115;
			//			zoomImage.y = 25;
			zoomScroller.y = 24;
			zoomContainer.addChild(zoomScroller);
			zoomScroller.addChild(zoomImage);
			video.y = 24;
			zoomContainer.addChild(video);
			closeZoomBtn.x = 965;
			closeZoomBtn.y = 24;
			zoomContainer.addChild(closeZoomBtn);
			
			animeBtn.x = 20;
			animeBtn.y = 708;
			zoomContainer.addChild(animeBtn);
			
			
			biaojiBtn.x = 944;
			biaojiBtn.y = 708;
			zoomContainer.addChild(biaojiBtn);
			addToOrderBtn.x = 564+250;
			addToOrderBtn.y = 708;
			zoomContainer.addChild(addToOrderBtn);
			biaojiLabel.x = 447;
			biaojiLabel.y = 334;
			biaojiLabel.color = "0xFF0000";
			biaojiLabel.size = "20";
			//biaojiLabel.text = "已标记";
			biaojiLabel.visible = false;
			zoomContainer.addChild(biaojiLabel);
			
			quxiaobiaojiLabel.x = 447;
			quxiaobiaojiLabel.y = 334;
			quxiaobiaojiLabel.color = "0xFF0000";
			quxiaobiaojiLabel.size = "20";
			//quxiaobiaojiLabel.text = "已取消标记";
			quxiaobiaojiLabel.visible = false;
			zoomContainer.addChild(quxiaobiaojiLabel);
			
			addtoorderLabel.x = 447;
			addtoorderLabel.y = 334;
			addtoorderLabel.color = "0xFF0000";
			addtoorderLabel.size = "20";
			addtoorderLabel.visible = false;
			zoomContainer.addChild(addtoorderLabel);
			
			soldOutlabel.x = 100;
			soldOutlabel.y = yindex-100;
			soldOutlabel.color = "0xFF0000";
			soldOutlabel.size = "20";
			soldOutlabel.visible = false;
			addChild(soldOutlabel);
			sharedObject = SharedObject.getLocal("product");
			if(sharedObject.data.array == null||sharedObject.data.array == undefined){
				sharedObject.data.array = new Array();
				sharedObject.flush();
			}	
			
			addToOrderBtn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{		
				var img:Image = getImageByName(currentPMC.name);
				if(img == null){
					img = getImageByName(hotPointXmlDic[currentPMC.name].attribute("relatedTo").toString());
				}
				var idx:String = new File(img.sourceURL).name.split(".")[0];
				var proData:XML = productInfoData.product.(@name == currentPMC.name).(@id == idx)[0];
				if(orderInfoDic[FenggeSelectPage.currentPath+"_"+kongjian] == null){
					orderInfoDic[FenggeSelectPage.currentPath+"_"+kongjian] = new Dictionary();
				}
				orderInfoDic[FenggeSelectPage.currentPath+"_"+kongjian][currentPMC.name] = proData;
				addtoorderLabel.visible = true;
				setTimeout(function(){addtoorderLabel.visible = false},1000);
			});
			
			biaojiBtn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				if(biaojied){
					sharedObject = SharedObject.getLocal("product");
					var array:Array = sharedObject.data.array;
					array.splice(array.indexOf(zoomImage.sourceURL),1);
					sharedObject.flush();
					quxiaobiaojiLabel.visible = true;
					biaojiBtn.source = Main.basePath + "img/biaoji.png";
					biaojied = !biaojied;
					setTimeout(function(){quxiaobiaojiLabel.visible = false},1000);
				}else{
					sharedObject = SharedObject.getLocal("product");
					var array:Array = sharedObject.data.array;
					array.push(zoomImage.sourceURL);
					sharedObject.flush();
					biaojiLabel.visible = true;
					biaojiBtn.source = Main.basePath + "img/quxiaobiaoji.png";
					biaojied = !biaojied;
					setTimeout(function(){biaojiLabel.visible = false},1000);
					
				}
				
			});
			closeZoomBtn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				zoomContainer.visible = false;
				right.visible = true;
				downBack.visible = true;
			});
			zoomContainer.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				if(e.target == zoomContainer){
					zoomContainer.visible = false;
					right.visible = true;
					downBack.visible = true;
				}				
			});
			animeBtn.addEventListener(MouseEvent.CLICK,playAnime);
			video.visible = false;
			video.addEventListener(VideoContainer.COMPLETE,onPlayEnd);
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
			zoomContainer.visible = true;
			right.visible = false;
			downBack.visible = false;
			var pName:String = e.currentTarget.name;
			var imagePath:String = "";
			var xml:XML = hotPointXmlDic[pName];
			currentPMC = e.currentTarget as pointMc;
			if(xml.attribute("type").toString() == "solid"){
				imagePath = path_1 + "zoomout/" + pName + "/" +pName+ ".jpg";
				zoomImage.source = imagePath;
				animePath = imagePath.replace(".png",".flv");
				animeBtn.visible = new File(animePath).exists;
				sharedObject = SharedObject.getLocal("product");
				var array:Array = sharedObject.data.array;
				if(array.indexOf(imagePath)==-1){
					biaojied = false;
					biaojiBtn.source = Main.basePath + "img/biaoji.png";
				}else{
					biaojied = true;
					biaojiBtn.source = Main.basePath + "img/quxiaobiaoji.png";
				}
				return;
			}
			if(!xml.hasOwnProperty("@relatedTo")){
				imagePath = path_1 + "zoomout/" + pName + "/" + getImageByName(pName).info.fileName;
				zoomImage.source = imagePath;
				animePath = imagePath.replace(".png",".flv");
				animeBtn.visible = new File(animePath).exists;
				sharedObject = SharedObject.getLocal("product");
				var array:Array = sharedObject.data.array;
				if(array.indexOf(imagePath)==-1){
					biaojied = false;
					biaojiBtn.source = Main.basePath + "img/biaoji.png";
				}else{
					biaojied = true;
					biaojiBtn.source = Main.basePath + "img/quxiaobiaoji.png";
				}
				return;
			}
			var image:Image;
			var xml1:XML;
			for (var j:int = 0; j < data.image.length(); j++) 
			{
				xml1 = data.image[j];
				image = getImageByName(pName);
				if(image == null)
					break;
				if(image.info.name == xml1.attribute("name").toString()){
					imagePath = path_1 + "zoomout/" + pName + "/" + getImageByName(pName).info.fileName;
					zoomImage.source = imagePath;
					animePath = imagePath.replace(".png",".flv");
					animeBtn.visible = new File(animePath).exists;
					sharedObject = SharedObject.getLocal("product");
					var array:Array = sharedObject.data.array;
					if(array.indexOf(imagePath)==-1){
						biaojied = false;
						biaojiBtn.source = Main.basePath + "img/biaoji.png";
					}else{
						biaojied = true;
						biaojiBtn.source = Main.basePath + "img/quxiaobiaoji.png";
					}
					return;
				}
			}
			
			imagePath = path_1 + "zoomout/" + pName + "/" + getImageByName(xml.attribute("relatedTo").toString()).info.fileName;
			animePath = imagePath.replace(".png",".flv");
			animeBtn.visible = new File(animePath).exists;
			zoomImage.source = imagePath;
			sharedObject = SharedObject.getLocal("product");
			var array:Array = sharedObject.data.array;
			if(array.indexOf(imagePath)==-1){
				biaojied = false;
				biaojiBtn.source = Main.basePath + "img/biaoji.png";
			}else{
				biaojied = true;
				biaojiBtn.source = Main.basePath + "img/quxiaobiaoji.png";
			}
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
				for(var key:String in orderInfoDic){
					var array:Array = sharedObject.data.array;
					var list:Dictionary = orderInfoDic[key];
					var label:Label = new Label(Main.yangbanjianNameInfo.yangbanjian.(@id == key.split("_")[1])[0].attribute("name").toString());
					label.size = 12;
					label.x = 480;
					label.y = i*50;
					i++;
					sp.addChild(label);
					for(var innerKey:String in list){
						var xml1:XML = list[innerKey];
						if(key == FenggeSelectPage.currentPath+"_"+kongjian){
							var xml:XML = hotPointXmlDic[innerKey];
							var soldOut:Boolean = false;
							if(!xml.hasOwnProperty("@relatedTo")){
								var imagePath:String = path_1 + "zoomout/" + innerKey + "/" + getImageByName(innerKey).info.fileName;						
								sharedObject = SharedObject.getLocal("product");
								
								if(array.indexOf(imagePath)==-1){
									soldOut = false;
									xml1.@soldout = "false";
								}else{
									soldOut = true;
									xml1.@soldout = "true";
								}
							}else{
								var imagePath:String = path_1 + "zoomout/" + innerKey + "/" + getImageByName(xml.attribute("relatedTo").toString()).info.fileName;						
								sharedObject = SharedObject.getLocal("product");
								if(array.indexOf(imagePath)==-1){
									soldOut = false;
									xml1.@soldout = "false";
								}else{
									soldOut = true;
									xml1.@soldout = "true";
								}
							}
						}else{
							if(xml1.hasOwnProperty("@soldout")){
								soldOut = xml1.attribute("soldout").toString() == "true";
							}else{
								soldOut = false;
							}
						}					
						var info:ProductInfo = new ProductInfo(xml1,innerKey,soldOut,"save");
						info.x = 100;
						info.y = i*50;
						i++;
						sp.addChild(info);
					}
				}
				
				
				
				
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
			for each(var b:Button in btnScroller.btnArr){
				b.selected = false;
			}
			e.currentTarget.selected = true;
			var currentDir:String = e.currentTarget.name;
			rightScroller.scroller.clearContent();
			//			if(products[currentDir].parent != null){
			//				for(var i:int = selectableImageContainer.numChildren-1;i>=0;i--){
			//					var img:Image = selectableImageContainer.getChildAt(i) as Image;
			//					if(img.info.name == products[currentDir].parent){
			//						currentDir = currentDir + "/" + (img.info.fileName.split(".",1))[0];
			//						break;
			//					}
			//				}
			//			}
			var fileDir:File = new File(path + "thumb/" + currentDir);
			var arr:Array = new Array();
			var arr1:Array = new Array();
			for each(var file:File in fileDir.getDirectoryListing()){
				if(!file.isDirectory){
					arr1.push(file);
					arr.push(file.url);
				}		
			}
			rightScroller.dataSource(arr,140,15,onRightGuitiThumbClick);
			for(var index:int = 0;index<rightScroller.scroller.btnArr.length;index++){
				(rightScroller.scroller.btnArr[index] as ImageButton).info = arr1[index];
				(rightScroller.scroller.btnArr[index] as ImageButton).name = e.currentTarget.name
			}
		}
		private var soldOutlabel:Label = new Label("该商品已售完");
		private function onRightGuitiThumbClick(e:MouseEvent):void{
			var currentChangeImg:Image;
			for(var i:int = selectableImageContainer.numChildren-1;i>=0;i--){
				var img:Image = selectableImageContainer.getChildAt(i) as Image;
				if(img.info.name == e.currentTarget.name){
					currentChangeImg = img;
					break;
				}
			}
			if(currentChangeImg == null)return;
			var ts:String = (e.currentTarget.info as File).url.replace("thumb","bigImg").replace("jpg","png");
			
			eventAccept = false;
			TweenLite.to(currentChangeImg,.4,{alpha:0,onComplete:function():void{
				currentChangeImg.addEventListener(Image.GET_DATA,onGetData);
				if(currentChangeImg.sourceURL == ts){
					currentChangeImg.dispatchEvent(new Event(Image.GET_DATA));
					return;
				}
				currentChangeImg.source = ts;
				sharedObject = SharedObject.getLocal("product");
				var array:Array = sharedObject.data.array;
				if(array.indexOf(ts.replace("bigImg","zoomout"))!=-1){
					
					soldOutlabel.visible = true;
					setTimeout(function(){soldOutlabel.visible = false},1000);
				}
			}});
			
			var image:Image;
			var xml:XML;
			for (var j:int = 0; j < data.image.length(); j++) 
			{
				xml = data.image[j];
				if(xml.attribute("relatedTo").toString() == e.currentTarget.name){
					if(xml.hasOwnProperty("@disappear")){
						var tempImage:Image = currentChangeImg;
						var names:Array = xml.attribute("disappear").toString().split(",");
						for each(var tempName:String in names){
							if(tempName == e.currentTarget.info.name.split(".jpg")[0]){
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
			
			//currentChangeImg.source = ts;
			currentChangeImg.info.fileName = (e.currentTarget.info as File).name.replace("jpg","png");
			//			if(products[e.currentTarget.name].child != null){
			//				var temp:Image;
			//				for(var i:int = selectableImageContainer.numChildren-1;i>=0;i--){
			//					var img:Image = selectableImageContainer.getChildAt(i) as Image;
			//					if(img.info.name == products[e.currentTarget.name].child){
			//						temp = img;
			//						break;
			//					}
			//				}
			//				var ss:File = new File(path + "bigImg/" + products[e.currentTarget.name].child +"/"+ ((e.currentTarget.info as File).name.split(".",1))[0]);
			//
			//				temp.source = ss.getDirectoryListing()[0].url;
			//				temp.info.fileName = ss.getDirectoryListing()[0].name;
			//			}
			for each(var p:pointMc in hotPointDic){
				p.dispatchEvent(new Event(CHANGE));
			}
		}
		
		private function onGetData(e:Event):void{
			e.currentTarget.alpha = 1;
			e.currentTarget.removeEventListener(Image.GET_DATA,onGetData);
			eventAccept = true;
		}
		
		//创建产品图片
		private function createImages():void{
			if(initInfo == null){
				for each(var xml:XML in data.image){
					var img:Image = new Image(path + "bigImg/" + xml.attribute("name").toString() + "/"+ xml.attribute("source").toString());
					img.info = {name:xml.attribute("name").toString(),fileName:xml.attribute("source").toString()};
					selectableImageContainer.addChild(img);
					img.addEventListener(CHANGE,onChange);
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
			else{
				for each(var xml:XML in data.image){
					var img:Image = new Image();
					img.source = path + "bigImg/" + xml.attribute("name").toString() + "/"+ initInfo[xml.attribute("name").toString()];
					img.info = {name:xml.attribute("name").toString(),fileName:initInfo[xml.attribute("name").toString()]};
					selectableImageContainer.addChild(img);
					img.addEventListener(CHANGE,onChange);
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
			//			if(products[currentDir].parent != null){
			//				if(getImageByName(products[currentDir].parent)){
			//					currentDir = currentDir + "/" + getImageByName(products[currentDir].parent).info.fileName.split(".",1)[0];
			//				}
			//				
			//			}
			var fileDir:File = new File(path + "bigImg/" + currentDir);
			var flag:Boolean = false;
			var temp:File = fileDir.getDirectoryListing()[0];
			for each(var file:File in fileDir.getDirectoryListing()){
				if(!file.isDirectory&&(file.name.split(".")[1] =="png"||file.name.split(".")[1] =="jpg")){
					if(flag){
						temp = file;
						break;
					}
					if(img.info.fileName == file.name){
						flag = true;
					}
				}		
			}
			
			img.info.fileName = temp.name;
			eventAccept = false;
			TweenLite.to(img,.4,{alpha:0,onComplete:function():void{
				img.addEventListener(Image.GET_DATA,onGetData);
				if(img.sourceURL == temp.url){
					img.dispatchEvent(new Event(Image.GET_DATA));
					return;
				}
				img.source = temp.url;
				sharedObject = SharedObject.getLocal("product");
				var array:Array = sharedObject.data.array;
				if(array.indexOf(temp.url.replace("bigImg","zoomout"))!=-1){
					soldOutlabel.visible = true;
					setTimeout(function(){soldOutlabel.visible = false},1000);
				}
				
			}});
			
			//			if(products[e.currentTarget.info.name].child != null){
			//				var tempImg:Image;
			//				for(var i:int = selectableImageContainer.numChildren-1;i>=0;i--){
			//					var img:Image = selectableImageContainer.getChildAt(i) as Image;
			//					if(img.info.name == products[e.currentTarget.info.name].child){
			//						tempImg = img;
			//						break;
			//					}
			//				}
			//				var ss:File = new File(path + "bigImg/" + products[e.currentTarget.info.name].child +"/"+ (e.currentTarget.info.fileName.split(".",1))[0]);
			//				tempImg.source = ss.getDirectoryListing()[0].url;
			//				tempImg.info.fileName = ss.getDirectoryListing()[0].name;
			//			}
			
			
			
			var image:Image;
			var xml:XML;
			for (var j:int = 0; j < data.image.length(); j++) 
			{
				xml = data.image[j];
				if(xml.attribute("relatedTo").toString() == img.info.name){
					if(xml.hasOwnProperty("@disappear")){
						var tempImage:Image = img;
						var names:Array = xml.attribute("disappear").toString().split(",");
						for each(var tempName:String in names){
							if(tempName == img.info.fileName.split(".")[0]){
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
		
		private function initRightScroller():void{
			
			right.x = 1024-190;
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
			if(right.x <=855){
				TweenLite.to(right,.6,{x:1024});
			}else{
				TweenLite.to(right,.6,{x:(1024-185)});
			}
		}
		
		
	}
}












