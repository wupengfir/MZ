package user
{
	import com.greensock.TweenLite;
	import com.shangyi.component.base.Page;
	import com.shangyi.component.imageRelated.Image;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	public class UserHelpPage extends Page
	{
		private var num:int = 0;
		private var index:int = 1;
		private var container:Sprite = new Sprite();
		private var btn:Image = new Image("data/img/arrow.png");
		public function UserHelpPage()
		{
			addChild(container);
			num = new File(File.applicationDirectory.resolvePath("data/img/guide").nativePath).getDirectoryListing().length;
			for(var i:int = 1;i<=num;i++){
				var img:Image = new Image("data/img/guide/guide0"+i+".png");
				img.x = 1200*(i-1);
				container.addChild(img);
			}
			btn.x = 1140;
			btn.y = 600;
			addChild(btn);
			btn.addEventListener(MouseEvent.CLICK,onClick);
		}
		private var flag:Boolean = true;
		private function onClick(e:MouseEvent):void{
			if(index == num){
				this.visible = false;
			}
			if(flag){
				flag = false;
				TweenLite.to(container,1,{x:-1200*index,onComplete:function(){
					flag = true;
				}});
				index++;
			}
			
		}
		
	}
}









