// nl.photoreality.map_editor.view.floors.FloorDetails
package nl.photoreality.map_editor.view.floors 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import nl.photoreality.map_editor.controller.FloorController;
	import nl.photoreality.map_editor.model.FloorModel;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.map_editor.model.vo.IconVO;
	import nl.photoreality.map_editor.view.floors.icon.IconHolder;
	import nl.photoreality.utils.display.Provider;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class FloorDetails extends Provider
	{
		private var _floorModel		: FloorModel;
		private var _controller		: FloorController;
		private var _model			: Model;
		
		public var txt_name			: TextField;
		public var txt_linkage		: TextField;
		public var txt_basefloor	: TextField;
		public var txt_version		: TextField;
		public var txt_line_tickness	: TextField;
		public var txt_line_color	: TextField;
		
		public var btn_remove		: SimpleButton;
		public var btn_update		: SimpleButton;
		
		public var iconContainer	: MovieClip;
		
		public function FloorDetails() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			_floorModel 			= FloorModel.getInstance();
			_controller 			= FloorController.getInstance();
			_model 					= Model.getInstance();
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
			initIcons();
			_floorModel.addEventListener(FloorModel.FLOOR_SELECT, handleFloorSwitch);
			_model.addEventListener(Model.ICON_ADDED, handleIconAdded);
			btn_update.addEventListener(MouseEvent.CLICK, handleChangeClick);
			btn_remove.addEventListener(MouseEvent.CLICK, handleRemoveClick);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
		}
		
		private function removeListeners():void {
			_model.addEventListener(Model.ICON_ADDED, handleIconAdded);
			_floorModel.removeEventListener(FloorModel.FLOOR_SELECT, handleFloorSwitch);
			btn_update.removeEventListener(MouseEvent.CLICK, handleChangeClick);
			btn_remove.removeEventListener(MouseEvent.CLICK, handleRemoveClick);
			
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
		}
		
		private function handleIconAdded(e:Event):void {
			initIcons();
		}
		
		private function initIcons():void {
			trace("FloorDetails -> init(), _model.icons: " + _model.icons.length);
			while (iconContainer.numChildren) {
				iconContainer.removeChildAt(0);
			}
			var icon		: IconHolder	
			for (var i:int = 0; i < _model.icons.length; i++) {
				icon = new IconHolder(IconVO(_model.icons[i]));
				icon.x = i*(IconHolder.WIDTH+5)
				iconContainer.addChild(icon);
			}
		}
		
		private function handleRemoveClick(e:MouseEvent):void {
			_controller.removeFloor(_floorModel.selectedFloor);
		}
		
		private function handleChangeClick(e:MouseEvent):void {
			if (isValidAssetMc(txt_linkage.text)) {
				_floorModel.selectedFloor.name = txt_name.text ;
				_floorModel.selectedFloor.linkage = txt_linkage.text;
				
				_model.settings.version = txt_version.text;
				_model.settings.lineThickness = uint(txt_line_tickness.text);
				_model.settings.lineColor = uint(txt_line_color.text);
				
				_controller.floorChanged();
			}
			else {
				trace("FloorDetails -> handleChangeClick, not a valid linkage dude!");
			}
		}
		
		private function handleFloorSwitch(e:Event):void {
			txt_name.text 				= _floorModel.selectedFloor.name;
			txt_linkage.text 			= _floorModel.selectedFloor.linkage;
			//txt_icon_amount.text 		= String(_floorModel.selectedFloor.icons.length);
			txt_basefloor.text 			= String(_floorModel.selectedFloor.isBaseFloor);
			
			txt_version.text 			= String(_model.settings.version);
			txt_line_tickness.text		= String(_model.settings.lineThickness);
			txt_line_color.text			= String(_model.settings.lineColor);
		}
		
		
		
		private function keyUpListener(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ENTER) {
				if ((stage.focus == txt_basefloor)  ||  (stage.focus == txt_version)  ||  (stage.focus == txt_linkage)  ||  (stage.focus == txt_name) ||  (stage.focus == txt_line_tickness) ||  (stage.focus == txt_line_color)) {
					handleChangeClick(null);
				}
			}
		}
	}

}