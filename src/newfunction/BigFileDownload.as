package newfunction
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	public class BigFileDownload extends EventDispatcher
	{
		private var contentLength:int;
		private var startpos:int = 0;
		public var endpos:int = 0;
		private var file:File;
		private var fst:FileStream = new FileStream();
		private var path:String;// = "http://220.166.63.50:8080/furniture/data/mzchunjing/904a7e8e-d3e7-4b19-80fc-e9572af87017.zip";
		private var nativePath:String;
		private var root:BigFileDownload;
		public function BigFileDownload(nativePath:String,path:String)
		{
			root = this;
			this.path = path;
			this.nativePath = nativePath;
			var getContentLengthRequest:URLRequest = new URLRequest(path);
			var getContentLengthLoader:URLLoader = new URLLoader();
			getContentLengthLoader.addEventListener(ProgressEvent.PROGRESS ,function(e:ProgressEvent):void {
				contentLength = getContentLengthLoader.bytesTotal;//得到文件的真实尺寸
				getContentLengthLoader.close();//停止下载
				trace(contentLength);
				downloadByRange();//按照断点续传的方式下载
			});
			getContentLengthLoader.load(getContentLengthRequest);
			file = new File(File.applicationDirectory.resolvePath(nativePath).nativePath);
			if(file.exists){
				file.deleteFile();
			}
		}
		private var firstCheck:Boolean = false;
		private function downloadByRange():void{
			file = new File(File.applicationDirectory.resolvePath(nativePath).nativePath);
			if(file.exists){
				fst.open(file,FileMode.READ);
				startpos = fst.bytesAvailable;
				fst.close();
			}
			endpos = startpos + 1024*1024;
			if(endpos > contentLength - 1){
				endpos = contentLength - 1;
			}
			var rangeRequest:URLRequest = new URLRequest(path);
			var header:URLRequestHeader = new URLRequestHeader("Range", "bytes="+startpos+"-"+endpos);//注意这里很关键，我们在请求的Header里包含对Range的描述，这样服务器会返回文件的某个部分
			rangeRequest.requestHeaders.push(header);//将头信息添加到请求里
			var loader:URLLoader = new URLLoader();
			loader.dataFormat=URLLoaderDataFormat.BINARY;
			loader.load(rangeRequest);
			loader.addEventListener(Event.COMPLETE,writefile);
			
			
			

		}
		
		private function writefile(e:Event):void{
			var bytes:ByteArray = e.target.data as ByteArray;
			fst = new FileStream();
			if(!file.exists){
				fst = new FileStream();
				fst.open(file,FileMode.WRITE);
				fst.writeBytes(bytes);
				fst.close();
			}else{
				fst.open(file, FileMode.UPDATE);
				fst.position = fst.bytesAvailable;//将指针指向文件尾
				fst.writeBytes(bytes, 0, bytes.length);//在文件中写入新下载的数据
				fst.close();//关闭文件流
			}
			//test.text.text += endpos+"\n";
			if(endpos < (contentLength - 1)){
				root.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
				downloadByRange();
			}else{
//				test.text.text += "completeload\n";
//				setTimeout(function():void{
//					new UnZip(nativePath);
//				},2000);
				root.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
	}
}