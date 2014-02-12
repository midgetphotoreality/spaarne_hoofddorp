package nl.photoreality.map_editor.model.vo 
{
	import nl.photoreality.utils.debug.Debug;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class RouteFloorLabelVO
	{
		public static const POSITION_TOP	 	: String = "position_top";
		public static const POSITION_LEFT	 	: String = "position_left";
		public static const POSITION_DOWN	 	: String = "position_down";
		public static const POSITION_RIGHT	 	: String = "position_right";
		
		private var _label			:String;
		private var _startLabel		:PositionLabelVO;
		private var _endLabel		:PositionLabelVO;
		private var _id				:String
		
		public function RouteFloorLabelVO(label:String = "", startLabel:PositionLabelVO = null, endLabel:PositionLabelVO = null) {
			if (startLabel) {
				_startLabel = startLabel;
			}else {
				_startLabel = new PositionLabelVO("")
			}
			
			if (endLabel) {
				_endLabel = endLabel;
			}else {
				_endLabel = new PositionLabelVO("")
			}
			_id 		= String("vo" + Math.random() * 1000000000);
			Debug.log("RouteFloorLabelVO -> constructor, id: " + _id, true);
			_label 		= label;
		}
		
		public function get label():String { return _label; }
		public function set label(value:String):void {
			trace("RouteFloorLabelVO -> constructor, set label: "+_id, true);
			_label = value;
		}
		
		public function get startLabel():PositionLabelVO { return _startLabel; }
		public function set startLabel(value:PositionLabelVO):void {
			_startLabel = value;
		}
		
		public function get endLabel():PositionLabelVO { return _endLabel; }
		public function set endLabel(value:PositionLabelVO):void {
			_endLabel = value;
		}
		
	}

}