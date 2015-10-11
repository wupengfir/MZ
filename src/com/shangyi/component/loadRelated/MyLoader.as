package com.shangyi.component.loadRelated
{
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class MyLoader extends Loader
	{
		
		public var urlString:String;
		
		override public function load(url:URLRequest,context:LoaderContext = null):*{
			this.urlString = url.url;
			super.load(url,context);
		}
		
		
		
		public function MyLoader()
		{
		}
	}
}