//nl.photoreality.map_editor.model.vo.RouteVO
package nl.photoreality.map_editor.model.vo {
	
	
	public class RouteVO {
		
		private var _floors			: Vector.<FloorVO>;
		private var _name			: String;
		private var _nameLower		: String;
		private var _points			: Vector.<RoutePointVO>;
		private var _labels			: Vector.<RouteFloorLabelVO>
		
		public function RouteVO(name:String, points:Vector.<RoutePointVO>, floors:Vector.<FloorVO>,labels:Vector.<RouteFloorLabelVO> = null) {
			if (labels) {
				_labels = labels;
			}else {
				_labels = new Vector.<RouteFloorLabelVO>();
				_labels.push(new RouteFloorLabelVO("", new PositionLabelVO("Ingang"), new PositionLabelVO(name)) );
				_labels.push(new RouteFloorLabelVO("", new PositionLabelVO("Ingang"), new PositionLabelVO(name)) );
			}
			_floors = floors;
			_name = name;
			_nameLower = name.toLowerCase();
			_points = points;
		}
		
		
		//-- Getters & Setters
		public function get floors():Vector.<FloorVO> { return _floors; }
		public function set floors(value:Vector.<FloorVO>):void {
			_floors = value;
		}
		
		public function get name():String { return _name; }
		public function set name(value:String):void {
			_name = value;
		}
		
		public function get points():Vector.<RoutePointVO> { return _points; }
		public function set points(value:Vector.<RoutePointVO>):void {
			_points = value;
		}
		
		public function get labels():Vector.<RouteFloorLabelVO> { return _labels; }
		public function set labels(value:Vector.<RouteFloorLabelVO>):void {
			_labels = value;
		}
		
		public function get nameLower():String { return _nameLower; }
	}
}