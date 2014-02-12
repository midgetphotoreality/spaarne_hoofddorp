//nl.photoreality.panorama.view.panorama.PanoramaDesktop
package nl.photoreality.panorama.view.panorama {
	
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import nl.photoreality.map_editor.model.vo.PanoramaVO;
	import nl.photoreality.panorama.model.PanoramaModel;
	import nl.photoreality.utils.debug.Debug;
	
	
	public class PanoramaDesktop extends Sprite {
		
		private const PANORAMA_HEIGHT		: uint		= 320;
		private const PANORAMA_WIDTH		: uint		= 550;
		
		private const IMAGE_HEIGHT			: uint		= 1024;
		private const IMAGE_WIDTH			: uint		= 2048;
		private const CYLINDER_RADIUS		: Number	= IMAGE_WIDTH / 2 / Math.PI;
		
		private var _panoramaBitmapData		: BitmapData;
		private var _panoramaVO				: PanoramaVO;
		
		private var _panoramaNewBitmapData	: BitmapData;
		private var _panoramaNewVO			: PanoramaVO;
		
		private var _durationRotation		: Number;
		private var _durationTransition		: Number;
		
		private var _camera					: Camera3D;
		private var _cylinder1				: Cylinder;
		private var _cylinder2				: Cylinder;
		private var _cylinderActive			: Cylinder;
		private var _material				: TextureMaterial;
		private var _materialTemp			: TextureMaterial;
		private var _rootContainer			: Object3D;
		private var _stage3D				: Stage3D;
		
		private var _cameraTween			: TweenLite;
		private var _cylinderTween			: TweenLite;
		private var _materialTween			: TweenLite;
		
		private var _clickCylinderRotation	: Number;
		private var _clickMousePosition		: Number;
		
		//private var _txtTitle				: TextField;
		
		
		public function PanoramaDesktop(stage3D:Stage3D):void {
			_stage3D = stage3D;
			createScene();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		private function addedToStageListener(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addScene();
			addListeners();
			addMouseListeners();
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
			removeMouseListeners();
			destroyTweens(false);
			destroy();
		}
		
		private function destroyTweens(withComplete:Boolean = true):void {
			//Debug.log("DESTROOOOOOOOOOOOOY PANOOOO");
			if (_cameraTween) {
				if (withComplete && _cameraTween.active) {
					_cameraTween.complete();
				}
				_cameraTween.kill();
			}
			if (_cylinderTween) {
				if (withComplete && _cylinderTween.active) {
					_cylinderTween.complete();
				}
				_cylinderTween.kill();
			}
			if (_materialTween) {
				if (withComplete && _materialTween.active) {
					_materialTween.complete();
				}
				_materialTween.kill();
			}
		}
		
		public function destroy():void {
			trace("SUNDAY DESTROOOY");
			if (_cylinder1) {
				_cylinder1.visible = false;
				_cylinder1.setMaterialToAllSurfaces(new FillMaterial(0xFF0000));
			}
			if (_cylinder2) {
				_cylinder2.visible = false;
				_cylinder2.setMaterialToAllSurfaces(new FillMaterial(0x00FF00));
			}
			if (_material) {
				_material = null;
			}
		}
		
		private function addListeners():void {
			stage.addEventListener(Event.ENTER_FRAME, enterFrameListener);
			PanoramaModel.getInstance().addEventListener(PanoramaModel.ARROW_CLICK_LEFT, arrowClickLeftListener);
			PanoramaModel.getInstance().addEventListener(PanoramaModel.ARROW_CLICK_RIGHT, arrowClickRightListener);
		}
		
		private function addMouseListeners():void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
		}
		
		private function removeListeners():void {
			stage.removeEventListener(Event.ENTER_FRAME, enterFrameListener);
			PanoramaModel.getInstance().removeEventListener(PanoramaModel.ARROW_CLICK_LEFT, arrowClickLeftListener);
			PanoramaModel.getInstance().removeEventListener(PanoramaModel.ARROW_CLICK_RIGHT, arrowClickRightListener);
		}
		
		private function removeMouseListeners():void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
		}
		
		
		//-- Mouse Listeners
		private function mouseDownListener(e:MouseEvent):void {
			if (_cylinderTween) { _cylinderTween.kill(); }
			
			_clickCylinderRotation = _cylinderActive.rotationY;
			_clickMousePosition = stage.mouseX;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
		}
		
		private function mouseMoveListener(e:MouseEvent):void {
			var difference:Number = stage.mouseX - _clickMousePosition;
			_cylinderActive.rotationY = _clickCylinderRotation + difference / 350;
			updateRotationInModel(true);
		}
		
		private function mouseUpListener(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
		}
		
		
		//-- Listeners
		private function enterFrameListener(e:Event):void {
			_camera.render(_stage3D);
		}
		
		private function keyDownListener(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case Keyboard.LEFT:
					rotateLeft();
					break;
					
				case Keyboard.RIGHT:
					rotateRight();
					break;
			}
		}
		
		private function arrowClickLeftListener(e:Event):void {
			rotateLeft();
		}
		
		private function arrowClickRightListener(e:Event):void {
			rotateRight();
		}
		
		private function rotateLeft():void {
			if (_cameraTween.active) { return; }
			if (_cylinderTween) { _cylinderTween.kill(); }
			rotateCylinder(_cylinderActive.rotationY + 0.8);
			updateRotationInModel(true);
		}
		
		private function rotateRight():void {
			if (_cameraTween.active) { return; }
			if (_cylinderTween) { _cylinderTween.kill(); }
			rotateCylinder(_cylinderActive.rotationY - 0.8);
			updateRotationInModel(true);
		}
		
		
		
		//-- Scene
		private function createScene():void {
			// Cylinder 1
			_cylinder1 = new Cylinder(CYLINDER_RADIUS, CYLINDER_RADIUS, IMAGE_HEIGHT, 128, 1, true, true, true, false, true, null);
			_cylinder1.geometry.upload(_stage3D.context3D);
			_cylinder1.rotationX = -90 * Math.PI / 180;
			
			// Cylinder 2
			_cylinder2 = new Cylinder(CYLINDER_RADIUS, CYLINDER_RADIUS, IMAGE_HEIGHT, 128, 1, true, true, true, false, true, null);
			_cylinder2.geometry.upload(_stage3D.context3D);
			_cylinder2.rotationX = -90 * Math.PI / 180;
			_cylinder2.z = CYLINDER_RADIUS;
			_cylinder2.visible = false;
			
			// Title
			/*
			_txtTitle = new TextField();
			_txtTitle.width = 200;
			_txtTitle.height = 20;
			_txtTitle.background = true;
			_txtTitle.multiline = true;
			_txtTitle.wordWrap = true;
			*/
		}
		
		private function addScene():void {
			/*_camera = new Camera3D(0.1, (CYLINDER_RADIUS * 2) + 10);
			PanoramaModel.getInstance().panoramaView = new View(PANORAMA_WIDTH, PANORAMA_HEIGHT, true, 0, 0, 4);
			PanoramaModel.getInstance().panoramaView.hideLogo();
			_camera.view = PanoramaModel.getInstance().panoramaView;*/
			_camera = new Camera3D(0.1, (CYLINDER_RADIUS * 2) + 10);
			_camera.view = new View(PANORAMA_WIDTH, PANORAMA_HEIGHT, true, 0, 0, 4);
			_camera.view.hideLogo();
			 _camera.fov	= 1.75;
			Debug.status("FOV : " + _camera.fov);
			PanoramaModel.getInstance().panoramaViewBitmapData = _camera.view.canvas;
			
			_rootContainer = new Object3D();
			_rootContainer.addChild(_camera);
			_rootContainer.addChild(_cylinder1);
			_rootContainer.addChild(_cylinder2);
			
			addChild(_camera.view);
			//addChild(_camera.diagram);
			//addChild(_txtTitle);
		}
		
		
		
		//-- Init
		public function doInit(panoramaVO:PanoramaVO, panoramaBitmapData:BitmapData):void {
			trace("SUNDAY DO INIT PANO " + panoramaVO.linkage);
			//Debug.log("PANORAMA -> doInit -> linkage: " + panoramaVO.linkage);
			destroyTweens();
			_camera.z = 0;
			//_cylinder1.visible = true;
			//_cylinder2.visible = false;
			_cylinderActive = _cylinder1;
			
			_panoramaBitmapData = panoramaBitmapData;
			_panoramaVO = panoramaVO;
			
			
			
			/*if (isNaN(_panoramaVO.angleTransitionIn)) {
				_cylinder1.rotationY = 0//270 * Math.PI / 180;
			} else {
				_cylinder1.rotationY = angleDegToRad(360 - _panoramaVO.angleTransitionIn);
			}*/
			
			if (isNaN(_panoramaVO.angleTransitionOut)) {
				_cylinder1.rotationY = 0//270 * Math.PI / 180;
			} else {
				_cylinder1.rotationY = angleDegToRad(540 - _panoramaVO.angleTransitionOut);
			}
			
			Debug.log("PANORAMA -> doInit -> ANGLE: " + angleRadToDeg(_cylinder1.rotationY));
			
			updateRotationInModel();
			
			_material = getMaterial(panoramaBitmapData);
			//_material = getMaterialByLinkage(_panoramaVO.linkage);
			_cylinder1.setMaterialToAllSurfaces(_material);
			
			_cylinder1.visible = true;
			_cylinder2.visible = false;
			//_txtTitle.text = _panoramaVO.name;
		}
		
		public function doRotation(newRotation:Number, durationRotation:Number):void {
			// quick fix -> if INIT has never been called, cannot rotate
			if (!_cylinderActive) {
				return;
			}
			
			destroyTweens();
			
			var newRotationCorrectedDeg:Number = angleConvertToTransitionOut(newRotation);
			var newRotationCorrectedRad:Number = angleDegToRad(newRotationCorrectedDeg);
			//var newRotationY:Number = newRotation * Math.PI / 180;
			Debug.log("PANORAMA -> doRotation     (current linkage: " + _panoramaVO.linkage + ", NEW ROTATION: " + newRotation + ", NEW ROTATION CORRECTED: " + newRotationCorrectedDeg + ")");
			_durationRotation = durationRotation;
			
			rotateCylinder(newRotationCorrectedRad, durationRotation);
		}
		
		
		
		public function doTransition(newPanoramaVO:PanoramaVO, newPanoramaBitmapData:BitmapData, durationTransition:Number):void {
			// quick fix -> if INIT has never been called, (first pano doesnt exist) -> no transition, but init
			// UPDATE: REMOVED, IT RESULTS IN SHOWING OLD PANO BITMAP FOR A SEC
			if (!_panoramaVO) {
				//doInit(newPanoramaVO, newPanoramaBitmapData);
				return;
			}
			
			
			removeMouseListeners();
			destroyTweens();
			
			if (_cylinderActive == _cylinder2) {
				_cylinderActive = _cylinder1;
				switchPanorama();
			}
			
			//Debug.log("PANORAMA -> doTransition -> OLD linkage: " + _panoramaVO.linkage + ", NEW linkage: " + newPanoramaVO.linkage);
			
			_durationTransition = durationTransition;
			_panoramaNewBitmapData = newPanoramaBitmapData;
			_panoramaNewVO = newPanoramaVO;
			
			_materialTemp = getMaterial(newPanoramaBitmapData);
			//_materialTemp = getMaterialByLinkage(newPanoramaVO.linkage);
			_cylinder2.setMaterialToAllSurfaces(_materialTemp);
			if (isNaN(newPanoramaVO.angleTransitionIn)) {
				_cylinder2.rotationY = 0;
			} else {
				_cylinder2.rotationY = angleDegToRad(angleConvertToTransitionIn(newPanoramaVO.angleTransitionIn));
			}
			
			
			Debug.log("PANORAMA -> doTransition -> OLD ANGLE OUT: " + angleRadToDeg(_cylinder1.rotationY) + ", NEW ANGLE IN: " + angleRadToDeg(_cylinder2.rotationY));
			
			/*if (!isNaN(_panoramaVO.angleTransitionOut)) {
				zoom(_panoramaVO.angleTransitionOut);
			}*/
			
			zoomIn();
			
			//_panoramaBitmapData = newPanoramaBitmapData;
			//_panoramaVO = newPanoramaVO;
		}
		
		
		
		
		
		
		//-- Animations
		private function rotateCylinder(rotationY:Number, duration:Number = 0.5):void {
			Debug.log("PANORAMA -> rotateCylinder (CURRENT rotation: " + angleRadToDeg(_cylinderActive.rotationY) + ", NEW rotation: " + angleRadToDeg(rotationY) + ")");
			_cylinderTween = TweenLite.to(_cylinderActive, duration, { rotationY: rotationY, onComplete:updateRotationInModel } );
		}
		
		
		/*private function zoom(angleDeg:Number):void {
			//Debug.log("PanoramaDesktop -> zoom(" + angleDeg + ")" );// + angleDeg + " / " + (angleDeg * Math.PI / 180) + " / " + _cylinder1.rotationY);
			//Debug.log(" --------------------------- ");
			//Debug.log(" - _cylinder1.rotationY : " + _cylinder1.rotationY );
			//Debug.log(" - angleDeg : " + angleDeg );
			//Debug.log(" - (angleDeg * Math.PI / 180) : " + (angleDeg * Math.PI / 180) );
			//Debug.log(" - getCorrectAngle(angleDeg) : " + getCorrectAngle(angleDeg) );
			//Debug.log(" - (getCorrectAngle(angleDeg) * Math.PI / 180) : " + (getCorrectAngle(angleDeg) * Math.PI / 180) );
			//Debug.log(" --------------------------- ");
			
			_cylinderTween = TweenLite.to(_cylinder1, _durationRotation, { rotationY: (getCorrectAngle(angleDeg) * Math.PI / 180), ease:Quad.easeInOut, onComplete:zoomIn } );
			}
			//_cylinderTween = TweenLite.to(_cylinder1, 1.5, { rotationY: angleDeg * Math.PI / 180, ease:Quad.easeInOut, onComplete:zoomIn } );
			
		}*/
		
		private function getCorrectAngle(angle:Number):Number {
			Debug.log("GET CORRECT ANGLE " + angle);
			//return angle;
			//_cylinder1.r
			// angle * Math.PI / 180) = x / (Math.PI / 180)
			
			if ( angle - (_cylinderActive.rotationY / (Math.PI / 180)) >= 180 ) {
				angle = angle-360;
			}
			if ( angle - (_cylinderActive.rotationY / (Math.PI / 180)) <= -180 ) {
				angle = angle+360;
			}
			
			Debug.log("CORRECTED ANGLE: " + angle);
			return angle;
			
			//return Math.atan2(Math.sin(angle - _cylinder1.rotationY), Math.cos(angle - _cylinder1.rotationY)); 
		}
		
		private function zoomIn():void {
			//Debug.log("PANORAMA -> zoomIn         (current linkage: " + _panoramaVO.linkage + ")");
			_cylinderActive = _cylinder2;
			_cylinder2.visible = true;
			//Debug.log("PanoramaDesktop -> zoomIn _durationTransition: "+_durationTransition+" ,linkage: "+_panoramaVO.linkage);
			_cameraTween = TweenLite.to(_camera, _durationTransition, { z:CYLINDER_RADIUS, ease:Quad.easeInOut, onComplete:zoomInComplete } );
			//_materialTween = TweenLite.to(_material, _durationTransition, { alpha:0, ease:Quad.easeIn, onComplete:switchPanorama } );
			_materialTween = TweenLite.to(_material, _durationTransition, { alpha:0, ease:Quad.easeIn } );
		}
		
		private function zoomInComplete():void {
			addMouseListeners();
		}
		
		private function switchPanorama():void {
			Debug.log("PANORAMA -> switchPanorama -> OLD linkage: " + _panoramaVO.linkage + ", NEW linkage: " + _panoramaNewVO.linkage);
			
			_panoramaBitmapData = _panoramaNewBitmapData;
			_panoramaVO = _panoramaNewVO;
			
			_camera.z = 0;
			_cylinder1.rotationY = _cylinder2.rotationY;
			_cylinder2.visible = false;
			
			_material.diffuseMap.dispose();
			_materialTemp.diffuseMap.dispose();
			
			_material = getMaterial(_panoramaBitmapData);
			
			_cylinder1.setMaterialToAllSurfaces(_material);
		}
		
		
		
		
		
		
		
		
		private function updateRotationInModel(manualRotation:Boolean = false):void {
			/*if (_cylinderActive.rotationY >= Math.PI * 2) {
				_cylinderActive.rotationY -= Math.PI * 2;
			} else if (_cylinderActive.rotationY <= -Math.PI * 2) {
				_cylinderActive.rotationY += Math.PI * 2;
			}*/
			
			var angleDeg:Number = angleRadToDeg(_cylinderActive.rotationY);
			var angleDegIn:Number = 360 - angleDeg;
			var angleDegOut:Number = 540 - angleDeg;
			
			// fix negative
			while (angleDegIn < 0) { angleDegIn += 360; }
			while (angleDegOut < 0) { angleDegOut += 360; }
			
			// fix positive
			var fullCircle:Number;
			
			fullCircle = Math.floor(angleDegIn / 360);
			if (fullCircle > 0) { angleDegIn = angleDegIn - fullCircle * 360; }
			
			fullCircle = Math.floor(angleDegOut / 360);
			if (fullCircle > 0) { angleDegOut = angleDegOut - fullCircle * 360; }
			
			
			
			
			PanoramaModel.getInstance().currentRotationForAngleIn = angleDegIn;
			PanoramaModel.getInstance().currentRotationForAngleOut = angleDegOut;
			
			
			if (manualRotation) {
				PanoramaModel.getInstance().dispatch(PanoramaModel.MANUAL_ROTATION);
			}
		}
		
		
		
		
		//-- Materials
		private function getMaterial(bmpd:BitmapData):TextureMaterial {
			var diffuseMap:BitmapTextureResource = new BitmapTextureResource(bmpd);
			diffuseMap.upload(_stage3D.context3D);
			var material:TextureMaterial = new TextureMaterial(diffuseMap);
			material.alphaThreshold = 1;
			material.alpha = 1;
			return material;
		}
		
		private function getMaterialByLinkage(linkage:String):TextureMaterial {
			var linkageClass:Class = getDefinitionByName(linkage) as Class;
			var bmpd:BitmapData = new linkageClass(0,0) as BitmapData;
			
			var diffuseMap:BitmapTextureResource = new BitmapTextureResource(bmpd);
			diffuseMap.upload(_stage3D.context3D);
			var material:TextureMaterial = new TextureMaterial(diffuseMap);
			material.alphaThreshold = 1;
			return material;
		}
		
		
		
		private function angleConvertToTransitionIn(angle:Number):Number {
			return (360 - angle);
		}
		
		private function angleConvertToTransitionOut(angle:Number):Number {
			return getCorrectAngle(540 - angle);
		}
		
		private function angleDegToRad(deg:Number):Number {
			return (deg * Math.PI / 180);
		}
		
		private function angleRadToDeg(rad:Number):Number {
			return (rad * 180 / Math.PI);
		}
	}
}