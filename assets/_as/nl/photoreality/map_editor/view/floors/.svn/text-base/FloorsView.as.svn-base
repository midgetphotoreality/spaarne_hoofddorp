// nl.photoreality.map_editor.view.floors.FloorsView
package nl.photoreality.map_editor.view.floors 
{
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nl.photoreality.map_editor.constants.OverlayConstants;
	import nl.photoreality.map_editor.controller.Controller;
	import nl.photoreality.map_editor.controller.FloorController;
	import nl.photoreality.map_editor.model.FloorModel;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.map_editor.model.vo.FloorVO;
	import nl.photoreality.map_editor.model.vo.IconVO;
	import nl.photoreality.map_editor.view.map.icons.Icon;
	import nl.photoreality.utils.display.Provider;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class FloorsView extends Provider
	{
		private var _model								: Model;
		private var _floorModel							: FloorModel;
		private var _controller							: Controller;
		private var _floorController					: FloorController;
		
		public var add_floor_btn						: Button;
		public var add_icon_btn							: Button;
		//public var remove_floor_btn						: Button;
		//public var save_btn								: Button;
		public var zoom_btn								: Button;
		public var floors_combo							: ComboBox;
		
		public var _floorsComboDataProvider 			: DataProvider	
		
		public var _container							: MovieClip;
		public var _floorContainer						: FloorContainer;
		public var _iconContainer						: MovieClip;
		
		//public var floor_add_panel_mc				: Sprite;
		//public var floor_info_panel_mc				: Sprite;
		//public var icon_info_panel_mc				: Sprite;
		//public var icon_view_mc							: MovieClip;
		
		public var _currentDragIcon						: MovieClip;
		public var _currentFloor						: FloorVO;
		
		public var _floorScale							: Number = 1;
		
		public function FloorsView() 
		{
			addEventListener(Event.ADDED_TO_STAGE, handleToStage);
			_model 								= Model.getInstance();
			_floorModel							= FloorModel.getInstance();
			_controller							= Controller.getInstance();
			_floorController					= FloorController.getInstance();
			_floorsComboDataProvider 			= new DataProvider();
			floors_combo.dataProvider 			= _floorsComboDataProvider;
			//floor_info_panel_mc.visible 		= false;
			//floor_add_panel_mc.visible = false;
		}
		
		private function handleToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, handleToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, handleFromStage);
			
			//save_btn.addEventListener(MouseEvent.CLICK, handleSaveClick);
			add_floor_btn.addEventListener(MouseEvent.CLICK, handleAddFloorClick);
			add_icon_btn.addEventListener(MouseEvent.CLICK, handleAddIconClick);
			//remove_floor_btn.addEventListener(MouseEvent.CLICK, handleRemoveFloorClick);
			zoom_btn.addEventListener(MouseEvent.CLICK, handleZoomClick);
			
			floors_combo.addEventListener(Event.CHANGE, handleComboChange);
			_floorModel.addEventListener(FloorModel.ADD_ICON_TO_FLOOR, handleAddIconToFloor);
			_iconContainer = new MovieClip();
			_model.addEventListener(Model.FLOORS_CHANGE, handleFloorsChange);
			init();
		}
		
		private function handleFromStage(e:Event):void {
			//save_btn.removeEventListener(MouseEvent.CLICK, handleSaveClick);
			add_floor_btn.removeEventListener(MouseEvent.CLICK, handleAddFloorClick);
			add_icon_btn.removeEventListener(MouseEvent.CLICK, handleAddIconClick);
			//remove_floor_btn.removeEventListener(MouseEvent.CLICK, handleRemoveFloorClick);
			
			removeEventListener(Event.REMOVED_FROM_STAGE, handleFromStage);
			floors_combo.removeEventListener(Event.CHANGE, handleComboChange);
			_floorModel.removeEventListener(FloorModel.ADD_ICON_TO_FLOOR, handleAddIconToFloor);
			_model.removeEventListener(Model.FLOORS_CHANGE, handleFloorsChange);
			zoom_btn.removeEventListener(MouseEvent.CLICK, handleZoomClick);
			deinit();
		}
		
		private function handleAddIconClick(e:MouseEvent):void 	{
			_controller.showOverlay(OverlayConstants.ADD_ICON);
		}
		
		private function handleZoomClick(e:MouseEvent):void {
			if (_floorScale == 1) {
				_floorScale = 1.7;
			}else {
				_floorScale = 1;
			}
			placePanels();
		}
		
		private function placePanels():void {
			_iconContainer.scaleX = _iconContainer.scaleY = _floorScale;
			_floorContainer.scaleX = _floorContainer.scaleY = _floorScale;
			//var offSet:int = 10;
			// floor_info_panel_mc
			// = floor_add_panel_mc.x 
			//icon_info_panel_mc.x = floor_info_panel_mc.x = _floorContainer.x + _floorContainer.width + offSet;
			//icon_view_mc.x = floor_info_panel_mc.x + floor_info_panel_mc.width + offSet;
			//icon_info_panel_mc.y = floor_info_panel_mc.y + floor_info_panel_mc.height + offSet;
		}
		
		private function init():void {
			trace("FloorsView -> init: " + _model.floors.length);
			deinit();
			_floorContainer = new FloorContainer();
			_floorContainer.x = _floorContainer.y = 0;
			_container.addChild(_floorContainer);
			_iconContainer.x = _iconContainer.y = 0;
			_container.addChild(_iconContainer);
			if ( _model.floors.length ) {
				for (var i:int = 0; i <  _model.floors.length; i++) {
					_floorsComboDataProvider.addItem( { "label": _model.floors[i].name, "floor":_model.floors[i] } );
					if (_floorModel.selectedFloor && _model.floors[i].name==_floorModel.selectedFloor.name) {
						floors_combo.selectedIndex = i;
					}
				}
				if (!_floorModel.selectedFloor) {
					_floorModel.selectedFloor = _model.floors[0];
				}
				showFloor( _floorModel.selectedFloor  );
				
			}
			
			placePanels();
		}
		
		private function deinit():void {
			while (_iconContainer.numChildren) {
				_iconContainer.removeChildAt(0);
			}
			while (_container.numChildren) {
				_container.removeChildAt(0);
			}
			_floorsComboDataProvider.removeAll();
			//while (numChildren) {
			//	removeChildAt(0);
			//	}
		}
		
		private function handleFloorsChange(e:Event):void {
			init();
		}
		
		/*
		private function handleRemoveFloorClick(e:MouseEvent):void {
			_floorController.removeFloor(FloorVO(floors_combo.selectedItem.floor));
		}
		*/
		
		private function handleAddFloorClick(e:MouseEvent):void {
			//floor_info_panel_mc.visible = false;
			//floor_add_panel_mc.visible = true;
			_controller.showOverlay(OverlayConstants.ADD_FLOOR);
		}
		
		/*private function handleSaveClick(e:MouseEvent):void {
			_controller.saveXML();
		}*/
		
		
		private function handleComboChange(e:Event):void {
			trace("FloorsView -> handleComboChange: " +floors_combo.selectedItem.floor);
			showFloor(floors_combo.selectedItem.floor);
		}
		
		private function showFloor(floor:FloorVO):void {
			trace("FloorsView -> showFloor: " +floor.name);
			_floorController.selectFloor(floor);
			//floor_info_panel_mc.visible = true;
			//floor_add_panel_mc.visible = false;
			removeIconListeners();
			_floorContainer.floor = floor;
			addIconListeners();
			placePanels();
		}
		
		
		private function handleAddIconToFloor(e:Event):void 	{
			_floorContainer.outline = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleIconDrag);
			_iconContainer.addEventListener(MouseEvent.CLICK, handleIconDragDone);
			_currentDragIcon			= _floorModel.currentDragIcon.iconMc;
			_currentDragIcon.x			= _iconContainer.mouseX;
			_currentDragIcon.y			= _iconContainer.mouseY;
			_iconContainer.addChild(_currentDragIcon);
			
			trace("FloorsView -> handleAddIconToFloor: ");
		}
		
		private function handleIconDragDone(e:MouseEvent):void {
			_floorContainer.outline = false;
			trace("FloorsView -> handleIconDragDone");
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleIconDrag);
			_iconContainer.removeEventListener(MouseEvent.CLICK, handleIconDragDone);
			_currentDragIcon.x			= _iconContainer.mouseX;
			_currentDragIcon.y			= _iconContainer.mouseY;
			_floorContainer.floor.icons.push( new IconVO(_floorModel.currentDragIcon.icon.name, _floorModel.currentDragIcon.icon.linkage, _currentDragIcon.x, _currentDragIcon.y) );
			_floorContainer.reinit();
			_iconContainer.removeChild(_currentDragIcon);
			addIconListeners();
		}
		
		private function handleIconClick(e:MouseEvent):void {
			placePanels();
			
			//MovieClip(e.target).scaleX = MovieClip(e.target).scaleY = 4;
			//trace("FloorsView -> handleIconClick: " + e.target);
			//trace("FloorsView -> handleIconClick: " + MovieClip(e.target).name);
			//trace("FloorsView -> handleIconClick: " + Icon(e.currentTarget).vo.name);
			_floorController.selectIcon(Icon(e.currentTarget));
		}
		private function addIconListeners():void {
			removeIconListeners();
			for (var i:int = 0; i < _floorContainer.icons.length; i++) { // muse be removed somewhere
				_floorContainer.icons[i].addEventListener(MouseEvent.CLICK, handleIconClick);
				//trace(i + " : " + _floorContainer.icons[i].vo.linkage);
				//trace(i + " : " + Icon(_floorContainer.icons[i]).vo.name);
				//trace("FloorsView -> Adding handleIconClick on icon, "+String(i) + " : " + Icon(_floorContainer.icons[i]).vo.name+" - "+MovieClip(_floorContainer.icons[i]).name);
			}
		}
		
		private function removeIconListeners():void {
			if (_floorContainer.icons){
				for (var i:int = 0; i < _floorContainer.icons.length; i++) { // muse be removed somewhere
					if (Icon(_floorContainer.icons[i]).hasEventListener(MouseEvent.CLICK)){
						_floorContainer.icons[i].removeEventListener(MouseEvent.CLICK, handleIconClick);
					}
				}
			}
		}
		
		private function handleIconDrag(e:MouseEvent):void {
			_currentDragIcon.x			= _iconContainer.mouseX;
			_currentDragIcon.y			= _iconContainer.mouseY;
			//trace("FloorsView -> handleIconDrag: ");
		}
	}
}