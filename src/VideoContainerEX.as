package
{
	import com.shangyi.component.base.Page;
	
	import flash.events.Event;
	import flash.filesystem.File;
	
	import newfunction.BigFileDownload;
	
	public class VideoContainerEX extends Page
	{
		
		private var video:VideoContainer = new VideoContainer();
		private var down:BigFileDownload;
		public function VideoContainerEX()
		{
			addChild(video);
		}
		
		public function play(path:String):void{
//			var file:File = new File(File.applicationDirectory.resolvePath("data/temp/1.mp4").nativePath);
//			if(file.exists){
//				file.deleteFile();
//			}
			down = new BigFileDownload("data/temp/1.mp4",path);
			down.addEventListener(BigFileDownload.DATA_GOT,startPlay);
			down.addEventListener(BigFileDownload.DATA_JUST_GOT,change);
		}
		
		private function change(e:Event):void{
			down.continueLoad = false;
		}
		
		private function startPlay(e:Event):void{
			video.playSt("data/temp/1.mp4");
		}
		
		
	}
}