package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Label extends Sprite
	{
		private var _text:String = "";
		public var textField:TextField = new TextField();
		private var textFormat:TextFormat = new TextFormat();
		public function Label(_text:String = "",s:Number = 14)
		{
			this._text = _text;
			addChild(textField);
			textField.text = _text;
			this.size = s;
			textField.selectable = false;
			textField.wordWrap = true;
//			textField.setTextFormat(textFormat);
			this.font = "simHei";
		}
		
		override public function set width(_width:Number):void{
			textField.width = _width;
		}
		
		override public function set height(_height:Number):void{
			textField.height = _height;
		}
		
		public function set textWidth(i:int):void{
			textField.width = i;
		}
		
		public function set text(_text:String):void{
			this._text = _text;
			textField.text = _text;
			textField.setTextFormat(textFormat);
		}
		
		public function get text():String{
			return _text;
		}
		
		public function set size(_size:Object):void{
			textFormat.size = _size;
			textField.setTextFormat(textFormat);
		}
		
		public function set font(_font:String):void{
			textFormat.font = _font;
			textField.setTextFormat(textFormat);
		}
		
		public function set color(_color:Object):void{
			textFormat.color = _color;
			textField.setTextFormat(textFormat);
		}
		
		public function set center(_center:Boolean):void{
			if(_center){
				textField.autoSize = TextFieldAutoSize.CENTER;
			}else{
				textField.autoSize = TextFieldAutoSize.LEFT;
			}
		}
//		public function set left(_left:Boolean):void{
//			if(_left){
//				textField.autoSize = TextFieldAutoSize.CENTER;
//			}else{
//				textField.autoSize = TextFieldAutoSize.LEFT;
//			}
//		}
		
	}
}