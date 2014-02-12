package nl.photoreality.map_editor.model.vo 
{
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2012
	 */
	public class PositionLabelVO
	{
		private var _label						: String;
		private var _position					: String;
		private var _offsetX:int;
		private var _offsetY:int;
		
		public static const POSITION_TOP	 	: String = "position_top";
		public static const POSITION_LEFT	 	: String = "position_left";
		public static const POSITION_DOWN	 	: String = "position_down";
		public static const POSITION_RIGHT	 	: String = "position_right";
		
		public function PositionLabelVO(label:String, position:String = "position_down",offsetX:int =0,offsetY:int=0) {
			_offsetY = offsetY;
			_offsetX = offsetX;
			trace ("PositionLabelVO - > constructor , label: "+label+" / position:"+position+" / offsetX: "+offsetX+" / offsetY: "+offsetY)
			_position = position;
			_label = label;
			
		}
		
		public function get label():String { return _label; }
		public function set label(value:String):void {
			_label = value;
		}
		
		public function get position():String { return _position; }
		public function set position(value:String):void {
			_position = value;
		}
		
		public function get offsetX():int { return _offsetX; }
		
		public function set offsetX(value:int):void 
		{
			_offsetX = value;
		}
		
		public function get offsetY():int { return _offsetY; }
		
		public function set offsetY(value:int):void 
		{
			_offsetY = value;
		}
		
	}

}