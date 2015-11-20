package newfunction
{
	import deng.fzip.FZip;
	import deng.fzip.FZipErrorEvent;
	import deng.fzip.FZipEvent;
	import deng.fzip.FZipFile;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import page.alertpage.Alert;

	public class UnZip extends EventDispatcher
	{
		private var fst:FileStream = new FileStream();
		private var root:File;
		private var path:String;
		private var num:uint = 0;
		private var total:uint = 0;
		public var progress:String;
		var zip:FZip = new FZip();
		public function UnZip(path:String)
		{
			this.path = path;
			root = new File(path).parent;
//			if(root.exists){
//				Alert.alert("you",5);
//			}
			
			YourApp();
		}
		
		public function YourApp() {
			fst.open(new File(path),FileMode.READ);
			total = fst.bytesAvailable;
			fst.close();
			var request:URLRequest = new URLRequest(new File(path).url);		
			zip.addEventListener(Event.OPEN, onZipOpen);
			zip.addEventListener(FZipEvent.FILE_LOADED, fileCompleteHandler);
			zip.addEventListener(FZipErrorEvent.PARSE_ERROR,onError);
			zip.addEventListener(Event.COMPLETE, zipCompleteHandler);
			zip.load(request);
			
			//Alert.alert(total.toString());
		}
		
		private function onError(e:FZipErrorEvent):void{
			//Alert.alert(e.text);
		}
		
		private function onZipOpen(evt:Event):void {
			//Alert.alert("开始载入");
		}
		
		private function fileCompleteHandler(evt:FZipEvent):void {
			//Alert.alert("载入完成");
			var file:FZipFile = evt.file;
			if(file.sizeUncompressed>0){
				//fst.open(new File(root.nativePath+"/"+file.filename),FileMode.WRITE);
				fst.open(root.resolvePath(file.filename),FileMode.WRITE);
				fst.writeBytes(file.content);
				fst.close();

			}
			num+=file.sizeCompressed;
			progress =Number(num/total*100).toFixed(2)+"%";
			trace(progress+"progress!!!");
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
		}
		
		private function zipCompleteHandler(evt:Event):void {
			//test.text.text += ("100% comlpete"+zip.getFileCount());
			dispatchEvent(new Event(Event.COMPLETE));
			try{
				new File(path).deleteFile();
			}catch(e:Error){
				setTimeout(function():void{
					new File(path).deleteFile();
				},1000);
				trace(e.message);
			}
			//Alert.alert("完成解压");
		}
	}
}