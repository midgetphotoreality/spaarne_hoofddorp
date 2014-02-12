//nl.photoreality.map_editor.view.overlays.OverlayPanoramaContainer
package nl.photoreality.map_editor.view.overlays {
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nl.photoreality.map_editor.controller.Controller;
	import nl.photoreality.map_editor.controller.RouteController;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.panorama.model.PanoramaModel;
	
	
	public class OverlayPanoramaContainer extends Sprite {
		
		private var _model				: Model;
		private var _modelPanorama		: PanoramaModel;
		private var _modelRoute			: RouteModel;
		
		// stage instances
		public var btn_next				: SimpleButton;
		public var btn_x				: SimpleButton;
		public var container_mc			: MovieClip;
		
		
		public function OverlayPanoramaContainer()  {
			_model = Model.getInstance();
			_modelPanorama = PanoramaModel.getInstance();
			_modelRoute = RouteModel.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
			init();
			
			hideButtonNext();
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
			destroy();
		}
		
		private function addListeners():void {
			btn_next.addEventListener(MouseEvent.CLICK, btnNextListener);
			btn_x.addEventListener(MouseEvent.CLICK, btnCloseListener);
			
			_modelPanorama.addEventListener(PanoramaModel.INIT, panoInitListener);
			_modelPanorama.addEventListener(PanoramaModel.MANUAL_ROTATION, panoManualRotationListener);
		}
		
		private function removeListeners():void {
			btn_next.removeEventListener(MouseEvent.CLICK, btnNextListener);
			btn_x.removeEventListener(MouseEvent.CLICK, btnCloseListener);
			
			_modelPanorama.removeEventListener(PanoramaModel.INIT, panoInitListener);
			_modelPanorama.removeEventListener(PanoramaModel.MANUAL_ROTATION, panoManualRotationListener);
		}
		
		
		//-- Button Listeners
		private function btnCloseListener(e:MouseEvent):void {
			Controller.getInstance().closeOverlay();
		}
		
		private function btnNextListener(e:MouseEvent):void {
			RouteController.getInstance().playRouteNextPoint();
			hideButtonNext();
		}
		
		
		//-- Model Listeners
		private function panoInitListener(e:Event):void {
			hideButtonNext();
		}
		
		private function panoManualRotationListener(e:Event):void {
			showButtonNext();
		}
		
		
		
		
		
		
		
		//-- Init
		private function init():void {
			destroy();
			
			if (_model.panorama) {
				container_mc.addChild(_model.panorama.content);
			}
		}
		
		private function destroy():void {
			while (container_mc.numChildren) {
				container_mc.removeChildAt(0);
			}
		}
		
		
		
		//-- Next Button
		private function showButtonNext():void {
			btn_next.visible = true;
			btn_next.enabled = true;
		}
		
		private function hideButtonNext():void {
			btn_next.visible = false;
			btn_next.enabled = false;
		}
	}
}