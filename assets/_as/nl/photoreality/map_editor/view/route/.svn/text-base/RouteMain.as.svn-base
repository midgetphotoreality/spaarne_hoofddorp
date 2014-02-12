//nl.photoreality.map_editor.view.route.RouteMain
package nl.photoreality.map_editor.view.route {
	
	import com.greensock.TweenLite;
	import fl.controls.Button;
	import fl.controls.List;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import nl.photoreality.map_editor.constants.EditorConstants;
	import nl.photoreality.map_editor.constants.OverlayConstants;
	import nl.photoreality.map_editor.controller.Controller;
	import nl.photoreality.map_editor.controller.RouteController;
	import nl.photoreality.map_editor.manager.PanoAssetsLoadManager;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.map_editor.model.vo.FloorVO;
	import nl.photoreality.map_editor.view.floors.FloorContainer;
	import nl.photoreality.map_editor.view.map.icons.Icon;
	import nl.photoreality.utils.debug.Debug;
	
	
	public class RouteMain extends MovieClip {
		
		private var _controller				: RouteController;
		private var _model					: Model;
		private var _modelRoute				: RouteModel;
		
		// stage instances
		public var label_container_mc		: LabelContainer;
		public var floor1_container_mc		: FloorContainer;
		public var floor1_name				: TextField;
		public var floor2_container_mc		: FloorContainer;
		public var floor2_name				: TextField;
		public var menu_mc					: RouteMenu;
		public var route_container_mc		: RouteContainer;
		
		private var _mapsOnTop				: Boolean = true;
		
		public function RouteMain()  {
			_controller = RouteController.getInstance();
			_model = Model.getInstance();
			_modelRoute = RouteModel.getInstance();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			setHorizontalMode();
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
			
			if (_model.routes.length) {
				refresh();
			}
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
		}
		
		private function addListeners():void {
			_modelRoute.addEventListener(RouteModel.ROUTE_PLAY, routePlayListener);
			_modelRoute.addEventListener(RouteModel.ROUTE_SELECTED, routeSelectedListener);
			_modelRoute.addEventListener(RouteModel.ROUTE_MODE_CHANGED, routeModeChangedListener);
		}
		
		private function removeListeners():void {
			_modelRoute.removeEventListener(RouteModel.ROUTE_PLAY, routePlayListener);
			_modelRoute.removeEventListener(RouteModel.ROUTE_SELECTED, routeSelectedListener);
			_modelRoute.removeEventListener(RouteModel.ROUTE_MODE_CHANGED, routeModeChangedListener);
		}
		
		
		
		
		
		//-- Listeners
		private function routeSelectedListener(e:Event):void {
			trace("RouteMain -> routeSelectedListener")
			refresh();
		}
		
		private function routePlayListener(e:Event):void {
			if (PanoAssetsLoadManager.getInstance().currentRouteLoaded) {
				Debug.log("HALLO LOADED");
				Controller.getInstance().showOverlay(OverlayConstants.PANORAMA_CONTAINER);
			} else {
				Debug.log("HALLO NOT LOADED");
				PanoAssetsLoadManager.getInstance().addEventListener(PanoAssetsLoadManager.LOAD_COMPLETE, panoLoadCompleteListener);
			}
		}
		
		private function panoLoadCompleteListener(e:Event):void {
			PanoAssetsLoadManager.getInstance().removeEventListener(PanoAssetsLoadManager.LOAD_COMPLETE, panoLoadCompleteListener);
			Controller.getInstance().showOverlay(OverlayConstants.PANORAMA_CONTAINER);
		}
		
		private function setHorizontalMode():void {
			trace("RouteMain -> setHorizontalMode")
			floor2_container_mc.x    			= EditorConstants.FLOOR2_HORIZONTAL_OFFSET_X+floor1_container_mc.x;
			floor2_container_mc.y    			= EditorConstants.FLOOR2_HORIZONTAL_OFFSET_Y+floor1_container_mc.y;
			route_container_mc.floor2OffsetY    = EditorConstants.FLOOR2_HORIZONTAL_OFFSET_Y;
			route_container_mc.floor2OffsetX    = EditorConstants.FLOOR2_HORIZONTAL_OFFSET_X;
			floor2_name.x 						= EditorConstants.FLOOR2_HORIZONTAL_OFFSET_X+floor1_container_mc.x;
			floor2_name.y	 					= EditorConstants.FLOOR2_HORIZONTAL_OFFSET_Y + floor1_container_mc.y - 20;
			label_container_mc.offSet			= new Point(EditorConstants.FLOOR2_HORIZONTAL_OFFSET_X, EditorConstants.FLOOR2_HORIZONTAL_OFFSET_Y);
		}
		
		private function setVerticalMode():void {
			trace("RouteMain -> setVerticalMode")
			floor2_container_mc.x 				= EditorConstants.FLOOR2_VERTICAL_OFFSET_X+floor1_container_mc.x;
			floor2_container_mc.y 				= EditorConstants.FLOOR2_VERTICAL_OFFSET_Y+floor1_container_mc.y;
			route_container_mc.floor2OffsetX    = EditorConstants.FLOOR2_VERTICAL_OFFSET_X;
			route_container_mc.floor2OffsetY    = EditorConstants.FLOOR2_VERTICAL_OFFSET_Y;
			floor2_name.x 						= EditorConstants.FLOOR2_VERTICAL_OFFSET_X+floor1_container_mc.x;
			floor2_name.y	 					= EditorConstants.FLOOR2_VERTICAL_OFFSET_Y + floor1_container_mc.y - 20;
			label_container_mc.offSet			= new Point(EditorConstants.FLOOR2_VERTICAL_OFFSET_X, EditorConstants.FLOOR2_VERTICAL_OFFSET_Y);
		}
		
		private function routeModeChangedListener(e:Event):void {
			if (_modelRoute.currentRouteEditorMode == EditorConstants.EDITOR_MODE_HORIZONTAL) {
				setHorizontalMode();
			} else {
				setVerticalMode();
			}
			_modelRoute.dispatch(RouteModel.ROUTE_MODE_SET);
		}
		
		
		
		//-- Refresh
		private function refresh():void {
			route_container_mc.refresh();
			
			// route selected -> show
			if (_modelRoute.routeIsSelected) {
				addFloor1(_modelRoute.selectedRouteVO.floors[0]);
				
				// check if end floor is different
				if (_modelRoute.selectedRouteVO.floors[0] != _modelRoute.selectedRouteVO.floors[1]) {
					addFloor2(_modelRoute.selectedRouteVO.floors[1]);
				} else {
					floor2_container_mc.deinit();
					floor2_name.text = "";
				}
				
			// route not selected -> kill
			} else {
				floor1_container_mc.deinit();
				floor1_name.text = "";
				floor2_container_mc.deinit();
				floor2_name.text = "";
			}
		}
		
		private function addFloor1(floorVO:FloorVO):void {
			floor1_container_mc.floor = floorVO;
			floor1_name.text = floorVO.name;
			
			for (var i:int = 0; i < floor1_container_mc.icons.length; i++) {
				if (floor1_container_mc.icons[i].vo.linkage == "icon_entrance") {
					floor1_container_mc.icons[i].addEventListener(MouseEvent.MOUSE_DOWN, handleEntranceClick);
				} else if (floor1_container_mc.icons[i].vo.linkage == "icon_elevator") {
					floor1_container_mc.icons[i].addEventListener(MouseEvent.MOUSE_DOWN, handleElevatorClick);
				}
			}
		}
		
		private function addFloor2(floorVO:FloorVO):void {
			floor2_container_mc.floor = floorVO;
			floor2_name.text = floorVO.name;
			
			for (var i:int = 0; i < floor2_container_mc.icons.length; i++) {
				if (floor2_container_mc.icons[i].vo.linkage == "icon_entrance") {
					floor2_container_mc.icons[i].addEventListener(MouseEvent.MOUSE_DOWN, handleEntranceClick);
				} else if (floor2_container_mc.icons[i].vo.linkage == "icon_elevator") {
					floor2_container_mc.icons[i].addEventListener(MouseEvent.MOUSE_DOWN, handleElevatorClick);
				}
			}
		}
		
		private function handleElevatorClick(e:MouseEvent):void {
			Debug.log("ELEVATOR CLICK!!");
			if (_modelRoute.isDrawing) {
				//_controller.drawingChangeFloor(Icon(e.currentTarget));
				TweenLite.delayedCall(0.5, _controller.drawingChangeFloor, [Icon(e.currentTarget)]);
			}
		}
		
		private function handleEntranceClick(e:MouseEvent):void {
			var clickedIcon:Icon = Icon(e.currentTarget);
			
			if (floor1_container_mc._iconContainer.contains(clickedIcon)) {
				_controller.drawingStart(clickedIcon, 0);
			} else {
				_controller.drawingStart(clickedIcon, 1);
			}
		}
	}
}