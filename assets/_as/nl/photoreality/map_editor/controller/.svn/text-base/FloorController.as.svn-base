package nl.photoreality.map_editor.controller {
	import flash.geom.Point;
	import nl.photoreality.map_editor.constants.EditorConstants;
	import nl.photoreality.map_editor.model.FloorModel;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.map_editor.model.vo.FloorVO;
	import nl.photoreality.map_editor.model.vo.IconVO;
	import nl.photoreality.map_editor.proxy.LoadFloorsProxy;
	import nl.photoreality.map_editor.view.floors.icon.IconHolder;
	import nl.photoreality.map_editor.view.map.icons.ElevatorIcon;
	import nl.photoreality.map_editor.view.map.icons.EntranceIcon;
	import nl.photoreality.map_editor.view.map.icons.Icon;
	
	public class FloorController  {
		
		private static var instance				: FloorController;
		private var _floorModel					: FloorModel;
		private var _model							: Model;
		
		public function FloorController(enforcer:SingletonEnforcer) {
			trace("FloorController -> constructor");
			_floorModel		= FloorModel.getInstance();
			_model				= Model.getInstance();
		}
		
		public static function getInstance():FloorController {
			if (FloorController.instance == null) FloorController.instance = new FloorController(new SingletonEnforcer());
			return FloorController.instance;
		}
		
		public function addFloor(floor:FloorVO):void {
			_model.floors.push(floor);
			_model.dispatch(Model.FLOORS_CHANGE);
		}
		
		public function addIcon(icon:IconVO):void {
			_model.icons.push(icon)
			_model.dispatch(Model.ICON_ADDED);
		}
		
		public function removeIcon(icon:IconVO):void {
			for (var i:int = 0; i < _model.icons.length ; i++) 
			{
				if (icon.id ==  _model.icons[i].id) {
					_model.icons.splice(i, 1);
				}
			}
			_model.dispatch(Model.ICON_REMOVED);
		}
		
		public function removeFloor(floor:FloorVO):void {
			for (var i:int = 0; i < _model.floors.length; i++) {
				if (_model.floors[i].name == floor.name) {
					_model.floors.splice(i, 1);
				}
			}
			_floorModel.selectedFloor = _model.floors[0];
			_model.dispatch(Model.FLOORS_CHANGE);
		}
		
		public function floorChanged():void {
			_model.dispatch(Model.FLOORS_CHANGE);
		}
		
		public function selectFloor(floor:FloorVO):void {
			_floorModel.selectedFloor = floor;
			_floorModel.dispatch(FloorModel.FLOOR_SELECT);
		}
		
		public function selectIcon(icon:Icon):void {
			_floorModel.selectedIcon = icon;
			_floorModel.dispatch(FloorModel.ICON_SELECT);
		}

		// 
		public function placeIcon(icon:IconHolder, clickPoint:Point):void {
			_floorModel.currentDragIcon		 				= icon;
			_floorModel.currentDragIconStartPoint		 	= clickPoint;
			_floorModel.dispatch(FloorModel.ADD_ICON_TO_FLOOR);
		}
		
		public function deleteIcon(icon:IconVO):void {
			_floorModel.selectedFloor.icons
			for (var i:int = 0; i < _floorModel.selectedFloor.icons.length; i++) 
			{
				if (icon.id ==  _floorModel.selectedFloor.icons[i].id) {
					_floorModel.selectedFloor.icons.splice(i, 1);
					break;
				}
			}
			_model.dispatch(Model.FLOORS_CHANGE);
		}
	}
}

class SingletonEnforcer { }