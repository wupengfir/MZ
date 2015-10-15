package page.homepages
{
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	import com.shangyi.component.scrollerRelated.SY_Scroller;
	
	import flash.text.TextField;
	
	public class DownloadPage extends Page
	{
		
		public var labelName:Label = new Label("",20);
		public var imageLogo:Image = new Image();
		public var labelNeirong:Label = new Label("",20);
		public var labelNeirongText:Label = new Label("",20);
		public var scroller:SY_Scroller = new SY_Scroller(580,200,570,200,0xffffff,0,false);
		
		private var ps:XML = 
			<root>
				<object name="labelName" x="230" y="20"/>
				<object name="imageLogo" x="20" y="20"/>
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
			
			imageLogo.width = 180;
			imageLogo.height = 100;
			labelNeirongText.width = 600;
			labelNeirongText.height = 400;
			labelNeirongText.textField.wordWrap = true;
		}
		
		public function showData(data:Object):void{
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




















