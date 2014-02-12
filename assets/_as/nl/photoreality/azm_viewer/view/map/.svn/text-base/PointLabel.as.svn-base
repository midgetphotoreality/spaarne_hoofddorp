// nl.photoreality.online_viewer.view.map.PointLabel
package nl.photoreality.azm_viewer.view.map 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import nl.photoreality.map_editor.model.vo.PositionLabelVO;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2012
	 */
	public class PointLabel extends Sprite
	{
		public static const STYLE_START 		: String = "style_start";
		public static const STYLE_END 			: String = "style_end";
		
		public static const POSITION_UP		 	: String = "position_up";
		public static const POSITION_LEFT	 	: String = "position_left";
		public static const POSITION_DOWN	 	: String = "position_down";
		public static const POSITION_RIGHT	 	: String = "position_right";
		
		public var txt_label 					: TextField;
		private var _position					: String = POSITION_UP;
		private var _style						: String = STYLE_START;
		private var _pos:Point;
		private var _posLabel:PositionLabelVO;
		
		public function PointLabel() {
			trace ("PointLabel -> constructor")
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
		}
		
		private function addListeners():void {
		
		}
		
		private function removeListeners():void {
			
		}
		
		public function init( posLabel:PositionLabelVO, pos:Point ):void {
			_posLabel = posLabel;
			_pos = pos;
			txt_label.text = _posLabel.label;
			setPosition(_posLabel.position);
			//x = pos.x;
			//y = pos.y;
		}
		
		private function setStyle(styleConst:String):void {
			/*
			huidigeRoute.doel.tekst.border = true;
			huidigeRoute.doel.tekst.borderColor = 0xEAEAEA;
			huidigeRoute.doel.tekst.background = true;
			huidigeRoute.doel.tekst.backgroundColor = 0xEAEAEA;
			huidigeRoute.doel.tekst.autoSize = TextFieldAutoSize.CENTER;
			huidigeRoute.doel.tekst.wordWrap = false;
			huidigeRoute.doel.tekst.text = huidigeKnop.platTekst
			*/
			if (styleConst == STYLE_START) {
				
			}
			if (styleConst == STYLE_END) {
				txt_label.border = true;
				txt_label.borderColor = 0xEAEAEA;
				txt_label.background = true;
				txt_label.backgroundColor = 0xEAEAEA;
				
				//txt_label.text = huidigeKnop.platTekst
			}
			txt_label.autoSize = TextFieldAutoSize.CENTER;
			txt_label.wordWrap = false;
			txt_label.x = 0-(txt_label.width/2)
			txt_label.y = 0-(txt_label.height/2)
		}
		
		public function setPosition(posConst:String) {
			trace ("PointLabel -> setPosition()...SET POSITION : "+posConst+" txtLabel : "+txt_label.text)
			var offSet:int = 20;
			// autosize
			// center the textfield
			//txt_label.x = 
			//x = _pos.x;
			//y = _pos.y;
			
			x = _pos.x;
			y = _pos.y + offSet;
			
			//if (posConst == POSITION_DOWN) {
				//default
				
			//}
			if (posConst == POSITION_RIGHT) {
				x = (txt_label.width / 2) + _pos.x + offSet;
				y = _pos.y
			}
			if (posConst == POSITION_UP) {
				//trace ("TOP - TOP - TOP")
				x = _pos.x;
				y = _pos.y - offSet;
			}
			if (posConst == POSITION_LEFT) {
				x = _pos.x - (txt_label.width / 2) - offSet;
				y = _pos.y
			}
			trace ("SET POSITION DONE x: "+x+" y: "+y)
		}
		
		public function show():void {
			visible = true;
		}
		
		public function hide():void {
			visible = false;
		}
		
		public function get position():String { return _position; }
		public function set position(value:String):void {
			_position = value;
		}
		
		public function get style():String { return _style; }
		public function set style(value:String):void {
			_style = value;
			setStyle(_style);
		}
	}

}