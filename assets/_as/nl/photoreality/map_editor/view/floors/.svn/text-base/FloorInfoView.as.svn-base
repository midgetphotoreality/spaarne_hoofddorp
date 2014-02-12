// nl.photoreality.map_editor.view.floors.FloorInfoView
package nl.photoreality.map_editor.view.floors 
{
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import nl.photoreality.map_editor.controller.FloorController;
	import nl.photoreality.map_editor.model.FloorModel;
	import nl.photoreality.utils.display.Provider;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class FloorInfoView extends Provider
	{
		public var name_txt					: TextField;
		public var linkage_txt					: TextField;
		public var icons_txt					: TextField;
		public var bf_txt							: TextField;
		public var change_btn					: Button;
		private var _floorModel				: FloorModel;
		private var _controller					: FloorController;
		
		public function FloorInfoView() 
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			_floorModel = FloorModel.getInstance();
			_controller = FloorController.getInstance();
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
			_floorModel.addEventListener(FloorModel.FLOOR_SELECT, handleFloorSwitch);
			change_btn.addEventListener(MouseEvent.CLICK, handleChangeClick);
		}
		
		private function removeListeners():void {
			_floorModel.removeEventListener(FloorModel.FLOOR_SELECT, handleFloorSwitch);
			change_btn.removeEventListener(MouseEvent.CLICK, handleChangeClick);
		}
		
			
		private function handleFloorSwitch(e:Event):void {
			name_txt.text 		= _floorModel.selectedFloor.name;
			linkage_txt.text 		= _floorModel.selectedFloor.linkage;
			icons_txt.text 		= String(_floorModel.selectedFloor.icons.length);
			bf_txt.text 			= String(_floorModel.selectedFloor.isBaseFloor);
		}
		
		private function handleChangeClick(e:MouseEvent):void {
			trace("FloorInfoView -> handleChangeClick");
			var mc:MovieClip;
			var exists:Boolean 	=	 true;
			try {
				mc = MovieClip(provideMc(linkage_txt.text));
				trace("FloorInfoView -> handleChangeClick - FLOOR MC EXISTS");
			}catch (err:Error){
				trace("FloorInfoView -> handleChangeClick - Couldn't find floor mc with linkage name : " + linkage_txt.text);
				exists =	false;
			}
			if (exists) {
				_floorModel.selectedFloor.name = name_txt.text ;
				_floorModel.selectedFloor.linkage = linkage_txt.text;
				_controller.floorChanged();
			}
		}
		
		
	}

}