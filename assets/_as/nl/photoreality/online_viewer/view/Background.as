// nl.photoreality.online_viewer.view.Background
package nl.photoreality.online_viewer.view 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.online_viewer.manager.MenuManager;
	import nl.photoreality.utils.debug.Debug;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class Background extends MovieClip
	{
		private var _isOnFirstFloor = true;
		public var floor_label_mc : MovieClip;
		public function Background() {
			addEventListener(Event.ADDED_TO_STAGE, handleToStage);
			floor_label_mc.visible = false;
		}
		
		private function handleToStage(e:Event):void {
			//RouteModel.getInstance().addEventListener(RouteModel.ROUTE_SELECTED, handleFloorSelected);
		//	MenuManager.getInstance().addEventListener(MenuManager.ROUTE_SELECTED , handleRouteSelected);
			RouteModel.getInstance().addEventListener(RouteModel.ROUTE_PLAY_FLOOR_CHANGED, handleFloorChanged);
			RouteModel.getInstance().addEventListener(RouteModel.ROUTE_SELECT_FLOOR_CHANGED, handleFloorSelect);
			addEventListener(Event.REMOVED_FROM_STAGE, handleFromStage);
		}
		
		
		private function handleFromStage(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, handleFromStage);
		//	RouteModel.getInstance().removeEventListener(RouteModel.ROUTE_SELECTED, handleFloorSelected);
			RouteModel.getInstance().removeEventListener(RouteModel.ROUTE_PLAY_FLOOR_CHANGED, handleFloorChanged);
			RouteModel.getInstance().removeEventListener(RouteModel.ROUTE_SELECT_FLOOR_CHANGED, handleFloorSelect);
		}
		
		private function handleFloorSelect(e:Event):void 
		{
			
			_isOnFirstFloor = false;
			floor_label_mc.label.text = RouteModel.getInstance().selectedRouteVO.floors[1].name;
			if (RouteModel.getInstance().selectedFloor == 0) {
				_isOnFirstFloor = true;
				floor_label_mc.label.text = RouteModel.getInstance().selectedRouteVO.floors[0].name;
			}
			Debug.log("Background -> handleFloorSelect: "+_isOnFirstFloor,true)
			//handleFloorChanged(e);
		}
		
		public function openCallback() {
			floor_label_mc.visible = true
		}

		public function closeCallback() {
			floor_label_mc.visible = false
		}
		
		private function handleFloorChanged(e:Event):void 
		{
			
			Debug.log("Background -> handleFloorChanged",true)
			//if (RouteModel.getInstance().selectedRouteVO.floors.length == 2) {
			//	if (RouteModel.getInstance().selectedRouteVO.floors[0].id != RouteModel.getInstance().selectedRouteVO.floors[1].id) {
					if (_isOnFirstFloor) {
						floor_label_mc.label.text = RouteModel.getInstance().selectedRouteVO.floors[1].name;
					}else {
						floor_label_mc.label.text = RouteModel.getInstance().selectedRouteVO.floors[0].name;
					}
					_isOnFirstFloor = !_isOnFirstFloor;
					Debug.log("Background -> handleFloorChanged, switching floors: " + _isOnFirstFloor,true);
			//	}
			//}
			//_isOnFirstFloor = !_isOnFirstFloor;
			//floor_label_mc.label.text = RouteModel.getInstance().selectedRouteVO.
		}
		
		private function handleFloorSelected(e:Event):void 
		{
			_isOnFirstFloor = true;
			floor_label_mc.label.text = RouteModel.getInstance().selectedRouteVO.floors[0].name;
			trace( "Background -> handleFloorChanged: "+floor_label_mc.label.text )
		}
		
		private function handleRouteSelected(e:Event):void 
		{
			_isOnFirstFloor = true;
			floor_label_mc.label.text = RouteModel.getInstance().selectedRouteVO.floors[0].name;
			trace( "Background -> handleRouteSelected: "+floor_label_mc.label.text )
		}
		
		
	}

}