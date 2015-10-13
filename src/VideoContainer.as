package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class VideoContainer extends Sprite
	{
		private var sence:Video;
		private var nc:NetConnection;
		private var ns:NetStream;
		public static const COMPLETE:String = "complete";
		public static const START:String = "start";
		private var sourcep:String ="1.flv"
		private var tmpimage:Loader=new Loader 
		private var currentNeddImage:String ="img/move.jpg"
		
		private var textBox:TextField; 
		public function VideoContainer()
		{
			graphics.beginFill(0x00ffff,.5);
			graphics.drawRect(0,0,1200,900);
			graphics.endFill();
			textBox = new TextField();  
			textBox.autoSize = TextFieldAutoSize.CENTER;  
			textBox.multiline = true;  
			textBox.x = 100;  
			textBox.y = 250;  
			textBox.scaleX = textBox.scaleY = 3;
			this.addChild(textBox);  
			
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame); 
			addSence();
			
		}
		private function addSence():void
		{
			sence = new Video  ;
			//sence.smoothing =true
			sence.width = Common.MAX_WIDTH;
			sence.height = Common.MAX_HEIGHT;
			this.addChild(sence);
			initnet();
			//stopSt(currentNeddImage)
		}
		public  function stopSt(str:String):void{
			sourcep=str
			ns.play(sourcep);
			ns.pause ()
		}
		
		public function playSt(str:String):void{
			if(parent){
				parent.addChild(this);
			}else{
				return;
			}
			sourcep=str
			ns.play(sourcep);
			//this.setChildIndex (sence,this.numChildren -1)
			
		}
		
		public function restart():void{
			ns.resume ()
		}
		private function initnet():void
		{
			nc = new NetConnection  ;
			nc.connect(null); 
			ns = new NetStream(nc);
			ns.client = {};
			ns.client.onMetaData = ns_onMetaData;
			ns.addEventListener(NetStatusEvent.NET_STATUS,statusHandler);
			sence.attachNetStream(ns);
			
		}
		private function loadimage(path:String):void{
			tmpimage.load (new URLRequest (path))
			tmpimage.contentLoaderInfo .addEventListener (Event.COMPLETE ,loadimagecom)
			
		}
		private function loadimagecom(e:Event ):void{
			this.addChild (tmpimage)
			ns.play(sourcep);
			this.setChildIndex (sence,this.numChildren -1)
			dispatchEvent(new Event (START))
		}
		private function ns_onMetaData(item:Object):void {
		}
		private function statusHandler(event:NetStatusEvent):void
		{
			//trace(event.info.code)
			switch (event.info.code)
			{
				case "NetStream.Play.Start" : 
					break;
				case "NetStream.Play.Stop" :
					dispatchEvent(new Event(COMPLETE))
					break;
				case "NetStream.Buffer.Flush":
					break;
			}
			
		}
		
		private function onEnterFrame(event:Event):void  
		{  
			textBox.text = "";  
			textBox.appendText("酷播cuplayer缓冲区大小是："+ns.bufferTime+"\n");  
			textBox.appendText("已进入缓冲区的秒数："+ns.bufferLength+"\n");  
			textBox.appendText("已缓冲的百分比："+ Math.round((ns.bufferLength/ns.bufferTime)*100) +"%\n");  
			textBox.appendText("已下载的字节数："+ns.bytesLoaded+"\n");  
			textBox.appendText("酷播cuplayer总字节数："+ns.bytesTotal+"\n");  
			textBox.appendText("已下载的百分比："+ Math.round((ns.bytesLoaded/ns.bytesTotal)*100) +"%\n");  
		} 
		
	}
}