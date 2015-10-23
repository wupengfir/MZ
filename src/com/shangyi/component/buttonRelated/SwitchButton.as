package com.shangyi.component.buttonRelated
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SwitchButton extends Sprite
	{
		
		private var drawer:Sprite = new Sprite();
		private var _selected:Boolean = false;
		public function SwitchButton(sel:Boolean)
		{
			addChild(drawer);
			_selected = sel;
			if(_selected){
				drawSelected();
			}else{
				drawNormal();
			}
			
			drawer.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function drawNormal():void{
			var g:Graphics = drawer.graphics;
			g.clear();
			g.lineStyle(2,0xffffff);
			g.drawRoundRect(0,0,60,40,32);
			g.beginFill(0xffffff,0);
			g.drawRoundRect(1,1,58,38,32);
			g.endFill();
			g.beginFill(0xffffff,1);
			g.drawCircle(20,20,20);
			g.endFill();
		}
		
		private function drawSelected():void{
			var g:Graphics = drawer.graphics;
			g.clear();
			g.lineStyle(2,0xffffff);
			g.drawRoundRect(0,0,60,40,32);
			g.beginFill(0xffffff,.6);
			g.drawRoundRect(1,1,58,38,32);
			g.beginFill(0xffffff,1);
			g.drawCircle(40,20,20);
			g.endFill();
		}
		
		private function onClick(e:MouseEvent):void{
			if(_selected){
				_selected = false;
				drawNormal();
			}else{
				_selected = true;
				drawSelected();
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get selected():Boolean{
			return _selected;
		}
		
	}
}