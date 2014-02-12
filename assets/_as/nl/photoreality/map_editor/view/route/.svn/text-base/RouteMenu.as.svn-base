//nl.photoreality.map_editor.view.route.RouteMenu
package nl.photoreality.map_editor.view.route {
	
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nl.photoreality.map_editor.constants.EditorConstants;
	import nl.photoreality.map_editor.constants.OverlayConstants;
	import nl.photoreality.map_editor.controller.Controller;
	import nl.photoreality.map_editor.controller.RouteController;
	import nl.photoreality.map_editor.manager.PanoAssetsLoadManager;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.map_editor.model.vo.RouteVO;
	
	
	public class RouteMenu extends Sprite {
		
		private var _model				: Model;
		private var _modelRoute			: RouteModel;
		
		// stage instances
		public var btn_route_add		: SimpleButton;
		public var btn_route_play		: SimpleButton;
		public var btn_route_remove		: SimpleButton;
		public var btn_route_duplicate	: SimpleButton;
		public var btn_route_mode		: SimpleButton;
		public var combobox_list		: ComboBox;
		
		
		public function RouteMenu()  {
			_model = Model.getInstance();
			_modelRoute = RouteModel.getInstance();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
			//initList();
			
			if (_model.routes.length) {
				RouteController.getInstance().selectRoute(_model.routes[0]);
			}
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
		}
		
		private function addListeners():void {
			btn_route_add.addEventListener(MouseEvent.CLICK, btnRouteAddListener);
			btn_route_duplicate.addEventListener(MouseEvent.CLICK, btnRouteDuplicateListener);
			btn_route_play.addEventListener(MouseEvent.CLICK, btnRoutePlayListener);
			btn_route_remove.addEventListener(MouseEvent.CLICK, btnRouteRemoveListener);
			btn_route_mode.addEventListener(MouseEvent.CLICK, btnRouteModeListener);
			_modelRoute.addEventListener(RouteModel.ROUTE_ADDED, routeAddedListener);
			_modelRoute.addEventListener(RouteModel.ROUTE_DUPLICATED, routeDuplicatedListener);
			_modelRoute.addEventListener(RouteModel.ROUTE_REMOVED, routeRemovedListener);
			_modelRoute.addEventListener(RouteModel.ROUTE_SELECTED, routeSelectedListener);
			_modelRoute.addEventListener(RouteModel.ROUTE_MODE_SET, routeModeChangedListener);
		}
		
		private function removeListeners():void {
			btn_route_add.removeEventListener(MouseEvent.CLICK, btnRouteAddListener);
			btn_route_duplicate.removeEventListener(MouseEvent.CLICK, btnRouteDuplicateListener);
			btn_route_play.removeEventListener(MouseEvent.CLICK, btnRoutePlayListener);
			btn_route_remove.removeEventListener(MouseEvent.CLICK, btnRouteRemoveListener);
			btn_route_mode.removeEventListener(MouseEvent.CLICK, btnRouteModeListener);
			combobox_list.removeEventListener(Event.CHANGE, listChangeListener);
			_modelRoute.removeEventListener(RouteModel.ROUTE_ADDED, routeAddedListener);
			_modelRoute.removeEventListener(RouteModel.ROUTE_DUPLICATED, routeDuplicatedListener);
			_modelRoute.removeEventListener(RouteModel.ROUTE_REMOVED, routeRemovedListener);
			_modelRoute.removeEventListener(RouteModel.ROUTE_SELECTED, routeSelectedListener);
			_modelRoute.removeEventListener(RouteModel.ROUTE_MODE_SET, routeModeChangedListener);
		}
		
		private function routeModeChangedListener(e:Event):void 
		{
			RouteController.getInstance().selectRoute(RouteVO(combobox_list.selectedItem.route));
		}
		
		
		
		//-- Button Listeners
		
		
		private function btnRouteModeListener(e:MouseEvent):void {
			if (_modelRoute.currentRouteEditorMode == EditorConstants.EDITOR_MODE_HORIZONTAL) {
				_modelRoute.currentRouteEditorMode = EditorConstants.EDITOR_MODE_VERTICAL;
			}else {// if (_modelRoute.currentRouteEditorMode == EditorConstants.EDITOR_MODE_VERTICAL) {
				_modelRoute.currentRouteEditorMode = EditorConstants.EDITOR_MODE_HORIZONTAL;
			}
			
			/*
			if (_modelRoute.currentRouteEditorMode == EditorConstants.EDITOR_MODE_DOUBLEFLOORS) {
				_modelRoute.currentRouteEditorMode = EditorConstants.EDITOR_MODE_FLOOR1;
			}else if (_modelRoute.currentRouteEditorMode == EditorConstants.EDITOR_MODE_FLOOR1) {
				_modelRoute.currentRouteEditorMode = EditorConstants.EDITOR_MODE_FLOOR2;
			}else {
				_modelRoute.currentRouteEditorMode = EditorConstants.EDITOR_MODE_DOUBLEFLOORS;
			}
			*/
		}
		
		
		private function btnRouteAddListener(e:MouseEvent):void {
			Controller.getInstance().showOverlay(OverlayConstants.ADD_ROUTE);
		}
		
		private function btnRouteDuplicateListener(e:MouseEvent):void {
			RouteController.getInstance().duplicateRoute();
		}
		
		private function btnRoutePlayListener(e:MouseEvent):void {
			RouteController.getInstance().playRoute();
		}
		
		private function btnRouteRemoveListener(e:MouseEvent):void {
			if (combobox_list.selectedItem) {
				RouteController.getInstance().removeRoute(RouteVO(combobox_list.selectedItem.route).name);
			}
		}
		
		private function listChangeListener(e:Event):void {
			RouteController.getInstance().selectRoute(RouteVO(combobox_list.selectedItem.route));
		}
		
		
		
		//-- Listeners
		private function routeAddedListener(e:Event):void {
			refresh();
		}
		
		private function routeDuplicatedListener(e:Event):void {
			refresh();
			RouteController.getInstance().selectRoute(_model.routes[_model.routes.length - 1]);
		}
		
		private function routeRemovedListener(e:Event):void {
			//refresh();
		}
		
		private function routeSelectedListener(e:Event):void {
			refresh();
		}
		
		
		
		//-- List
		private function refresh():void {
			initList();
			
			for (var i:uint = 0; i < combobox_list.dataProvider.length; i++) {
				if (combobox_list.dataProvider.getItemAt(i).label == _modelRoute.selectedRouteVO.name) {
					combobox_list.selectedIndex = i;
					return;
				}
			}
		}
		
		
		private function vectorToArray(v:*):Array {
			var n:int = v.length; var a:Array = new Array();
			for(var i:int = 0; i < n; i++) a[i] = v[i];
			return a;
		}

		public function dump(arr:Array):void {
			//trace("dump: "+arr.length)
			for (var i:int = 0; i < arr.length; i++) 
			{
				//trace(i+": "+RouteVO(arr[i]).name);
			}
		}
		
		private function initList():void {
			// Create DataProvider
			var routes:Array = vectorToArray(_model.routes);
			routes.sortOn("name");
			var dp:DataProvider = new DataProvider();
			for (var i:uint = 0; i < _model.routes.length; i++) {
				//trace(routes[i].name);
				dp.addItem( {label:routes[i].name, route:routes[i] } );
			}
			combobox_list.dataProvider = dp;
			combobox_list.addEventListener(Event.CHANGE, listChangeListener);
			// cuz
			/*
			var dp:DataProvider = new DataProvider();
			for (var i:uint = 0; i < _model.routes.length; i++) {
				dp.addItem( {label:_model.routes[i].name, route:_model.routes[i] } );
			}
			
			// Combobox
			combobox_list.dataProvider = dp;
			combobox_list.addEventListener(Event.CHANGE, listChangeListener);
			*/
		}
	}
}