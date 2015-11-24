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
			g.drawRoundRect(0,10,50,25,25);
			g.beginFill(0xffffff,0);
			g.drawRoundRect(1,11,48,23,25);
			g.endFill();
			g.beginFill(0xffffff,1);
			g.drawCircle(13,22,10);
			g.endFill();
		}
		
		private function drawSelected():void{
			var g:Graphics = drawer.graphics;
			g.clear();
			g.lineStyle(2,0xffffff);
			g.drawRoundRect(0,10,50,25,25);
			g.beginFill(0xffffff,0.6);
			g.drawRoundRect(1,11,48,23,25);
			g.beginFill(0xffffff,1);
			g.drawCircle(37,22,10);
			g.endFill();
		}
		
		private function onClick(e:MouseEvent):void{
			e.stopImmediatePropagation();
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