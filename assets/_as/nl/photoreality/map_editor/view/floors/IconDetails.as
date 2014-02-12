// nl.photoreality.map_editor.view.floors.IconDetails
package nl.photoreality.map_editor.view.floors 
{
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import nl.photoreality.map_editor.controller.FloorController;
	import nl.photoreality.map_editor.model.FloorModel;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.map_editor.view.map.icons.Icon;
	import nl.photoreality.utils.display.Provider;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class IconDetails extends Provider
	{
		private var _floorModel		: FloorModel;
		private var _floorController		: FloorController;
		private var _model			: Model;
		
		public var txt_name			: TextField;
		public var txt_x			: TextField;
		public var txt_y			: TextField;
		public var txt_rot			: TextField;
		
		public var btn_remove		: SimpleButton;
		public var btn_update		: SimpleButton;
		public var btn_close		: SimpleButton;
		
		public var _container				: MovieClip;
		
		public function IconDetails() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			_floorModel		= FloorModel.getInstance();
			_floorController		= FloorController.getInstance();
			//alpha = 0;
			TweenPlugin.activate([AutoAlphaPlugin])
			hide(true);
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
			txt_x.restrict = txt_y.restrict = txt_rot.restrict = "1234567890.";
			_floorModel.addEventListener(FloorModel.FLOOR_SELECT, handleFloorSwitch);
			_floorModel.addEventListener(FloorModel.ICON_SELECT, handleIconSelect);
			//btn_update.addEventListener(MouseEvent.CLICK, handleChangeClick);
			//btn_remove.addEventListener(MouseEvent.CLICK, handleRemoveClick);
		}
		
		private function removeListeners():void {
			_floorModel.removeEventListener(FloorModel.FLOOR_SELECT, handleFloorSwitch);
			_floorModel.removeEventListener(FloorModel.ICON_SELECT, handleIconSelect);
			//btn_update.removeEventListener(MouseEvent.CLICK, handleChangeClick);
			//btn_remove.removeEventListener(MouseEvent.CLICK, handleRemoveClick);
		}
		
		private function addButtonListeners():void {
			btn_close.addEventListener(MouseEvent.CLICK, btnCloseListener);
			btn_remove.addEventListener(MouseEvent.CLICK, btnRemoveListener);
			btn_update.addEventListener(MouseEvent.CLICK, btnUpdateListener);
			
		//	btn_startLabelPosition.addEventListener(LabelPositionWidget.POSITION_CHANGED, handlePositionChange);
		//	btn_endLabelPosition.addEventListener(LabelPositionWidget.POSITION_CHANGED, handlePositionChange);
		}
		
		private function removeButtonListeners():void {
			btn_close.removeEventListener(MouseEvent.CLICK, btnCloseListener);
			btn_remove.removeEventListener(MouseEvent.CLICK, btnRemoveListener);
			btn_update.removeEventListener(MouseEvent.CLICK, btnUpdateListener);
			
			//btn_startLabelPosition.removeEventListener(LabelPositionWidget.POSITION_CHANGED, handlePositionChange);
			//btn_endLabelPosition.removeEventListener(LabelPositionWidget.POSITION_CHANGED, handlePositionChange);
		}
		
		/*
		private function initIcons():void {
			trace("FloorDetails -> init(), _model.icons: " + _model.icons.length);
			var icon		: IconHolder	
			for (var i:int = 0; i < _model.icons.length; i++) {
				icon = new IconHolder(IconVO(_model.icons[i]));
				icon.x = i*(IconHolder.WIDTH+5)
				iconContainer.addChild(icon);
			}
		}
		*/
		
		private function btnCloseListener(e:MouseEvent):void {
			hide();
		}
		
		private function btnRemoveListener(e:MouseEvent):void {
			//_controller.removeFloor(_floorModel.selectedFloor);
			_floorController.deleteIcon(_floorModel.selectedIcon.vo);
		}
		
		private function btnUpdateListener(e:MouseEvent):void {
			trace ("IconDetails -> btnUpdateListener()")
			changeIcon();
		}
		
		private function handleFloorSwitch(e:Event):void {
			hide();
			//txt_name.text 				= _floorModel.selectedFloor.name;
			//txt_linkage.text 			= _floorModel.selectedFloor.linkage;
			//txt_icon_amount.text 		= String(_floorModel.selectedFloor.icons.length);
			//txt_basefloor.text 			= String(_floorModel.selectedFloor.isBaseFloor);
		}
		
		private function handleIconSelect(e:Event):void {
			visible = true;
			txt_name.text = _floorModel.selectedIcon.vo.name;
			txt_x.text = String(_floorModel.selectedIcon.vo.x);
			txt_y.text = String(_floorModel.selectedIcon.vo.y);
			txt_rot.text = String(_floorModel.selectedIcon.vo.rotation);
			while (_container.numChildren) {
				_container.removeChildAt(0);
			}
			var previewIcon	: Icon;
			previewIcon	= Icon(provideMc(_floorModel.selectedIcon.vo.linkage));
			previewIcon.rotation = _floorModel.selectedIcon.vo.rotation;
			_container.addChild(previewIcon);
			showConnectionLine();
			show();
		}
		
		private function changeIcon():void {
			trace ("IconDetails -> changeIcon()")
			_floorModel.selectedIcon.vo.name 			= txt_name.text;
			_floorModel.selectedIcon.vo.x				= Number(txt_x.text);
			_floorModel.selectedIcon.vo.y				= Number(txt_y.text);
			_floorModel.selectedIcon.vo.rotation 		= Number(txt_rot.text);
			_floorController.floorChanged();
			//handleIconSelect(null);
		}
		
		//-- Show
		private function show(directly:Boolean = false):void {
			addButtonListeners();
			trace("IconDetails -> show()) alpha: "+alpha)
			var duration:Number = 0.3;
			if (directly) {
				duration = 0;
			}
			TweenLite.to(this, duration, { autoAlpha:1 } );
		}
		
		private function hide(directly:Boolean = false):void {
			removeButtonListeners();
			
			var duration:Number = 0.3;
			if (directly) {
				duration = 0;
			}
			TweenLite.to(this, duration, { autoAlpha:0 } );
		}
		
		//-- Line
		private function showConnectionLine():void {
			var globalPoint:Point = _floorModel.selectedIcon.parent.localToGlobal(new Point(_floorModel.selectedIcon.x, _floorModel.selectedIcon.y));
			var local:Point = this.globalToLocal(globalPoint);
			graphics.clear();
			graphics.lineStyle(2, 0x000000, 0.2);
			graphics.moveTo(4, 35);
			graphics.lineTo(local.x, local.y);
		}
		
		private function hideConnectionLine():void {
			graphics.clear();
		}
		
	}

}