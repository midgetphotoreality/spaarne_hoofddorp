package nl.photoreality.map_editor.model {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import nl.photoreality.map_editor.model.vo.FloorVO;
	import nl.photoreality.map_editor.model.vo.IconVO;
	import nl.photoreality.map_editor.view.floors.icon.IconHolder;
	import nl.photoreality.map_editor.view.map.icons.ElevatorIcon;
	import nl.photoreality.map_editor.view.map.icons.EntranceIcon;
	import nl.photoreality.map_editor.view.map.icons.Icon;
		/**
	 * ...
	 * @author Miguel Fuentes // DioVoiD
	 */
	public class FloorModel extends EventDispatcher {
		
		public static const  ADD_ICON_TO_FLOOR				: String = "add_icon_to_floor";
		public static const  ADD_ICON_TO_FLOOR_DONE		: String = "add_icon_to_floor_done";
		public static const  FLOOR_SELECT							: String = "floor_select";
		public static const  ICON_SELECT								: String = "icon_select";
		
		private static var instance											: FloorModel;
		private var _floors														: Vector.<FloorVO>;
		
		private var _selectedFloor											: FloorVO;
		private var _selectedIcon												: Icon;
		private var _currentDragIcon										: IconHolder;
		private var _currentDragIconStartPoint							: Point;
		
		public function FloorModel(enforcer:SingletonEnforcer) {
			trace("FloorModel -> constructor");
		}
		
		public static function getInstance():FloorModel {
			if (FloorModel.instance == null) FloorModel.instance = new FloorModel(new SingletonEnforcer());
			return FloorModel.instance;
		}
		
		public function dispatch(evtString:String):void {
			trace("FloorModel -> dispatch(" + evtString + ")");
			dispatchEvent(new Event(evtString));
		}
		
		public function get floors():Vector.<FloorVO> { return _floors; }
		public function set floors(value:Vector.<FloorVO>):void 	{
			_floors = value;
		}
		
		public function get selectedFloor():FloorVO { return _selectedFloor; }
		public function set selectedFloor(value:FloorVO):void {
			_selectedFloor = value;
		}
		
		public function get selectedIcon():Icon { return _selectedIcon; }
		public function set selectedIcon(value:Icon):void {
			_selectedIcon = value;
		}
		
		public function get currentDragIcon():IconHolder { return _currentDragIcon; }
		public function set currentDragIcon(value:IconHolder):void {
			_currentDragIcon = value;
		}
		
		public function get currentDragIconStartPoint():Point { return _currentDragIconStartPoint; }
		public function set currentDragIconStartPoint(value:Point):void {
			_currentDragIconStartPoint = value;
		}
	}
}

class SingletonEnforcer { }