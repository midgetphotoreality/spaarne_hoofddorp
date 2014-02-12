// nl.photoreality.map_editor.view.route.details.LabelPositionWidget
package nl.photoreality.map_editor.view.route.details 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2012
	 */
	public class LabelPositionWidget extends MovieClip
	{
		public static const POSITION_CHANGED	: String = "position_changed";
		
		
		public static const POSITION_UP		 	: String = "position_up";
		public static const POSITION_LEFT	 	: String = "position_left";
		public static const POSITION_DOWN	 	: String = "position_down";
		public static const POSITION_RIGHT	 	: String = "position_right";
		
		public var position_down				: MovieClip;
		public var position_right				: MovieClip;
		public var position_up					: MovieClip;
		public var position_left				: MovieClip;
		
		private var _position						: String;
		
		public function LabelPositionWidget() {
			_position = POSITION_DOWN;
			//setPosition(position);
			addListeners();
		}
		
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			trace("LabelPositionWidget -> addedToStageListener")
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
		}
		
		private function addListeners():void {
			position_down.buttonMode 		= position_down.useHandCursor = true;
			position_right.buttonMode 		= position_right.useHandCursor = true;
			position_up.buttonMode 			= position_up.useHandCursor = true;
			position_left.buttonMode 		= position_left.useHandCursor = true;
			
			position_down.addEventListener(MouseEvent.CLICK, handlePositionChange);
			position_right.addEventListener(MouseEvent.CLICK, handlePositionChange);
			position_up.addEventListener(MouseEvent.CLICK, handlePositionChange);
			position_left.addEventListener(MouseEvent.CLICK, handlePositionChange);
		}
		
		private function removeListeners():void {
			position_down.removeEventListener(MouseEvent.CLICK, handlePositionChange);
			position_right.removeEventListener(MouseEvent.CLICK, handlePositionChange);
			position_up.removeEventListener(MouseEvent.CLICK, handlePositionChange);
			position_left.removeEventListener(MouseEvent.CLICK, handlePositionChange);	
		}
		
		private function handlePositionChange(e:MouseEvent):void {
			setPosition(String(MovieClip(e.target).name));
		}
		
		public function setPosition(posConst:String):void {
			trace("LabelPositionWidget -> setPosition: "+posConst)
			deactivate(position_down);
			deactivate(position_right);
			deactivate(position_up);
			deactivate(position_left);
			activate(MovieClip(getChildByName(posConst)));
			_position = posConst;
			dispatchEvent(new Event(POSITION_CHANGED));
		}
		
		public function initPosition(posConst:String):void {
			trace("LabelPositionWidget -> initPosition: "+posConst)
			deactivate(position_down);
			deactivate(position_right);
			deactivate(position_up);
			deactivate(position_left);
			activate(MovieClip(getChildByName(posConst)));
			_position = posConst;
			//dispatchEvent(new Event(POSITION_CHANGED));
		}
		
		
		private function activate(mc:MovieClip):void {
			if (mc){
				var myColor:ColorTransform = mc.transform.colorTransform;
				myColor.color = 0x00FF00;
				mc.transform.colorTransform = myColor;
			}
		}
		
		private function deactivate(mc:MovieClip):void {
			if (mc){
				var myColor:ColorTransform = mc.transform.colorTransform;
				myColor.color = 0xFF0000;
				mc.transform.colorTransform = myColor;
			}
		}
		
		public function get position():String { return _position; }
	}

}