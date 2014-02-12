//nl.photoreality.map_editor.model.RouteModel
package nl.photoreality.map_editor.model {
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import nl.photoreality.map_editor.constants.EditorConstants;
	import nl.photoreality.map_editor.model.vo.RoutePointVO;
	import nl.photoreality.map_editor.model.vo.FloorVO;
	import nl.photoreality.map_editor.model.vo.IconVO;
	import nl.photoreality.map_editor.model.vo.RouteVO;
	import nl.photoreality.map_editor.view.map.icons.EntranceIcon;
	import nl.photoreality.map_editor.view.map.icons.Icon;
	import nl.photoreality.map_editor.view.route.RoutePoint;
	import nl.photoreality.utils.debug.Debug;
	
	
	public class RouteModel extends EventDispatcher {
		
		public static const DRAWING_CHANGE_FLOOR_IN			: String			= "drawingChangeFloorIn";
		public static const DRAWING_CHANGE_FLOOR_OUT		: String			= "drawingChangeFloorOut";
		public static const DRAWING_COMPLETED				: String			= "drawingCompleted";
		public static const DRAWING_STARTED					: String			= "drawingStarted";
		
		public static const ROUTE_ADDED						: String			= "routeAdded";
		public static const ROUTE_PANO_DIALOG_CLOSE			: String			= "routePanoDialogClose";
		public static const ROUTE_PANO_DIALOG_OPEN			: String			= "routePanoDialogOpen";
		public static const ROUTE_PLAY						: String			= "routePlay";
		public static const ROUTE_PLAY_FLOOR_CHANGED		: String			= "routePlayFloorChanged";
		public static const ROUTE_SELECT_FLOOR_CHANGED		: String			= "routePlayFloorSelect";
		public static const ROUTE_PLAY_NEXT_POINT			: String			= "routePlayNextPoint";
		public static const ROUTE_REMOVED					: String			= "routeRemoved";
		public static const ROUTE_SELECTED					: String			= "routeSelected";
		public static const ROUTE_FINISHED					: String			= "routeFinished";
		public static const ROUTE_DUPLICATED				: String			= "routeDuplicated";
		public static const ROUTE_MODE_CHANGED				: String			= "routeModeChanged";
		public static const ROUTE_MODE_SET					: String			= "routeModeSet";
		
		//public static const ROUTEPOINT_ADDED				: String			= "routePointAdded";
		public static const ROUTEPOINT_ADDED_AFTER_CURRENT	: String			= "routePointAddedAfterCurrent";
		public static const ROUTEPOINT_CHANGED				: String			= "routePointChanged";
		public static const ROUTEPOINT_DESELECTED			: String			= "routePointDeselected";
		public static const ROUTEPOINT_REMOVED				: String			= "routePointRemoved";
		public static const ROUTEPOINT_SELECTED				: String			= "routePointSelected";
		
		public static const LABEL_POSITION_CHANGED			: String			= "label_position_changed";
		//public static const ZOOM							: String			= "zoom";
		
		public static const ARROW_PLAY_SPEED_CHANGED		: String			= "arrow_play_speed_changed";
		
		
		
		//public static const	EDIT_MODE_CHANGE				: String 			= "edit_mode_change";
		//public static const	DRAW_MODE_CHANGE				: String 			= "draw_mode_change";
		//public static const	ROUTE_POINT_CREATED				: String 			= "route_point_created";
		
		//public static const ROUTE_EDITOR_UPDATE				: String			= "route_editor_update";
		//public static const FLOORS_CHANGE					: String			= "floors_change";
		
		private static var instance				: RouteModel;
		/*
		private var _editModeOn					: Boolean		= true;
		private var _drawModeOn					: Boolean		= false;
		*/
		
		private var _selectedFloor				: int = 0;
		
		private var _isChangingFloor			: Boolean;
		private var _isDrawing					: Boolean;
		private var _routeIsSelected			: Boolean;
		
		private var _currentDrawingFloorId		: String;
		private var _currentDrawingHitIcon		: Icon;
		
		private var _selectedRouteVOIndex		: uint;
		private var _selectedRoutePointVOIndex	: uint;
		private var _selectedRoutePoint			: RoutePoint;
		
		private var _arrowPlaySpeedPercent		: Number;
		
		private var _currentRouteEditorMode		: String = EditorConstants.EDITOR_MODE_HORIZONTAL;
		
		public function RouteModel(enforcer:SingletonEnforcer) {
			trace("RouteModel -> constructor");
			_arrowPlaySpeedPercent = 0.5;
		}
		
		public static function getInstance():RouteModel {
			if (RouteModel.instance == null) RouteModel.instance = new RouteModel(new SingletonEnforcer());
			return RouteModel.instance;
		}
		
		public function dispatch(evtString:String):void {
			Debug.log("RouteModel -> dispatch(" + evtString + ")");
			dispatchEvent(new Event(evtString));
		}
		
		
		
		public function getFloorNameById(id:String):String {
			var floors:Vector.<FloorVO> = Model.getInstance().floors;
			var name:String;
			for (var i:int = 0; i < floors.length; i++) {
				if (floors[i].id == id) {
					name = floors[i].name;
					break;
				}
			}
			return name;
		}
		
		
		private function getRouteIndexByName(name:String):uint {
			var routes:Vector.<RouteVO> = Model.getInstance().routes;
			var index:uint = 0;
			for (var i:int = 0; i < routes.length; i++) {
				if (routes[i].name == name) {
					index = i;
					break;
				}
			}
			return index;
		}
		
		private function getRoutePointIndexById(id:uint):uint {
			var points:Vector.<RoutePointVO> = selectedRouteVO.points;
			var index:uint = 0;
			for (var i:int = 0; i < points.length; i++) {
				if (points[i].id == id) {
					index = i;
					break;
				}
			}
			return index;
		}
		
		
		//-- Getters & Setters
		public function get isChangingFloor():Boolean { return _isChangingFloor; }
		public function set isChangingFloor(value:Boolean):void {
			_isChangingFloor = value;
		}
		
		public function get isDrawing():Boolean { return _isDrawing; }
		public function set isDrawing(value:Boolean):void {
			_isDrawing = value;
		}
		
		public function get routeIsSelected():Boolean { return _routeIsSelected; }
		public function set routeIsSelected(value:Boolean):void {
			_routeIsSelected = value;
		}
		
		
		public function get currentDrawingFloorId():String { return _currentDrawingFloorId; }
		public function set currentDrawingFloorId(value:String):void {
			_currentDrawingFloorId = value;
		}
		
		public function get currentDrawingHitIcon():Icon { return _currentDrawingHitIcon; }
		public function set currentDrawingHitIcon(value:Icon):void {
			_currentDrawingHitIcon = value;
		}
		
		public function get selectedRouteVO():RouteVO { return Model.getInstance().routes[_selectedRouteVOIndex]; }
		public function set selectedRouteVO(routeVO:RouteVO):void {
			trace("selectedRouteVO : routeVO:"+ routeVO.points.length)
			_selectedRouteVOIndex = getRouteIndexByName(routeVO.name);
		}
		
		public function get selectedRoutePointVO():RoutePointVO { return selectedRouteVO.points[_selectedRoutePointVOIndex]; }
		public function set selectedRoutePointVO(routePointVO:RoutePointVO):void {
			_selectedRoutePointVOIndex = getRoutePointIndexById(routePointVO.id);
		}
		
		public function get selectedRoutePoint():RoutePoint { return _selectedRoutePoint; }
		public function set selectedRoutePoint(value:RoutePoint):void {
			_selectedRoutePoint = value;
		}
		
		public function get selectedRouteVOIndex():uint { return _selectedRouteVOIndex; }
		
		public function get arrowPlaySpeedPercent():Number 	{ return _arrowPlaySpeedPercent; }
		public function set arrowPlaySpeedPercent(value:Number):void {
			_arrowPlaySpeedPercent = value;
		}
		
		public function get currentRouteEditorMode():String { return _currentRouteEditorMode; }
		
		public function set currentRouteEditorMode(value:String):void 
		{
			_currentRouteEditorMode = value;
			dispatch(ROUTE_MODE_CHANGED);
		}
		
		public function get selectedFloor():int { return _selectedFloor; }
		
		public function set selectedFloor(value:int):void 
		{
			_selectedFloor = value;
		}
	}
}

class SingletonEnforcer { }