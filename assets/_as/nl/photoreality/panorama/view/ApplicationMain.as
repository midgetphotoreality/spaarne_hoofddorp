//nl.photoreality.panorama.view.ApplicationMain
package nl.photoreality.panorama.view {
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import nl.photoreality.panorama.model.PanoramaModel;
	import nl.photoreality.panorama.view.panorama.PanoramaDesktop;
	
	
	public class ApplicationMain extends Sprite {
		
		private var _model		: PanoramaModel;
		private var _panorama	: PanoramaDesktop;
		private var _stage3D	: Stage3D;
		
		
		public function ApplicationMain() {
			_model = PanoramaModel.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			
			_stage3D = stage.stage3Ds[0];
			_stage3D.addEventListener(Event.CONTEXT3D_CREATE, context3DcreateListener);
			_stage3D.requestContext3D();
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			_stage3D.removeEventListener(Event.CONTEXT3D_CREATE, context3DcreateListener);
			_model.removeEventListener(PanoramaModel.INIT, initListener);
			_model.removeEventListener(PanoramaModel.ROTATION, rotationListener);
			_model.removeEventListener(PanoramaModel.TRANSITION, transitionListener);
			
			if (_panorama) {
				removeChild(_panorama);
			}
			
			_stage3D.context3D.dispose();
		}
		
		private function context3DcreateListener(e:Event):void {
			_stage3D.removeEventListener(Event.CONTEXT3D_CREATE, context3DcreateListener);
			init();
		}
		
		private function init():void {
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.align = StageAlign.TOP_LEFT;
			
			_panorama = new PanoramaDesktop(_stage3D);
			addChild(_panorama);
			
			_model.addEventListener(PanoramaModel.INIT, initListener);
			_model.addEventListener(PanoramaModel.ROTATION, rotationListener);
			_model.addEventListener(PanoramaModel.TRANSITION, transitionListener);
			
			
			/// TEMP
			//var linkageClass:Class = getDefinitionByName("panoramaTestBitmapData1") as Class;
			//var bmpd:BitmapData = new linkageClass(0, 0) as BitmapData;
			//_panorama.init(new PanoramaVO(_model.panoramaVO.name, _model.panoramaVO.linkage, _model.panoramaVO.angleTransitionIn, 45), _model.panoramaBitmapData);
		}
		
		
		//-- Listeners
		private function initListener(e:Event):void {
			_panorama.doInit(_model.panoramaVO, _model.panoramaBitmapData);
		}
		
		private function rotationListener(e:Event):void {
			_panorama.doRotation(_model.rotation, _model.durationRotation);
		}
		
		private function transitionListener(e:Event):void {
			_panorama.doTransition(_model.panoramaVO, _model.panoramaBitmapData, _model.durationTransition);
		}
	}
}
