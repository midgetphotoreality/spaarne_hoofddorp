//nl.photoreality.panorama.view.panorama.Panorama
package nl.photoreality.panorama.view.panorama {
	
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.GeoSphere;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.TextureResource;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.events.GestureEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	
	public class Panorama extends Sprite {
		
		private var _camera				: Camera3D;
		private var _rootContainer		: Object3D;
		private var _stage3D			: Stage3D;
		
		private var _sphere				: GeoSphere;
		private var _cameraTween		: TweenLite;
		
		private var _debugTextField		: TextField;
		
		
		public function Panorama():void {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		private function addedToStageListener(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			init();
			
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			//stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginListener);
			//stage.addEventListener(GestureEvent.GESTURE_TWO_FINGER_TAP, gestureTwoFingerTapListener);
			stage.addEventListener(TransformGestureEvent.GESTURE_PAN, gesturePanListener);
			stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, gestureSwipeListener);
			stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, gestureZoomListener);
		}
		
		private function gesturePanListener(e:TransformGestureEvent):void {
			debug("PAN: scale(" + e.scaleX + ", " + e.scaleY + "), offset(" + e.offsetX + ", " + e.offsetY + ")");
		}
		
		private function gestureSwipeListener(e:TransformGestureEvent):void {
			const maxRotation:Number = 0.8;
			var newRotationX:Number = _camera.rotationZ;
			var newRotationY:Number = _camera.rotationX;
			
			if (e.offsetX == 1) {
				//User swiped towards right
				newRotationX = _camera.rotationZ + (maxRotation * e.scaleX);
				
			} else if (e.offsetX == -1) {
				//User swiped towards left
				newRotationX = _camera.rotationZ - (maxRotation * e.scaleX);
			}
			
			if (e.offsetY == 1) {
				//User swiped towards bottom
				newRotationY = _camera.rotationX + (maxRotation * e.scaleY);
				
			} else if (e.offsetY == -1) {
				//User swiped towards top
				newRotationY = _camera.rotationX - (maxRotation * e.scaleY);
			}
			
			
			
			if (newRotationY > -20 * Math.PI / 180) {
				newRotationY = -20 * Math.PI / 180;
			} else if (newRotationY < -160 * Math.PI / 180) {
				newRotationY = -160 * Math.PI / 180;
			}
			
			_cameraTween = TweenLite.to(_camera, 0.5, { rotationZ: newRotationX, rotationX: newRotationY } );
			
			debug("SWIPE: scale(" + e.scaleX + ", " + e.scaleY + "), offset(" + e.offsetX + ", " + e.offsetY + ")");
		}
		
		private function gestureZoomListener(e:TransformGestureEvent):void {
			var maxZoom:uint = 20;
			
			//_cameraTween = TweenLite.to(_camera, 0.5, { y: maxZoom * (e.scaleX + e.scaleY) / 2 } );
			_cameraTween = TweenLite.to(_camera, 0.5, {y: _camera.y + (maxZoom * e.scaleX * e.scaleY) } );
			//_camera.y += maxZoom * e.scaleX * e.scaleY;
			
			debug("ZOOM: scale(" + e.scaleX + ", " + e.scaleY + ")");
		}
		
		
		
		private function gestureTwoFingerTapListener(e:GestureEvent):void {
			if (_debugTextField) {
				_debugTextField.text = "";
			}
		}
		
		
		
		
		private function touchBeginListener(e:TouchEvent):void {
			stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveListener);
			stage.addEventListener(TouchEvent.TOUCH_END, touchEndListener);
			graphics.beginFill(0x00FF00, 0.8);
		}
		
		private function touchMoveListener(e:TouchEvent):void {
			graphics.drawCircle(e.localX, e.localY, 5);
			graphics.drawCircle(20, 10, 10);
		}
		
		private function touchEndListener(e:TouchEvent):void {
			stage.removeEventListener(TouchEvent.TOUCH_MOVE, touchMoveListener);
			stage.removeEventListener(TouchEvent.TOUCH_END, touchEndListener);
			graphics.endFill();
		}
		
		
		
		
		
		
		private function init():void {
			_rootContainer = new Object3D();
			
			// Camera and view
			_camera = new Camera3D(0.1, 10000);
			_camera.view = new View(stage.stageWidth, stage.stageHeight, false, 0, 0, 4);
			_camera.view.hideLogo();
			addChild(_camera.view);
			addChild(_camera.diagram);
			
			// Initial position
			_camera.rotationX = -90 * Math.PI / 180;
			//_camera.y = 200;
			//_camera.y = -800;
			//_camera.z = 400;
			_rootContainer.addChild(_camera);
			
			var diffuseMap:BitmapTextureResource = new BitmapTextureResource(new panoramaTestBitmapData());
			var material:TextureMaterial = new TextureMaterial(diffuseMap);
			
			_sphere = new GeoSphere(500, 50, true, material);
			_rootContainer.addChild(_sphere);
			
			
			_stage3D = stage.stage3Ds[0];
			_stage3D.addEventListener(Event.CONTEXT3D_CREATE, context3DcreateListener);
			_stage3D.requestContext3D();
		}
		
		private function context3DcreateListener(e:Event):void {
			for each (var resource:Resource in _rootContainer.getResources(true)) {
				resource.upload(_stage3D.context3D);
			}
			
			//diffuseMap.upload(_stage3D.context3D);
			// Listeners
			stage.addEventListener(Event.ENTER_FRAME, enterFrameListener);
		}
		
		private function enterFrameListener(e:Event):void {
			// Width and height of view
			_camera.view.width = stage.stageWidth;
			_camera.view.height = stage.stageHeight;
			
			// Rotation
			//_sphere.rotationZ -= 0.01;
			
			// Render
			_camera.render(_stage3D);
		}
		
		
		
		private function debug(txt:String):void {
			if (!_debugTextField) {
				_debugTextField = new TextField();
				_debugTextField.width = stage.stageWidth;
				_debugTextField.height = stage.stageHeight;
				_debugTextField.multiline = true;
				_debugTextField.wordWrap = true;
				addChild(_debugTextField);
			}
			
			_debugTextField.appendText(txt);
		}
	}
}