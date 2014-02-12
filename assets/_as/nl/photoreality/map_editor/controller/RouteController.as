// nl.photoreality.map_editor.controller.RouteController
package nl.photoreality.map_editor.controller {
	
	import flash.events.Event;
	import nl.photoreality.map_editor.constants.OverlayConstants;
	import nl.photoreality.map_editor.manager.PanoAssetsLoadManager;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.map_editor.model.vo.FloorVO;
	import nl.photoreality.map_editor.model.vo.PanoramaVO;
	import nl.photoreality.map_editor.model.vo.PositionLabelVO;
	import nl.photoreality.map_editor.model.vo.RouteFloorLabelVO;
	import nl.photoreality.map_editor.model.vo.RoutePointVO;
	import nl.photoreality.map_editor.model.vo.RouteVO;
	import nl.photoreality.map_editor.view.EditorMain;
	import nl.photoreality.map_editor.view.map.icons.Icon;
	import nl.photoreality.map_editor.view.route.RoutePoint;
	import nl.photoreality.utils.debug.Debug;
	
	
	public class RouteController  {
		
		private static var instance				: RouteController;
		
		private var _model						: Model;
		private var _modelRoute					: RouteModel;
		private var _rootMc						: EditorMain;
		
		
		public function RouteController(enforcer:SingletonEnforcer) {
			trace("RouteController -> constructor");
			_model = Model.getInstance();
			_modelRoute = RouteModel.getInstance();
			_modelRoute.addEventListener(RouteModel.ROUTE_PANO_DIALOG_OPEN, handlePanoDialogOpen);
		}
		
		public static function getInstance():RouteController {
			if (RouteController.instance == null) RouteController.instance = new RouteController(new SingletonEnforcer());
			return RouteController.instance;
		}
		
		//-- Register
		/*public function regRoute(root:EditorMain):void {
			trace("WTF");
			_rootMc = root;
		}*/
		
		
		
		//-- Route
		public function addRoute(name:String, floorStartVO:FloorVO, floorEndVO:FloorVO):void {
			trace("RouteController -> addRoute() -> " + name);
			var floors:Vector.<FloorVO> = new Vector.<FloorVO>();
			floors.push(floorStartVO);
			floors.push(floorEndVO);
			
			var routeVO:RouteVO = new RouteVO(name, new Vector.<RoutePointVO>(), floors);
			_model.routes.push(routeVO);
			_modelRoute.dispatch(RouteModel.ROUTE_ADDED);
			
			selectRoute(routeVO);
		}
		
		public function duplicateRoute():void {
			Debug.log("RouteController -> duplicateRoute() -> " + _modelRoute.selectedRouteVO.name);
			// (name:String, points:Vector.<RoutePointVO>, floors:Vector.<FloorVO>,labels:Vector.<RouteFloorLabelVO> = null)
			var pointsVO:Vector.<RoutePointVO> = new Vector.<RoutePointVO>();
			var floorsVO:Vector.<FloorVO> = new Vector.<FloorVO>();
			var labelsVO:Vector.<RouteFloorLabelVO> = new Vector.<RouteFloorLabelVO>();
			for (var i:int = 0; i < _modelRoute.selectedRouteVO.points.length; i++) {
				//public function RoutePointVO(id:uint, x:Number, y:Number, floorId:String/*floor:FloorVO*/, icon:IconVO = null, panorama:PanoramaVO = null) {
				var routePoint:RoutePointVO = _modelRoute.selectedRouteVO.points[i];
				var panorama:PanoramaVO = null;
				if (routePoint.panorama) {
					panorama = new PanoramaVO(routePoint.panorama.name, routePoint.panorama.linkage, routePoint.panorama.angleTransitionIn, routePoint.panorama.angleTransitionOut);
				}
				
				Debug.log("RouteController -> duplicateRoute()"+routePoint.angleTransitionIn+" , "+routePoint.angleTransitionOut)
				var newRoutePoint:RoutePointVO = new RoutePointVO(routePoint.id, routePoint.x, routePoint.y, routePoint.floorId, routePoint.icon, panorama);
				newRoutePoint.angleTransitionIn = routePoint.angleTransitionIn;
				newRoutePoint.angleTransitionOut = routePoint.angleTransitionOut;
				pointsVO.push(newRoutePoint);// new RoutePointVO(routePoint.id, routePoint.x, routePoint.y, routePoint.floorId, routePoint.icon, panorama));
			}
			for (i = 0; i < _modelRoute.selectedRouteVO.floors.length; i++) {
				var floor:FloorVO = _modelRoute.selectedRouteVO.floors[i];
				floorsVO.push(floor);//new FloorVO(floor.name, floor.linkage, floor.isBaseFloor, floor.icons, floor.id));
			}
			for (i = 0; i < _modelRoute.selectedRouteVO.labels.length; i++) {
				var label:RouteFloorLabelVO = _modelRoute.selectedRouteVO.labels[i];
				labelsVO.push(new RouteFloorLabelVO(label.label, new PositionLabelVO(label.startLabel.label, label.startLabel.position), new PositionLabelVO(label.endLabel.label, label.endLabel.position)));
			}
			
			
			
			var routeName:String = _modelRoute.selectedRouteVO.name + " copy";
			_model.routes.push(new RouteVO(routeName, pointsVO, floorsVO, labelsVO ) );
			_modelRoute.dispatch(RouteModel.ROUTE_DUPLICATED);
			
		}
		
		public function playRoute():void {
			_modelRoute.dispatch(RouteModel.ROUTE_PLAY);
		}
		
		public function playRouteNextPoint():void {
			_modelRoute.dispatch(RouteModel.ROUTE_PLAY_NEXT_POINT);
		}
		
		public function playRouteFloorChanged():void {
			_modelRoute.dispatch(RouteModel.ROUTE_PLAY_FLOOR_CHANGED);
		}
		
		public function endRoute():void {
			_modelRoute.dispatch(RouteModel.ROUTE_FINISHED);
		}
		
		public function removeRoute(name:String):void {
			for (var i:int = 0; i < _model.routes.length; i++) {
				if (_model.routes[i].name == name) {
					_model.routes.splice(i, 1);
					break;
				}
			}
			_modelRoute.dispatch(RouteModel.ROUTE_REMOVED);
			
			// select next
			if (_model.routes.length) {
				if (i - 1 >= 0) {
					selectRoute(_model.routes[i - 1]);
				} else if (i <= _model.routes.length -1) {
					selectRoute(_model.routes[i]);
				} else {
					selectRoute(null);
				}
			} else {
				selectRoute(null);
			}
		}
		
		public function selectRoute(routeVO:RouteVO = null):void {
			if (routeVO) {
				trace("RouteController -> showRoute() -> " + routeVO.name);
				_modelRoute.routeIsSelected = true;
				_modelRoute.selectedRouteVO = routeVO;
				
				PanoAssetsLoadManager.getInstance().loadRoute(routeVO);
				
			} else {
				trace("RouteController -> showRoute() -> -");
				_modelRoute.routeIsSelected = false;
			}
			
			_modelRoute.dispatch(RouteModel.ROUTE_SELECTED);
		}
		
		
		private function handlePanoDialogOpen(e:Event):void {
			Controller.getInstance().showOverlay(OverlayConstants.ADD_PANORAMA);
		}
		
		public function routePanoDialogOpen():void {
			_modelRoute.dispatch(RouteModel.ROUTE_PANO_DIALOG_OPEN);
		}
		
		public function routePanoDialogClose(pano_linkage:String = ""):void {
			var lastRouteVO:RoutePointVO = _modelRoute.selectedRouteVO.points[_modelRoute.selectedRouteVO.points.length - 1];
			lastRouteVO.panorama = new PanoramaVO("", pano_linkage, Number.NaN, Number.NaN);
			/*if (!lastRouteVO.panorama) {
				lastRouteVO.panorama = new PanoramaVO("", pano_linkage, lastRouteVO.angleTransitionIn, lastRouteVO.angleTransitionOut);
				//_modelRoute.selectedRouteVO.points[_modelRoute.selectedRouteVO.points.length - 1].panorama.linkage = pano_linkage;
			} else {
				lastRouteVO.panorama.linkage = pano_linkage;
				lastRouteVO.panorama.angleTransitionIn = lastRouteVO.angleTransitionIn;
				lastRouteVO.panorama.angleTransitionOut = lastRouteVO.angleTransitionOut;
			}*/
			_modelRoute.dispatch(RouteModel.ROUTE_PANO_DIALOG_CLOSE);
		}
		
		
		// RoutePoints
		public function addRoutePointAfterCurrent():void {
			//var currentRoutePoints:Vector.<RoutePointVO> = _model.routes[_modelRoute.selectedRouteVOIndex].points;
			var currentRoutePoints:Vector.<RoutePointVO> = _modelRoute.selectedRouteVO.points;
			var currentRoutePointVO:RoutePointVO = _modelRoute.selectedRoutePointVO;
			
			if (currentRoutePoints.length <= (currentRoutePointVO.id + 1)) {
				trace("LAST ITEM, DO JACKSHIT");
			} else if (currentRoutePoints[currentRoutePointVO.id].floorId != currentRoutePoints[currentRoutePointVO.id +1].floorId) {
				trace("NEXT ITEM IS NOT ON THE SAME FLOOR");
			} else {
				//trace("CREATE MAGIC!!!!!!");
				// ALL GOOD, CREATE THE POINT
				Controller.getInstance().closeOverlay();
				//var newRoutePoint:RoutePointVO = new RoutePointVO(currentRoutePointVO + 1, currentRoutePointVO.x + 10, currentRoutePointVO.y + 10, currentRoutePointVO.floorId, null, new PanoramaVO("","",0,0)); 
				
				var pano:PanoramaVO = new PanoramaVO(currentRoutePointVO.panorama.name, currentRoutePointVO.panorama.linkage, currentRoutePointVO.panorama.angleTransitionIn, currentRoutePointVO.panorama.angleTransitionOut);
				var newRoutePoint:RoutePointVO = new RoutePointVO(currentRoutePointVO.id + 1, currentRoutePointVO.x + 10, currentRoutePointVO.y - 10, currentRoutePointVO.floorId, null, pano); 
				
				// fix identifiers
				
				currentRoutePoints.splice(currentRoutePointVO.id+1, 0, newRoutePoint);
				
				for (var i:int = 0; i < currentRoutePoints.length; i++) {
					currentRoutePoints[i].id = i;
				}
				
				_modelRoute.dispatch(RouteModel.ROUTEPOINT_ADDED_AFTER_CURRENT);
				changeRoutePoint();
				//_modelRoute.dispatch(RouteModel.ROUTEPOINT_CHANGED);
				
				selectRoute(_modelRoute.selectedRouteVO);
			}
		}
		
		// RoutePoints
		public function changeRoutePoint():void {
			/*_modelRoute.selectedRoutePointVO.x = posX
			_modelRoute.selectedRoutePointVO.y = posY;
			_modelRoute.selectedRoutePoint.x = _modelRoute.selectedRoutePointVO.x;
			_modelRoute.selectedRoutePoint.y = _modelRoute.selectedRoutePointVO.y;*/
			Controller.getInstance().closeOverlay();
			_modelRoute.dispatch(RouteModel.ROUTEPOINT_CHANGED);
		}
		
		public function deselectRoutePoint():void {
			_modelRoute.dispatch(RouteModel.ROUTEPOINT_DESELECTED);
		}
		
		public function removeRoutePoint():void {
			_modelRoute.dispatch(RouteModel.ROUTEPOINT_REMOVED);
		}
		
		public function selectRoutePoint(routePoint:RoutePoint):void {
			_modelRoute.selectedRoutePoint = routePoint;
			_modelRoute.selectedRoutePointVO = routePoint.vo;
			trace("RouteController -> selectRoutePoint: " + routePoint.x + "," + routePoint.y);
			trace("RouteController -> selectedRoutePointVO: " + routePoint.vo.x + "," + routePoint.vo.y);
			_modelRoute.dispatch(RouteModel.ROUTEPOINT_SELECTED);
		}
		
		
		
		
		
		// Drawing
		public function drawingStart(icon:Icon, floorIndex:uint):void {
			_modelRoute.currentDrawingHitIcon = icon;
			//_modelRoute.currentDrawingFloorId = _modelRoute.selectedRouteVO.floors[0].id;	// always start on 1st floor
			_modelRoute.currentDrawingFloorId = _modelRoute.selectedRouteVO.floors[floorIndex].id;	// always start on 1st floor
			_modelRoute.isDrawing = true;
			_modelRoute.dispatch(RouteModel.DRAWING_STARTED);
		}
		
		public function drawingStop():void {
			_modelRoute.isDrawing = false;
			_modelRoute.dispatch(RouteModel.DRAWING_COMPLETED);
			
			// play pano after drawing
			PanoAssetsLoadManager.getInstance().loadRoute(_modelRoute.selectedRouteVO);
			playRoute();
		}
		
		public function drawingChangeFloor(icon:Icon):void {
			trace("RouteController -> drawingChangeFloor() -> " + icon);
			_modelRoute.currentDrawingHitIcon = icon;
			
			if (_modelRoute.isChangingFloor) {
				_modelRoute.currentDrawingFloorId = _modelRoute.selectedRouteVO.floors[1].id;	// always continue with 2nd item in floors array
				_modelRoute.isChangingFloor = false;
				_modelRoute.dispatch(RouteModel.DRAWING_CHANGE_FLOOR_OUT);
			} else {
				_modelRoute.isChangingFloor = true;
				_modelRoute.dispatch(RouteModel.DRAWING_CHANGE_FLOOR_IN);
			}
		}
		
		
		
		
		
		
		public function setArrowSpeedPercentage(value:Number):void {
			_modelRoute.arrowPlaySpeedPercent = value;
			_modelRoute.dispatch(RouteModel.ARROW_PLAY_SPEED_CHANGED);
		}
	}
}

class SingletonEnforcer { }