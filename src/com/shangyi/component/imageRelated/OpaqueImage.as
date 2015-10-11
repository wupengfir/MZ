package com.shangyi.component.imageRelated
{
	import com.shangyi.component.loadRelated.SY_ImageLoader;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class OpaqueImage extends Image
	{
		public function OpaqueImage()
		{
			
		}
		
		override public function loadSource(source:String):void{
			this.sourceURL = source;
			var dic:Dictionary = Image.imageDic;
			if(Image.imageDic[source] != null){
				var data:BitmapData = Image.imageDic[source];
				graphics.beginBitmapFill(data);
				for(var i:int = 0;i<data.width;i++){
					for(var j:int = 0;j<data.height;j++){
						var color:uint = data.getPixel32(i,j);
						if(color>>24 != 0){
							graphics.drawRect(i,j,1,1);
						}
					}
				}
				graphics.endFill();				
				if(_width != 0){
					this.width = _width;
				}
				if(_height != 0){
					this.height = _height;
				}
				selected = _selected;
				loading = false;
				dispatchEvent(new Event(GET_DATA));
				if(sourceUrlArray.length > 0){
					if(imageUseDic[this.sourceURL]){
						imageUseDic[this.sourceURL]--;
						if(imageUseDic[this.sourceURL] == 0){
							delete Image.imageDic[this.sourceURL];
							delete Image.imageUseDic[this.sourceURL]
							if(back.bitmapData){
								back.bitmapData.dispose();
							}
						}
					}
					this.source = sourceUrlArray[sourceUrlArray.length - 1]
				}
			}
			else{
				var load:SY_ImageLoader = new SY_ImageLoader();
				load.load(source,this);
				loading = true;
			}
		}
		
	}
}