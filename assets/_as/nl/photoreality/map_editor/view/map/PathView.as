// nl.photoreality.map_editor.view.map.PathView 
package nl.photoreality.map_editor.view.map 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import nl.photoreality.map_editor.controller.Controller;
	import nl.photoreality.map_editor.model.Model;
	/**
	 * ...
	 * @author Miguel Fuentes // DioVoiD 2012
	 */
	public class PathView extends MovieClip
	{
		
		public var output				: TextField;
		private var _controller 			: Controller;
		private var _model 				: Model;
		
		public function PathView() 
		{
			addEventListener(Event.ADDED_TO_STAGE, handleToStage);
			_controller 		= Controller.getInstance();
			_model 			= Model.getInstance();
		}
		
		private function handleToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, handleToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, handleFromStage);
			addListeners();
		}
		
		private function handleFromStage(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, handleFromStage);
			removeListeners();
		}
		
		private function addListeners():void {
				_model.addEventListener(Model.ROUTE_POINT_CREATED, handleNewRoutePoint);
		}
		
		private function removeListeners():void {
				_model.removeEventListener(Model.ROUTE_POINT_CREATED, handleNewRoutePoint);
		}
		
		private function handleNewRoutePoint(e:Event):void 	{
			/*output.text = "";
			for (var i:int = 0; i < _model.currentRoute.length ; i++) {
				if (i == 0) {
					output.appendText("Start: " +_model.currentPathEntranceIcon.name+ " on: " + Point(_model.currentRoute[i]).x + "," + Point(_model.currentRoute[i]).y + "\n");
				}else {
					output.appendText("Point " + i + " on: " + Point(_model.currentRoute[i]).x + "," + Point(_model.currentRoute[i]).y + "\n");
				}
			}*/
		}
	}

}