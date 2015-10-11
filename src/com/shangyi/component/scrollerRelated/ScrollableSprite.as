package com.shangyi.component.scrollerRelated
{
	import com.greensock.easing.EaseLookup;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ScrollableSprite extends Sprite
	{
		public static const TYPE_HOR:int = 0;
		public static const TYPE_VER:int = 1;
		
		private var type:int;		
		private var fullScreen:Boolean = false;
		
		private var currentX:Number = 0;
		private var currentMouseX:Number = 0;
		private var currentY:Number = 0;
		private var currentMouseY:Number = 0;
		private var down:Boolean = false;
		
		private var eventAcceptAble:Boolean = true;
		public function ScrollableSprite(type:int = 0,fullScreen:Boolean = false)
		{
			this.type = type;
			this.fullScreen = fullScreen;
			addEventListener(Event.ADDED_TO_STAGE,function(e:Event):void{
				init();
			});		
			addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				if(!eventAcceptAble){
					e.stopPropagation();
				}
			},true);
		}
		
		private function onDown(e:MouseEvent):void{
			eventAcceptAble = true;
			if(stage){
				down = true;
				currentX = this.x;
				currentMouseX = stage.mouseX;
				currentY = this.y;
				currentMouseY = stage.mouseY;	
			}		
		}
		var temp:Number;
		private function onMove(e:MouseEvent):void{
			if(down){				
				if(type == TYPE_HOR){
					temp = x;
					x = stage.mouseX - currentMouseX + currentX;	
					if(x>0||x < (1024 - this.width)){
						x = temp;
					}
					if(Math.abs(stage.mouseX - currentMouseX)>100){
						eventAcceptAble = false;
					}
				}
				if(type == TYPE_VER){
					temp = y;
					y = stage.mouseY - currentMouseY + currentY;	
					if(y>0||y < (768 - this.height)){
						y = temp;
					}
					if(Math.abs(stage.mouseY - currentMouseY)>100){
						eventAcceptAble = false;
					}
				}
			}	
		}
		
		private function init():void{
			if(fullScreen){
				stage.addEventListener(MouseEvent.MOUSE_DOWN,onDown);		
				stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);			
				stage.addEventListener(MouseEvent.MOUSE_UP,function(e:MouseEvent):void{
					down = false;
				});
			}else{
				addEventListener(MouseEvent.MOUSE_DOWN,onDown);		
				addEventListener(MouseEvent.MOUSE_MOVE,onMove);			
				addEventListener(MouseEvent.MOUSE_UP,function(e:MouseEvent):void{
					down = false;
				});
			}

		}
		
	}
}