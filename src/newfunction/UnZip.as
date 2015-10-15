package newfunction
{
	import deng.fzip.FZip;
	import deng.fzip.FZipErrorEvent;
	import deng.fzip.FZipEvent;
	import deng.fzip.FZipFile;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;

	public class UnZip
	{
		private var fst:FileStream = new FileStream();
		private var root:File;
		private var path:String;
		private var num:uint = 0;
		private var total:uint = 0;
		var zip:FZip = new FZip();
		public function UnZip(path:String)
		{
			this.path = path;
			root = new File(path).parent;
			YourApp();
		}
		
		public function YourApp() {
			fst.open(new File(path),FileMode.READ);
			total = fst.bytesAvailable;
			fst.close();
			var request:URLRequest = new URLRequest(path);		
			zip.addEventListener(Event.OPEN, onZipOpen);
			zip.addEventListener(FZipEvent.FILE_LOADED, fileCompleteHandler);
			zip.addEventListener(FZipErrorEvent.PARSE_ERROR,onError);
			zip.addEventListener(Event.COMPLETE, zipCompleteHandler);
			zip.load(request);
			
			test.text.text += "总数"+total+"\n"
		}
		
		private function onError(e:FZipErrorEvent):void{
			test.text.text += e.toString();
		}
		
		private function onZipOpen(evt:Event):void {
			test.text.text +="opened\n";
			//total = zip.getFileCount();
		}
		
		private function fileCompleteHandler(evt:FZipEvent):void {
			var file:FZipFile = evt.file;
			if(file.sizeUncompressed>0){
				fst.open(new File(root.nativePath+"/"+file.filename),FileMode.WRITE);
				fst.writeBytes(file.content);
				fst.close();

			}
			num+=file.sizeCompressed;
			test.text.text +=(num/total*100+"%\n");
//			
//			trace("File loaded: " + file.filename);
//			trace("  " + file.sizeCompressed);
//			trace("  " + file.sizeUncompressed);
		}
		
		private function zipCompleteHandler(evt:Event):void {
			test.text.text += ("100% comlpete"+zip.getFileCount());
			new File(path).deleteFile();
		}
	}
}