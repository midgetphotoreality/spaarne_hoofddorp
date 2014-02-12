//nl.photoreality.map_editor.view.overlays.OverlayAddPanorama
package nl.photoreality.map_editor.view.overlays {
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import nl.photoreality.map_editor.controller.Controller;
	import nl.photoreality.map_editor.controller.FloorController;
	import nl.photoreality.map_editor.controller.RouteController;
	import nl.photoreality.map_editor.manager.PanoAssetsLoadManager;
	import nl.photoreality.map_editor.model.vo.FloorVO;
	import nl.photoreality.map_editor.model.vo.IconVO;
	import nl.photoreality.utils.display.Provider;
	
	public class OverlayAddPanorama extends Provider {
		
		// stage instances
		public var btn_ok				: SimpleButton;
		public var btn_x				: SimpleButton;
		public var txt_linkage			: TextField;
		public var txt_info				: TextField;
		
		
		public function OverlayAddPanorama()  {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
			stage.focus = txt_linkage;
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
				if (stage.focus == txt_linkage) {
					submit();
				}
			}
		}
		
		
		
		//-- Submit
		private function submit():void {
			
			if ( txt_linkage.text == "" || txt_linkage.text == "-") {
				Controller.getInstance().closeOverlay();
				RouteController.getInstance().routePanoDialogClose(txt_linkage.text);
			}else {
				txt_info.text = "Testing jpg, one moment ...";
				PanoAssetsLoadManager.getInstance().addEventListener(PanoAssetsLoadManager.PANO_EXISTS, handleExists);
				PanoAssetsLoadManager.getInstance().addEventListener(PanoAssetsLoadManager.PANO_FAIL, handleFail);
				PanoAssetsLoadManager.getInstance().jpgPanoExists(txt_linkage.text);
			}
			
			/*if ( isValidPanorama(txt_linkage.text) || txt_linkage.text == "" || txt_linkage.text == "-") {
				Controller.getInstance().closeOverlay();
				RouteController.getInstance().routePanoDialogClose(txt_linkage.text)
				// 
				//FloorController.getInstance().addIcon(new IconVO(txt_name.text, txt_linkage.text));
			}else {
				trace("invalid linkage dude");
			}*/
		}
		
		private function handleFail(e:Event):void {
			txt_info.text = "The panorama doesn't exist!";
		}
		
		private function handleExists(e:Event):void {
			txt_info.text = "";
			Controller.getInstance().closeOverlay();
			RouteController.getInstance().routePanoDialogClose(txt_linkage.text);
		}
	}
}