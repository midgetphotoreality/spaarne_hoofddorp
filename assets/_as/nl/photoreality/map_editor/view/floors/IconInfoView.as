// nl.photoreality.map_editor.view.floors.IconInfoView
package nl.photoreality.map_editor.view.floors 
{
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import nl.photoreality.map_editor.controller.FloorController;
	import nl.photoreality.map_editor.model.FloorModel;
	import nl.photoreality.map_editor.view.map.icons.Icon;
	import nl.photoreality.utils.display.Provider;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class IconInfoView extends Provider
	{
		public var change_btn				: Button;
		public var name_txt					: TextField;
		public var xPos						: TextField;
		public var yPos						: TextField;
		public var rotVal					: TextField;
		public var _container				: MovieClip;
		
		private var _floorModel				: FloorModel;
		private var _floorController		: FloorController;
		
		public function IconInfoView() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			_floorModel		= FloorModel.getInstance();
			_floorController		= FloorController.getInstance();
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
			visible = false;
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
		}
		
		private function addListeners():void {
			_floorModel.addEventListener(FloorModel.ICON_SELECT, handleIconSelect);
			change_btn.addEventListener(MouseEvent.CLICK, handleChangeClick);
			rotVal.addEventListener(Event.CHANGE , handleChange);
			yPos.addEventListener(Event.CHANGE , handleChange);
			xPos.addEventListener(Event.CHANGE , handleChange);
			yPos.restrict = rotVal.restrict = xPos.restrict = "1234567890.";
		}
		
		private function removeListeners():void {
			_floorModel.removeEventListener(FloorModel.ICON_SELECT, handleIconSelect);
			change_btn.removeEventListener(MouseEvent.CLICK, handleChangeClick);
			yPos.restrict = rotVal.restrict = xPos.restrict = "1234567890.";
			rotVal.removeEventListener(Event.CHANGE , handleChange);
			yPos.removeEventListener(Event.CHANGE , handleChange);
			xPos.removeEventListener(Event.CHANGE , handleChange);
		}
		
		private function handleChange(e:Event):void 	{
			changeIcon();
		}
		
		private function changeIcon():void {
			_floorModel.selectedIcon.vo.name 		= name_txt.text;
			_floorModel.selectedIcon.vo.x				= Number(xPos.text);
			_floorModel.selectedIcon.vo.y				= Number(yPos.text);
			_floorModel.selectedIcon.vo.rotation 	= Number(rotVal.text);
			_floorController.floorChanged();
			handleIconSelect(null);
		}
		
		private function handleChangeClick(e:MouseEvent):void {
			changeIcon();
		}
		
		private function handleIconSelect(e:Event):void {
			visible = true;
			name_txt.text = _floorModel.selectedIcon.vo.name;
			xPos.text = String(_floorModel.selectedIcon.vo.x);
			yPos.text = String(_floorModel.selectedIcon.vo.y);
			rotVal.text = String(_floorModel.selectedIcon.vo.rotation);
			while (_container.numChildren) {
				_container.removeChildAt(0);
			}
			var previewIcon	: Icon;
			previewIcon	= Icon(provideMc(_floorModel.selectedIcon.vo.linkage));
			previewIcon.rotation = _floorModel.selectedIcon.vo.rotation;
			_container.addChild(previewIcon);
		}
		
	}

}