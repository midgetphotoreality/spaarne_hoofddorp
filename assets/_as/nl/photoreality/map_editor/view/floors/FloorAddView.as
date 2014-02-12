//  nl.photoreality.map_editor.view.floors.FloorAddView
package nl.photoreality.map_editor.view.floors 
{
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import nl.photoreality.map_editor.controller.FloorController;
	import nl.photoreality.map_editor.model.vo.FloorVO;
	import nl.photoreality.map_editor.model.vo.IconVO;
	import nl.photoreality.utils.display.Provider;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class FloorAddView extends Provider
	{
		public var name_txt					: TextField;
		public var linkage_txt					: TextField;
		public var add_btn						: Button;
		private var _floorController			: FloorController
		public function FloorAddView() {
			_floorController = FloorController.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
			linkage_txt.text = name_txt.text = "";
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
		}
		
		private function addListeners():void {
			add_btn.addEventListener(MouseEvent.CLICK, handleAddClick);
		}
		
		private function removeListeners():void {
			add_btn.removeEventListener(MouseEvent.CLICK, handleAddClick);
		}
		
		private function handleAddClick(e:Event):void {
			var mc:MovieClip;
			var exists:Boolean 	=	 true;
			try {
				mc = MovieClip(provideMc(linkage_txt.text));
				trace("FloorAddView -> handleChangeClick - FLOOR MC EXISTS");
			}catch (err:Error){
				trace("FloorAddView -> handleChangeClick - Couldn't find floor mc with linkage name : " + linkage_txt.text);
				exists =	false;
			}
			if (exists) {
				_floorController.addFloor(new FloorVO(name_txt.text, linkage_txt.text, false, new Vector.<IconVO>));
			}
		}
	}

}