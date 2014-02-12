// nl.photoreality.map_editor.view.route.RouteOffsetFixer
package nl.photoreality.map_editor.view.route 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.map_editor.model.vo.RoutePointVO;
	import nl.photoreality.map_editor.model.vo.RouteVO;
	import nl.photoreality.utils.debug.Debug;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class RouteOffsetFixer extends MovieClip
	{
		public var txt_x:TextField;
		public var txt_y:TextField;
		public var txt_status:TextField;
		public var btn_update:SimpleButton;
		public var _routeModel:RouteModel;
		
		public function RouteOffsetFixer() 
		{
			_routeModel = RouteModel.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
		}
		
		private function addListeners():void {
			txt_x.text = "0";
			txt_y.text = "0";
			btn_update.addEventListener(MouseEvent.CLICK, handleReset);
		}
		private function removeListeners():void {
			btn_update.removeEventListener(MouseEvent.CLICK, handleReset);
		}
		
		private function handleReset(e:MouseEvent):void {
			var _firstFloor: Boolean = true;
			var prevPoint:RoutePointVO;
			var point:RoutePointVO;
			var route: RouteVO;
			txt_status.text = "handleReset: " + Model.getInstance().routes.length;
			for (var j:int = 0; j < Model.getInstance().routes.length; j++) {
				route = Model.getInstance().routes[j];
				txt_status.text = "Updating route " + String(j + 1) + "/" + Model.getInstance().routes.length+": " + route.name;
				
				_firstFloor = true;
				for (var i:int = 1; i < route.points.length; i++) {
					prevPoint = route.points[i-1];
					point = route.points[i];
					if (point.floorId != prevPoint.floorId) {
						_firstFloor = false;
					}
					if (!_firstFloor) {
						point.x = point.x + int(txt_x.text);
						point.y = point.y + int(txt_y.text);
					}
				}
			}
			Debug.log("RouteOffsetFixer -> handleReset DONE");
			/*
				var _firstFloor: Boolean = true;
				var prevPoint:RoutePointVO;
				var point:RoutePointVO;
				for (var i:int = 1; i < _routeModel.selectedRouteVO.points.length; i++) {
					prevPoint = _routeModel.selectedRouteVO.points[i-1];
					point = _routeModel.selectedRouteVO.points[i];
					if (point.floorId != prevPoint.floorId) {
						_firstFloor = false;
					}
					if (!_firstFloor) {
						point.x = point.x + int(txt_x.text);
						point.y = point.y + int(txt_y.text);
					}
				}
			*/
		}
	}

}