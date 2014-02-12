//nl.photoreality.map_editor.view.menu.MenuMain 
package nl.photoreality.map_editor.view.menu {
	
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import nl.photoreality.map_editor.constants.EditorConstants;
	import nl.photoreality.map_editor.controller.Controller;
	
	
	public class MenuMain extends MovieClip {
		
		private var _controller			: Controller;
		
		// stage instances
		public var btn_editor_floor		: SimpleButton;
		public var btn_editor_icon		: SimpleButton;
		public var btn_editor_route		: SimpleButton;
		public var btn_save				: SimpleButton;
		public var txt_title			: TextField;
		
		
		public function MenuMain()  {
			_controller = Controller.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
			
			txt_title.text = "PhotoReality - Map Editor v" + EditorConstants.VERSION;
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
		}
		
		private function addListeners():void {
			btn_editor_floor.addEventListener(MouseEvent.CLICK, btnEditorFloorListener);
			btn_editor_icon.addEventListener(MouseEvent.CLICK, btnEditorIconListener);
			btn_editor_route.addEventListener(MouseEvent.CLICK, btnEditorRouteListener);
			btn_save.addEventListener(MouseEvent.CLICK, btnSaveListener);
		}
		
		private function removeListeners():void {
			btn_editor_floor.removeEventListener(MouseEvent.CLICK, btnEditorFloorListener);
			btn_editor_icon.removeEventListener(MouseEvent.CLICK, btnEditorIconListener);
			btn_editor_route.removeEventListener(MouseEvent.CLICK, btnEditorRouteListener);
			btn_save.removeEventListener(MouseEvent.CLICK, btnSaveListener);
		}
		
		
		//-- Button Listeners
		private function btnEditorFloorListener(e:MouseEvent):void {
			_controller.showEditor(EditorConstants.EDITOR_FLOOR);
		}
		
		private function btnEditorIconListener(e:MouseEvent):void {
			_controller.showEditor(EditorConstants.EDITOR_ICON);
		}
		
		private function btnEditorRouteListener(e:MouseEvent):void {
			_controller.showEditor(EditorConstants.EDITOR_ROUTE);
		}
		
		private function btnSaveListener(e:MouseEvent):void {
			_controller.saveXML();
		}
	}
}