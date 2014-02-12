// nl.photoreality.map_editor.view.map.icons.EntranceIcon
package nl.photoreality.map_editor.view.map.icons 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nl.photoreality.map_editor.controller.Controller;
	/**
	 * ...
	 * @author Miguel Fuentes // DioVoiD 2012
	 */
	public class EntranceIcon extends MovieClip
	{
		private var _controller 			: Controller;
		
		public function EntranceIcon() 
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
			_controller.addEntranceIcon(this);
			addEventListener(MouseEvent.CLICK, handleIconClick);
		}
		
		
		private function removeListeners():void {
			removeEventListener(MouseEvent.CLICK, handleIconClick);
		}
		
		private function handleIconClick(e:MouseEvent):void 	{
			// if editmode blah
			trace("EntranceIcon -> click");
			//_controller.startDrawingRoute(this);
		}
	}

}