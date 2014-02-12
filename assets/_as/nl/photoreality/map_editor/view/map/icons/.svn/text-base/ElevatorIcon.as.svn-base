// nl.photoreality.map_editor.view.map.icons.ElevatorIcon 
package nl.photoreality.map_editor.view.map.icons 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import nl.photoreality.map_editor.controller.Controller;
	/**
	 * ...
	 * @author Miguel Fuentes // DioVoiD 2012
	 */
	public class ElevatorIcon extends MovieClip
	{
		private var _controller 			: Controller;
		
		public function ElevatorIcon() 
		{
			addEventListener(Event.ADDED_TO_STAGE, handleToStage);
			_controller 		= Controller.getInstance();
		}
		
		private function handleToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, handleToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, handleFromStage);
			addListeners();
		}
		
		private function handleFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, handleFromStage);
			removeListeners();
		}
		
		private function addListeners():void {
			trace("ElevatorIcon doing addElevatorIcon : "+name)
			_controller.addElevatorIcon(this);
			
		}
		
		
		private function removeListeners():void {
			
		}
		
		public function hitTest(p:Point):Boolean { // stupid flash hittest wont work
			if (p.x < x -(width / 2) ) { // links erbuiten
				return false;
			}
			if (p.x > x + (width / 2) ) { // rechts buiten
				return false;
			}
			if (p.y < y - (height / 2) ) { // boven buiten
				return false;
			}
			if (p.y > y + (height / 2) ) { // onder buiten
				return false;
			}
			return true;
			
			if ( hitTestPoint(p.x, p.y) ) {
				return true;
			}
			return false;
		}
	}

}