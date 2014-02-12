//nl.photoreality.map_editor.view.overlays.OverlayAddRoute
package nl.photoreality.map_editor.view.overlays {
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import nl.photoreality.map_editor.controller.Controller;
	import nl.photoreality.map_editor.controller.RouteController;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.map_editor.model.vo.FloorVO;
	
	
	public class OverlayAddRoute extends Sprite {
		
		private var _model				: Model;
		
		// stage instances
		public var btn_ok				: SimpleButton;
		public var btn_x				: SimpleButton;
		public var combobox_floor_end	: ComboBox;
		public var combobox_floor_start	: ComboBox;
		//public var txt_floor_start		: TextField;
		public var txt_name				: TextField;
		
		
		public function OverlayAddRoute()  {
			_model = Model.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
			init();
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
		}
		
		private function addListeners():void {
			btn_ok.addEventListener(MouseEvent.CLICK, btnOkListener);
			btn_x.addEventListener(MouseEvent.CLICK, btnCloseListener);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
		}
		
		private function removeListeners():void {
			btn_ok.removeEventListener(MouseEvent.CLICK, btnOkListener);
			btn_x.removeEventListener(MouseEvent.CLICK, btnCloseListener);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
		}
		
		
		//-- Button Listeners
		private function btnOkListener(e:MouseEvent):void {
			submit();
		}
		
		private function btnCloseListener(e:MouseEvent):void {
			Controller.getInstance().closeOverlay();
		}
		
		private function keyUpListener(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ENTER) {
				if (stage.focus == txt_name) {
					submit();
				}
			}
		}
		
		
		
		//-- Init
		private function init():void {
			stage.focus = txt_name;
			//txt_floor_start.text = Model.getInstance().floors[0].name;
			
			var dataProvider:DataProvider = new DataProvider();
			if ( _model.floors.length ) {
				for (var i:int = 0; i <  _model.floors.length; i++) {
					dataProvider.addItem( { "label": _model.floors[i].name, "floor":_model.floors[i] } );
				}
			}
			
			combobox_floor_end.dataProvider = dataProvider;
			combobox_floor_start.dataProvider = dataProvider;
		}
		
		
		//-- Submit
		private function submit():void {
			Controller.getInstance().closeOverlay();
			RouteController.getInstance().addRoute(txt_name.text, FloorVO(combobox_floor_start.selectedItem.floor), FloorVO(combobox_floor_end.selectedItem.floor));
		}
	}
}