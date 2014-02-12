//nl.photoreality.map_editor.view.route.RouteContainer
package nl.photoreality.map_editor.view.route {
	
	import com.greensock.easing.Linear;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.ShortRotationPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import nl.photoreality.map_editor.constants.EditorConstants;
	import nl.photoreality.map_editor.controller.RouteController;
	import nl.photoreality.map_editor.manager.PanoAssetsLoadManager;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.map_editor.model.vo.PanoramaVO;
	import nl.photoreality.map_editor.model.vo.RoutePointVO;
	import nl.photoreality.online_viewer.manager.MenuManager;
	import nl.photoreality.panorama.model.PanoramaModel;
	import nl.photoreality.utils.debug.Debug;
	
	
	public class RouteContainer extends Sprite {
		
		private const DURATION_TRANSITION_MIN	: Number	= 1.5;
		private const SPEED_ROTATION_MIN		: Number	= 0.1;
		private const SPEED_ROTATION_MAX		: Number	= 2;
		private const SPEED_ROTATION_FAST		: Number	= 0.9;
		private const SPEED_TRANSITION_MIN		: Number	= 0.05;
		private const SPEED_TRANSITION_MAX		: Number	= 0.4;
		private const SPEED_TRANSITION_FAST		: Number	= 0.25;
		
		private var _controller				: RouteController;
		private var _model					: Model;
		private var _modelPanorama			: PanoramaModel;
		private var _modelRoute				: RouteModel;
		
		private var _arrowMc				: MovieClip;
		private var _arrowTimeLine			: TimelineMax;
		private var _points					: Vector.<RoutePoint>;
		private var _pointPanoStartDelay	: TweenLite;
		
		private var _isEditable				: Boolean;
		private var _isPrintable			: Boolean;
		private var _floor2OffsetX			: Number;
		private var _floor2OffsetY			: Number;
		
		private var _arrowPlayFast			: Boolean;
		private var _shiftKeyPressed		: Boolean;
		
		private var _arrowCurrentPointIndex	: uint;
		
		
		public function RouteContainer() {
			TweenPlugin.activate([AutoAlphaPlugin, GlowFilterPlugin, ShortRotationPlugin]);
			_arrowCurrentPointIndex	= 0;
			_arrowMc 				= new arrow_mc();
			_arrowMc.mouseEnabled 	= _arrowMc.mouseChildren = false;
			_arrowPlayFast			= false;
			_controller 			= RouteController.getInstance();
			_model 					= Model.getInstance();
			_modelPanorama			= PanoramaModel.getInstance();
			_modelRoute 			= RouteModel.getInstance();
			_isEditable 			= true;
			_isPrintable 			= false;
			_floor2OffsetX 			= EditorConstants.FLOOR2_HORIZONTAL_OFFSET_X;
			_floor2OffsetY 			= EditorConstants.FLOOR2_HORIZONTAL_OFFSET_Y;
			
			
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			Debug.log("RouteContainer -> addedToStageListener");
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			
			if (!_isEditable) { return; }
			addListeners();
		}
		
		private function removedFromStageListener(e:Event):void {
			Debug.log("RouteContainer -> removedFromStageListener");
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			
			if (!_isEditable) { return; }
			removeListeners();
		}
		
		private function addListeners():void {
			MenuManager.getInstance().addEventListener(MenuManager.VIRTUAL_TOUR_STATE_CHANGED, virtualTourStateChangedListener);
			_modelPanorama.addEventListener(PanoramaModel.MANUAL_ROTATION, panoramaManualRotationListener);
			_modelRoute.addEventListener(RouteModel.DRAWING_CHANGE_FLOOR_IN, drawingChangeFloorInListener);
			_modelRoute.addEventListener(RouteModel.DRAWING_CHANGE_FLOOR_OUT, drawingChangeFloorOutListener);
			_modelRoute.addEventListener(RouteModel.DRAWING_COMPLETED, drawingCompletedListener);
			_modelRoute.addEventListener(RouteModel.DRAWING_STARTED, drawingStartedListener);
			_modelRoute.addEventListener(RouteModel.ROUTE_PANO_DIALOG_CLOSE, routePanoDialogCloseListener);
			_modelRoute.addEventListener(RouteModel.ROUTE_PANO_DIALOG_OPEN, routePanoDialogOpenListener);
			_modelRoute.addEventListener(RouteModel.ROUTE_PLAY, routePlayListener);
			_modelRoute.addEventListener(RouteModel.ROUTE_PLAY_NEXT_POINT, routePlayNextListener);
			_modelRoute.addEventListener(RouteModel.ROUTEPOINT_CHANGED, routePointChangedListener);
			_modelRoute.addEventListener(RouteModel.ROUTEPOINT_DESELECTED, routePointDeselectedListener);
			_modelRoute.addEventListener(RouteModel.ROUTEPOINT_REMOVED, routePointRemovedListener);
			_modelRoute.addEventListener(RouteModel.ROUTEPOINT_SELECTED, routePointSelectedListener);
			_modelRoute.addEventListener(RouteModel.ARROW_PLAY_SPEED_CHANGED, arrowPlaySpeedChangedListener);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
		}
		
		private function removeListeners():void {
			MenuManager.getInstance().removeEventListener(MenuManager.VIRTUAL_TOUR_STATE_CHANGED, virtualTourStateChangedListener);
			_modelPanorama.removeEventListener(PanoramaModel.MANUAL_ROTATION, panoramaManualRotationListener);
			_modelRoute.removeEventListener(RouteModel.DRAWING_CHANGE_FLOOR_IN, drawingChangeFloorInListener);
			_modelRoute.removeEventListener(RouteModel.DRAWING_CHANGE_FLOOR_OUT, drawingChangeFloorOutListener);
			_modelRoute.removeEventListener(RouteModel.DRAWING_COMPLETED, drawingCompletedListener);
			_modelRoute.removeEventListener(RouteModel.DRAWING_STARTED, drawingStartedListener);
			_modelRoute.removeEventListener(RouteModel.ROUTE_PANO_DIALOG_CLOSE, routePanoDialogCloseListener);
			_modelRoute.removeEventListener(RouteModel.ROUTE_PANO_DIALOG_OPEN, routePanoDialogOpenListener);
			_modelRoute.removeEventListener(RouteModel.ROUTE_PLAY, routePlayListener);
			_modelRoute.removeEventListener(RouteModel.ROUTE_PLAY_NEXT_POINT, routePlayNextListener);
			_modelRoute.removeEventListener(RouteModel.ROUTEPOINT_CHANGED, routePointChangedListener);
			_modelRoute.removeEventListener(RouteModel.ROUTEPOINT_DESELECTED, routePointDeselectedListener);
			_modelRoute.removeEventListener(RouteModel.ROUTEPOINT_REMOVED, routePointRemovedListener);
			_modelRoute.removeEventListener(RouteModel.ROUTEPOINT_SELECTED, routePointSelectedListener);
			_modelRoute.removeEventListener(RouteModel.ARROW_PLAY_SPEED_CHANGED, arrowPlaySpeedChangedListener);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN , mouseDownListener);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE , mouseMoveListener);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			
			hideArrowAnimation();
			
			if (_points) {
				for (var i:uint = 0; i < _points.length; i++) {
					//_points[i].removeEventListener(RoutePoint.CHANGED, routePointChangedListener);
					//_points[i].removeEventListener(RoutePoint.REMOVED, routePointRemovedListener);
				}
			}
			
			if (_pointPanoStartDelay) { _pointPanoStartDelay.kill(); }
		}
		
		
		
		//-- Listeners
		private function arrowPlaySpeedChangedListener(e:Event):void {
			//TweenLite.delayedCall(0.5, showArrowAnimation, [_arrowCurrentPointIndex, true]);
			showArrowAnimation(_arrowCurrentPointIndex, true);
		}
		
		private function virtualTourStateChangedListener(e:Event):void {
			adjustRouteSettings();
		}
		
		private function panoramaManualRotationListener(e:Event):void {
			Debug.log("MANUAL ROTATION " + _modelPanorama.currentRotationForAngleOut);
			_arrowMc.rotation = _modelPanorama.currentRotationForAngleOut;
			
			hideArrowAnimation();
			
			// place arrow
			_arrowMc.x = _points[_arrowCurrentPointIndex].x;
			_arrowMc.y = _points[_arrowCurrentPointIndex].y;
			
			// change, if its the last arrow (skip last point)
			if (_arrowCurrentPointIndex == (_points.length - 1)) {
				if (_arrowCurrentPointIndex > 0) {
					_arrowMc.x = _points[_arrowCurrentPointIndex - 1].x;
					_arrowMc.y = _points[_arrowCurrentPointIndex - 1].y;
				}
			}
			
			
			if (!this.contains(_arrowMc)) {
				addChild(_arrowMc);
			}
			
			if (_pointPanoStartDelay) { _pointPanoStartDelay.kill(); }
		}
		
		private function drawingChangeFloorInListener(e:Event):void {
			drawingChangeFloorIn();
		}
		
		private function drawingChangeFloorOutListener(e:Event):void {
			drawingChangeFloorOut();
		}
		
		private function drawingCompletedListener(e:Event):void {
			drawingStop();
			//showArrowAnimation();
		}
		
		private function drawingStartedListener(e:Event):void {
			drawingStart();
		}
		
		private function routePanoDialogCloseListener(e:Event):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			
			if (!_modelRoute.isChangingFloor) {
				stage.addEventListener(MouseEvent.MOUSE_DOWN , mouseDownListener);
				stage.addEventListener(MouseEvent.MOUSE_MOVE , mouseMoveListener);
			}
			
			stage.focus = this;
		}
		
		private function routePanoDialogOpenListener(e:Event):void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN , mouseDownListener);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE , mouseMoveListener);
			
			_shiftKeyPressed = false;
		}
		
		private function routePlayListener(e:Event):void {
			TweenLite.delayedCall(0.5, showArrowAnimation);
		}
		
		private function routePlayNextListener(e:Event):void {
			TweenLite.delayedCall(0.5, showArrowAnimation, [_arrowCurrentPointIndex, true]);
		}
		
		private function routePointChangedListener(e:Event):void {
			//hideArrowAnimation();
			
			if (_pointPanoStartDelay) { _pointPanoStartDelay.kill(); }
			
			trace("RouteContainer -> routePointChangedListener " + _modelRoute.selectedRoutePoint.x + "," + _modelRoute.selectedRoutePoint.y);
			trace("RouteContainer -> routePointChangedListener vo " + _modelRoute.selectedRoutePointVO.x + "," + _modelRoute.selectedRoutePointVO.y);
			trace("RouteContainer -> routePointChangedListener vo in point" + _modelRoute.selectedRoutePoint.vo.x + "," + _modelRoute.selectedRoutePoint.vo.y);
			//_modelRoute.selectedRoutePoint.x = _modelRoute.selectedRoutePointVO.x + getPointOffsetX(_modelRoute.selectedRoutePointVO.floorId);
			//_modelRoute.selectedRoutePoint.y = _modelRoute.selectedRoutePointVO.y + getPointOffsetY(_modelRoute.selectedRoutePointVO.floorId);;
			
			_modelRoute.selectedRoutePoint.x = _modelRoute.selectedRoutePoint.vo.x + getPointOffsetX(_modelRoute.selectedRoutePoint.vo.floorId);
			_modelRoute.selectedRoutePoint.y = _modelRoute.selectedRoutePoint.vo.y + getPointOffsetY(_modelRoute.selectedRoutePoint.vo.floorId);;
			
			
			//refresh();
			drawPath();
			calculateAngles();
			hideArrowAnimation();
		}
		
		private function routePointDeselectedListener(e:Event):void {
			_modelRoute.selectedRoutePoint.deselect();
		}
		
		private function routePointRemovedListener(e:Event):void {
			removeRoutePoint(_modelRoute.selectedRoutePoint);
			hideArrowAnimation();
		}
		
		private function routePointSelectedListener(e:Event):void {
			hideArrowAnimation();
			
			for (var i:int = 0; i < _points.length; i++) {
				if (_points[i] != _modelRoute.selectedRoutePoint) {
					_points[i].deselect();
				}
			}
			
			
			if (_pointPanoStartDelay) { _pointPanoStartDelay.kill(); }
			
			// show arrow animation from the selected point
			for (i = 0; i < _points.length; i++) {
				if (_points[i] == _modelRoute.selectedRoutePoint) {
					
					// init pano
					if ((_points[i].vo)  &&  (_points[i].vo.panorama)) {
						panoramaInit(_points[i].vo.panorama);
					}
					
					// place arrow
					_arrowMc.x = _points[i].x;
					_arrowMc.y = _points[i].y;
					if (_points[i].vo.angleTransitionOut) {
						_arrowMc.rotation = _points[i].vo.angleTransitionOut;
					} else if ((i > 0)  &&  _points[i - 1].vo.angleTransitionOut) {
						_arrowMc.rotation = _points[i - 1].vo.angleTransitionOut;
					} else {
						_arrowMc.rotation = 0;
					}
					
					
					
					if (!this.contains(_arrowMc)) {
						addChild(_arrowMc);
					}
					
					changeCurrentArrowPointIndex(i);
					
					// show arrow animation
					_pointPanoStartDelay = TweenLite.delayedCall(2, showArrowAnimation, [i]);
					//showArrowAnimation(i);
					break;
				}
			}
			
			
			
			
			/*if ((_modelRoute.selectedRoutePoint.vo.panorama)  &&  (_modelRoute.selectedRoutePoint.vo.panorama.linkage)  &&  (_modelRoute.selectedRoutePoint.vo.panorama.linkage != "")  &&  (_modelRoute.selectedRoutePoint.vo.panorama.linkage != "-")) {
				panoramaInit(_modelRoute.selectedRoutePoint.vo.panorama);
			}*/
		}
		
		
		//-- Mouse Listeners
		private function mouseDownListener(e:MouseEvent):void 	{
			//TweenLite.delayedCall(0.1, createRoutePoint, [new RoutePointVO(_points.length, this.mouseX, this.mouseY, _modelRoute.currentDrawingFloorId, null, null), false]);
			var offsetX:Number = getPointOffsetX(_modelRoute.currentDrawingFloorId);
			var offsetY:Number = getPointOffsetY(_modelRoute.currentDrawingFloorId);
			
			var mousePoint:Point = new Point(this.mouseX, this.mouseY);
			
			if (_points.length) {
				if (_shiftKeyPressed) {
					var lastPoint:RoutePoint = _points[_points.length - 1];
					mousePoint = getRoundedMousePoint(mouseX, mouseY, lastPoint.x, lastPoint.y);
				}
			}
			
			createRoutePoint(new RoutePointVO(_points.length, mousePoint.x - offsetX, mousePoint.y - offsetY, _modelRoute.currentDrawingFloorId, null, null), offsetX, offsetY, false);
			drawPath();
			
			calculateAngles();
			saveRoutePoints();
			
			//TweenLite.delayedCall(0.3, _controller.routePanoDialogOpen);
			_controller.routePanoDialogOpen();
		}
		
		private function mouseMoveListener(e:MouseEvent):void {
			var mousePoint:Point = new Point(mouseX, mouseY);
			
			if (_points.length) {
				if (_shiftKeyPressed) {
					var lastPoint:RoutePoint = _points[_points.length - 1];
					mousePoint = getRoundedMousePoint(mouseX, mouseY, lastPoint.x, lastPoint.y);
				}
			}
			
			//this.graphics.lineTo(getPositionX(_points[i]), getPositionY(_points[i]));
			
			drawPath(mousePoint);
		}
		
		private function getRoundedMousePoint(mX:Number, mY:Number, pX:Number, pY:Number):Point {
			var angleIn:Number = calculateAngleRad(mX, mY, pX, pY) * 180 / Math.PI;
			var returnPoint:Point = new Point(mX, mY);
			//trace("getRoundedMousePoint -> angle: " + angleIn + ",  mX " + mX + ", mY " + mY + ", pX " + pX + ", pY " + pY);
			
			if ((angleIn > 337.5) || (angleIn <= 22.5)) {	// 0
				returnPoint = new Point(mX, pY);
			} else if ((angleIn > 22.5) && (angleIn <= 67.5)) {	// 45
				returnPoint = new Point(pX - (pY - mY), mY);
			} else if ((angleIn > 67.5) && (angleIn <= 112.5)) {	// 90
				returnPoint = new Point(pX, mY);
			} else if ((angleIn > 112.5) && (angleIn <= 157.5)) {	// 135
				returnPoint = new Point(pX + (pY - mY), mY);
			} else if ((angleIn > 157.5) && (angleIn <= 202.5)) {	// 180
				returnPoint = new Point(mX, pY);
			} else if ((angleIn > 202.5) && (angleIn <= 247.5)) {	// 225
				returnPoint = new Point(pX + (mY - pY), mY);
			} else if ((angleIn > 247.5) && (angleIn <= 292.5)) {	// 270
				returnPoint = new Point(pX, mY);
			} else if ((angleIn > 292.5) && (angleIn <= 337.5)) {	// 315
				returnPoint = new Point(pX - (mY - pY), mY);
			}
			
			return returnPoint;
		}
		
		
		
		//-- Keyboard Listeners
		private function keyDownListener(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.SHIFT) {
				_shiftKeyPressed = true;
			}
		}
		
		private function keyUpListener(e:KeyboardEvent):void {
			//Debug.log("MIGUEL STUPID " + _modelRoute.isDrawing);
			if (e.keyCode == Keyboard.SPACE) {
				
				if (_modelRoute.isDrawing) {
					_controller.drawingStop();
				}
			} else if (e.keyCode == Keyboard.SHIFT) {
				_shiftKeyPressed = false;
				
			}/* else if (e.keyCode == Keyboard.NUMPAD_2) {
					tempRotation(90);
			} else if (e.keyCode == Keyboard.NUMPAD_4) {
					tempRotation(180);
			} else if (e.keyCode == Keyboard.NUMPAD_6) {
					tempRotation(0);
			} else if (e.keyCode == Keyboard.NUMPAD_8) {
					tempRotation(270);
			}*/
		}
		
		/*private function tempRotation(newRotation:Number):void {
			var rotationArrow:Number = newRotation;
			var rotationPanorama:Number = 540 - newRotation;
			//var rotationArrow:Number = newRotation + 180;
			//var rotationPanorama:Number = 360 - newRotation + 180;
			panoramaRotation(rotationPanorama, 1);
			TweenLite.to(_arrowMc, 1, { shortRotation: { rotation:rotationArrow } } );
		}*/
		
		
		
		
		//-- Refresh Route
		public function refresh():void {
			this.graphics.clear();
			while (this.numChildren) {
				this.removeChildAt(0);
			}
			
			if (_model.routes.length  &&  _modelRoute.selectedRouteVO  &&  _modelRoute.selectedRouteVO.points.length) {
				initRoutePoints(_modelRoute.selectedRouteVO.points);
			} else {
				_points = new Vector.<RoutePoint>();
			}
			
			adjustRouteSettings();
		}
		
		private function adjustRouteSettings():void {
			if (!_model.isEditor) {
				var visibility:Boolean;
				
				if (MenuManager.getInstance().virtualTourIsOpen) {
					_arrowPlayFast = false;
					visibility = true;
				} else {
					_arrowPlayFast = true;
					visibility = false;
				}
				
				for (var i:int = 1; i < _points.length - 1; i++) {
					_points[i].visible = visibility;
				}
			}
		}
		
		private function initRoutePoints(pointsVOs:Vector.<RoutePointVO>):void {
			Debug.log("RouteContainer -> initRoutePoints");
			_points = new Vector.<RoutePoint>();
			
			for (var i:int = 0; i < pointsVOs.length; i++) {
				var enabled:Boolean = true;
				Debug.log("RouteContainer -> initRoutePoints : "+pointsVOs[i].angleTransitionIn+" , "+pointsVOs[i].angleTransitionOut);
				/*if ((i == 0)  ||  (i == pointsVOs.length - 1)) {
					enabled = false;
				}*/
				createRoutePoint(pointsVOs[i], getPointOffsetX(pointsVOs[i].floorId), getPointOffsetY(pointsVOs[i].floorId), enabled);
			}
			
			_points[_points.length - 1].setAsLastPoint();
			
			drawPath();
			_controller.playRoute();
			//showArrowAnimation();
		}
		
		
		
		
		
		
		//-- Route Points
		private function createRoutePoint(vo:RoutePointVO, offsetX:Number = 0, offsetY:Number = 0, enabled:Boolean = true) {
			trace("RouteContainer -> createRoutePoint(" + vo.id + ") offset: " + offsetX + ", " + offsetY);
			
			// Check if hits elevator -> change x, y
			// TODO: FIX!!!
			/*var currentElevator		: ElevatorIcon;
			for (var i:int = 0; i < _model.elevatorIcons.length; i++) {
				currentElevator = ElevatorIcon(_model.elevatorIcons[i]);
				trace(_model.elevatorIcons[i].name)
				if (currentElevator.hitTest(new Point(vo.x, vo.y)) ) {
					trace("RouteContainer -> createRoutePoint -> Hits elevator: " + currentElevator.name);
					vo.x = currentElevator.x;
					vo.y = currentElevator.y;
					drawingStop();
				}
			}*/
			
			var routePoint:RoutePoint = new RoutePoint(vo, _isEditable, offsetX, offsetY);
			if (enabled) {
				routePoint.enable();
			}
			addChild(routePoint);
			_points.push(routePoint);
		}
		
		private function enableRoutePoints():void {
			if (_points  &&  _points.length) {
				for (var i:int = 0; i < _points.length; i++) {
					_points[i].enable();
				}
			}
		}
		
		private function removeRoutePoint(routePoint:RoutePoint):void {
			routePoint.disable();
			removeChild(routePoint);
			
			for (var i:uint = 0; i < _points.length; i++) {
				if (_points[i].vo.id == routePoint.vo.id) {
					_points.splice(i, 1);
					break;
				}
			}
			
			saveRoutePoints();
			drawPath();
			calculateAngles();
		}
		
		private function saveRoutePoints():void {
			var routePointVOs:Vector.<RoutePointVO> = new Vector.<RoutePointVO>();
			for (var i:int = 0; i < _points.length; i++) {
				routePointVOs.push(_points[i].vo);
			}
			
			_modelRoute.selectedRouteVO.points = routePointVOs;
		}
		
		
		
		
		//-- Arrow Animation
		private function showArrowAnimation(firstIndex:uint = 0, firstRotationAnimated:Boolean = false):void {
			if (_isPrintable) {
				return;
			}
			if (!_points || !_points.length || (firstIndex > _points.length -1)) {
				Debug.log("Error! Cannot show arrow animation!!!");
				hideArrowAnimation();
				return;
			}
			
			if (_arrowTimeLine) {
				_arrowTimeLine.kill();
			}
			
			TweenLite.killTweensOf(_arrowMc);
			TweenLite.killTweensOf(_arrowTimeLine);
			
			_arrowMc.x = _points[0].x;
			_arrowMc.y = _points[0].y;
			if (!firstRotationAnimated) {
				_arrowMc.rotation = 0;
			}
			addChild(_arrowMc);
			
			_arrowTimeLine = new TimelineMax({paused:true});
			Debug.log("arrowTimeLine -> CREATE! firstIndex: " + firstIndex, true);
			
			//if(firstIndex>0 && _modelRoute.selectedRouteVO.floors[0].id != _modelRoute.selectedRouteVO.floors[1].id
			//if(firstIndex>0 && _modelRoute.selectedRouteVO.floors[0].id != _modelRoute.selectedRouteVO.floors[1].id
			if (_points[firstIndex].vo.floorId == _modelRoute.selectedRouteVO.floors[1].id) {
				//_modelRoute.dispatch(RouteModel.ROUTE_SELECT_FLOOR_CHANGED);
				_modelRoute.selectedFloor = 1;
			}else {
				_modelRoute.selectedFloor = 0;
			}
			_modelRoute.dispatch(RouteModel.ROUTE_SELECT_FLOOR_CHANGED);
			
			// Only one point in animation  -> try to play animation from last point
			if ((firstIndex == _points.length - 1)  &&  (firstIndex > 0))  {
				firstIndex--;
			}
			
			
			var rotationArrow:Number;
			var rotationPanorama:Number;
			var durationRotation:Number;
			var durationTransition:Number;
			
			for (var i:uint = firstIndex; i < _points.length; i++) {
				
				if (i == firstIndex) {
					
					// PANORAMA INIT
					if ((_points[i].vo.panorama)  &&  (_points[i].vo.panorama.linkage)  &&  (_points[i].vo.panorama.linkage != "")) {
						Debug.log("arrowTimeLine -> arrow position");
						
						_arrowMc.x = _points[i].x;
						_arrowMc.y = _points[i].y;
						
						if (firstRotationAnimated) {
							rotationArrow = _points[i].vo.angleTransitionOut;
							
							if (_points[i].vo.panorama) {	rotationPanorama = _points[i].vo.panorama.angleTransitionOut; }
							else {							rotationPanorama = _points[i].vo.angleTransitionOut; }
							
							
							if (_arrowPlayFast) {
								durationRotation = 0.001;//1 / SPEED_ROTATION_FAST;
							} else {
								//durationRotation = 1 / SPEED_ROTATION;
								durationRotation = 1 / (SPEED_ROTATION_MIN + ((SPEED_ROTATION_MAX - SPEED_ROTATION_MIN) * _modelRoute.arrowPlaySpeedPercent));
							}
							
							_arrowTimeLine.addCallback(panoramaRotation, _arrowTimeLine.duration, [rotationPanorama, durationRotation]);
							_arrowTimeLine.append(TweenLite.to(_arrowMc, durationRotation, { shortRotation: { rotation:rotationArrow } } ));
							
							
							
							
						} else {
							_arrowMc.rotation = _points[i].vo.angleTransitionOut;
							Debug.log("arrowTimeLine -> call panoramaInit(" + _points[i].vo.panorama.linkage + ")");
							panoramaInit(_points[i].vo.panorama);
						}
					}
					
				
				// play change floor animation
				} else if ((i > firstIndex)  &&  (_points[i].vo.floorId != _points[i - 1].vo.floorId)) {
					Debug.log("arrowTimeLine -> arrow change floor!");
					_arrowTimeLine.append(TweenLite.to(_arrowMc, 0.5, { alpha:0 } ));
					_arrowTimeLine.append(TweenLite.to(_arrowMc, 0.1, { x:_points[i].x, y:_points[i].y, rotation:0 } ));
					_arrowTimeLine.append(TweenLite.to(_arrowMc, 1, { alpha:1 } ));
					
					// PANORAMA INIT
					if ((_points[i].vo.panorama)  &&  (_points[i].vo.panorama.linkage)  &&  (_points[i].vo.panorama.linkage != "")  &&  (_points[i].vo.panorama.linkage != "-")) {
						Debug.log("arrowTimeLine -> call panoramaInit(linkage: " + _points[0].vo.panorama.linkage + ")");
						_arrowTimeLine.addCallback(panoramaInit, _arrowTimeLine.duration, [_points[i].vo.panorama]);
						//_arrowTimeLine.append(TweenLite.to(_arrowMc, 0.1, { alpha:0, onComplete:panoramaInit, onCompleteParams:[_points[i].vo.panorama] } ));
					}
					
					
					
					
					// skip animation if it's the first point after floor switch
					trace("arrowTimeLine -> first point after floor switch -> quick rotation");
					trace("arrowTimeLine -> call panoramaTransitionFloorChanged()");
					durationRotation = 0.1;
					_arrowTimeLine.addCallback(panoramaTransitionFloorChanged, _arrowTimeLine.duration);
					
					// play rotation animation
					//_arrowTimeLine.append(new TweenLite(_arrowMc, SPEED_ROTATION, { shortRotation:{rotation:rotation} } ));
					//_arrowTimeLine.append(new TweenLite(_arrowMc, duration, { x:_points[i].x, y:_points[i].y, ease:Linear.easeNone } ));
					
					
				// not the first point & not floor animation -> play normal distance animation
				} else if (i > firstIndex) {
					Debug.log("arrowTimeLine -> arrow tween");
					var isLastPanorama:Boolean = false;
					var distance:Number = Math.sqrt( (_points[i].x - _points[i - 1].x) * (_points[i].x - _points[i - 1].x) + (_points[i].y - _points[i - 1].y) * (_points[i].y - _points[i - 1].y));
					rotationArrow = _points[i - 1].vo.angleTransitionOut;
					
					if (_points[i - 1].vo.panorama) {
						rotationPanorama = _points[i - 1].vo.panorama.angleTransitionOut;
					} else {
						rotationPanorama = _points[i - 1].vo.angleTransitionOut;
					}
					
					
					//durationRotation;
					//durationTransition;
					
					
					if (_arrowPlayFast) {
						// if (_points[i - 1].vo.ro
						durationRotation = 0.001;//1 / SPEED_ROTATION_FAST;
						durationTransition = distance * 0.01 / SPEED_TRANSITION_FAST;
					} else {
						//durationRotation = 1 / SPEED_ROTATION;
						//durationTransition = distance * 0.01 / SPEED_TRANSITION;
						durationRotation = 1 / (SPEED_ROTATION_MIN + ((SPEED_ROTATION_MAX - SPEED_ROTATION_MIN) * _modelRoute.arrowPlaySpeedPercent));
						durationTransition = distance * 0.01 / (SPEED_TRANSITION_MIN + ((SPEED_TRANSITION_MAX - SPEED_TRANSITION_MIN) * _modelRoute.arrowPlaySpeedPercent));
						
						if (durationTransition < DURATION_TRANSITION_MIN) {
							durationTransition = DURATION_TRANSITION_MIN;
						}
						
					}
					
					
					// skip rotation animation if it's the first point
					if (i == (firstIndex + 1)) {
						Debug.log("arrowTimeLine -> (first point -> quick rotation");
						durationRotation = 0.1;
					}
					
					/*
					// skip animation if it's the first point after floor switch
					if ((i > firstIndex)  &&  (_points[i].vo.floorId != _points[i - 1].vo.floorId)) {
					//if ((i > 1)  &&  (_points[i-1].vo.floorId != _points[i - 2].vo.floorId)) {
						trace("arrowTimeLine -> first point after floor switch -> quick rotation");
						trace("arrowTimeLine -> call panoramaTransitionFloorChanged()");
						durationRotation = 0.1;
						_arrowTimeLine.addCallback(panoramaTransitionFloorChanged, _arrowTimeLine.duration);
						
						//_arrowTimeLine.append(TweenLite.to(_arrowMc, 0.1, { alpha:1, onComplete:panoramaTransitionFloorChanged} ));
					}
					*/
					// skip transition animation if it's the very last point
					if (i == (_points.length - 1)) {
						isLastPanorama = true;
					}
					
					
					
					
					// PANORAMA ROTATION
					//if ((_points[i].vo.panorama)  &&  (_points[i].vo.panorama.linkage)  &&  (_points[i].vo.panorama.linkage != "")  &&  (_points[i].vo.panorama.linkage != "-")) {
						Debug.log("arrowTimeLine -> call panoramaRotation(rotationPanorama: " + rotationPanorama + ", durationRotation: " + durationRotation + ")");
						_arrowTimeLine.addCallback(panoramaRotation, _arrowTimeLine.duration, [rotationPanorama, durationRotation]);
						//_arrowTimeLine.append(TweenLite.to(_arrowMc, 0.1, { alpha:1, onComplete:panoramaTransition, onCompleteParams:[_points[i].vo.panorama, durationRotation, duration, isLastPanorama] } ));
					//}
					
					// ARROW ROTATION
					Debug.log("arrowTimeLine -> arrow rotation to : " + rotationArrow + ")");
					_arrowTimeLine.append(TweenLite.to(_arrowMc, durationRotation, { shortRotation: { rotation:rotationArrow} } ));
					
					
					
					
					
					if (!isLastPanorama) {
						// PANORAMA TRANSITION
						if ((_points[i].vo.panorama)  &&  (_points[i].vo.panorama.linkage)  &&  (_points[i].vo.panorama.linkage != "")  &&  (_points[i].vo.panorama.linkage != "-")) {
							Debug.log("arrowTimeLine -> call panoramaTransition(linkage: " + _points[i].vo.panorama.linkage + ", duration: " + durationTransition + ")");
							_arrowTimeLine.addCallback(panoramaTransition, _arrowTimeLine.duration, [_points[i].vo.panorama, durationTransition]);
						}
						
						// ARROW TRANSITION
						Debug.log("arrowTimeLine -> arrow transition");
						_arrowTimeLine.append(TweenLite.to(_arrowMc, durationTransition, { x:_points[i].x, y:_points[i].y, ease:Linear.easeNone } ));
					}
					
					
					
					
					
				}
				
				// change current arrow point index
				_arrowTimeLine.addCallback(changeCurrentArrowPointIndex, _arrowTimeLine.duration, [i]);
				
				// last point
				if ( i == (_points.length - 1) ) {
					Debug.log( "RouteContainer, last point i: " + i );
					_arrowTimeLine.addCallback(_points[i].showLastAnimation, _arrowTimeLine.duration);	// routepoint last animation
					_arrowTimeLine.addCallback(routeFinished, _arrowTimeLine.duration + 2);	// 2s delay after finished
					//_arrowTimeLine.append(TweenLite.to(_arrowMc, 0.1, { alpha:1, onComplete:routeFinished, onCompleteParams:[] } ));
				}
				
			}
			
			
			_arrowTimeLine.play();
		}
		
		private function routeFinished():void {
			Debug.log( "RouteContainer -> routeFinished " );
			_controller.endRoute();
		}
		
		private function panoramaInit(vo:PanoramaVO):void {
			if (!_arrowPlayFast) {
				//PanoramaModel.getInstance().panoramaBitmapData = getPanoramaBitmapData(vo.linkage);
				PanoramaModel.getInstance().panoramaBitmapData = PanoAssetsLoadManager.getInstance().getPano(vo.linkage);
				PanoramaModel.getInstance().panoramaVO = vo;
				PanoramaModel.getInstance().dispatch(PanoramaModel.INIT);
			}
		}
		
		private function panoramaRotation(rotation:Number, durationRotation:Number):void {
			if (!_arrowPlayFast) {
				PanoramaModel.getInstance().durationRotation = durationRotation;
				PanoramaModel.getInstance().rotation = rotation;
				PanoramaModel.getInstance().dispatch(PanoramaModel.ROTATION);
			}
		}
		
		private function panoramaTransition(vo:PanoramaVO, durationTransition:Number):void {
			if (!_arrowPlayFast) {
				PanoramaModel.getInstance().durationTransition = durationTransition;
				//PanoramaModel.getInstance().panoramaBitmapData = getPanoramaBitmapData(vo.linkage);
				PanoramaModel.getInstance().panoramaBitmapData = PanoAssetsLoadManager.getInstance().getPano(vo.linkage);
				PanoramaModel.getInstance().panoramaVO = vo;
				
				PanoramaModel.getInstance().dispatch(PanoramaModel.TRANSITION);
			}
		}
		
		private function panoramaTransitionFloorChanged():void {
			_controller.playRouteFloorChanged();
		}
		
		/*
		private function getPanoramaBitmapData(linkage:String):BitmapData {
			var linkageClass:Class = _model.panos.contentLoaderInfo.applicationDomain.getDefinition(linkage) as Class;
			var bmpd:BitmapData = new linkageClass(0, 0) as BitmapData;
			return bmpd;
		}
		*/
		private function changeCurrentArrowPointIndex(index:uint):void {
			_arrowCurrentPointIndex = index;
		}
		
		
		private function hideArrowAnimation():void {
			if (_arrowTimeLine) {
				/*Debug.log("HIDE ARROW ANIMATION");
				_arrowTimeLine.removeCallback(panoramaInit);
				_arrowTimeLine.removeCallback(panoramaRotation);
				_arrowTimeLine.removeCallback(panoramaTransition);
				_arrowTimeLine.removeCallback(panoramaTransitionFloorChanged);*/
				_arrowTimeLine.kill();
			}
			
			if (this.contains(_arrowMc)) {
				TweenLite.killTweensOf(_arrowMc);
				removeChild(_arrowMc);
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		//-- Drawing
		private function drawingStart():void  {
			_points = new Vector.<RoutePoint>();
			
			createRoutePoint(new RoutePointVO(0, _modelRoute.currentDrawingHitIcon.x, _modelRoute.currentDrawingHitIcon.y, _modelRoute.currentDrawingFloorId, null, null), getPointOffsetX(_modelRoute.currentDrawingFloorId), getPointOffsetY(_modelRoute.currentDrawingFloorId), false);			
			//drawPath( new Point(_points[0].x, _points[0].y) );
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN , mouseDownListener);
			stage.addEventListener(MouseEvent.MOUSE_MOVE , mouseMoveListener);
			this.mouseChildren = this.mouseEnabled = false;
			
			calculateAngles();
			saveRoutePoints();
			_controller.routePanoDialogOpen();
		}
		
		private function drawingStop():void {
			stage.removeEventListener(MouseEvent.MOUSE_DOWN , mouseDownListener);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE , mouseMoveListener);
			this.mouseChildren = this.mouseEnabled = true;
			
			if (!_modelRoute.isChangingFloor) {
				_points[_points.length - 1].setAsLastPoint();
			}
			
			calculateAngles();
			saveRoutePoints();
			
			drawPath();
			enableRoutePoints();
		}
		
		
		private function drawingChangeFloorIn():void {
			//Debug.log("HERE! drawingChangeFloorIn");
			_points[_points.length - 1].x = _modelRoute.currentDrawingHitIcon.x;
			_points[_points.length - 1].y = _modelRoute.currentDrawingHitIcon.y;
			
			drawingStop();
		}
		
		
		private function drawingChangeFloorOut():void {
			//Debug.log("HERE! drawingChangeFloorIn");
			createRoutePoint(new RoutePointVO(_points.length, _modelRoute.currentDrawingHitIcon.x, _modelRoute.currentDrawingHitIcon.y, _modelRoute.currentDrawingFloorId, null, null), getPointOffsetX(_modelRoute.currentDrawingFloorId), getPointOffsetY(_modelRoute.currentDrawingFloorId), false);
			//drawPath( new Point(_points[0].x, _points[0].y) );
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN , mouseDownListener);
			stage.addEventListener(MouseEvent.MOUSE_MOVE , mouseMoveListener);
			this.mouseChildren = this.mouseEnabled = false;
			
			saveRoutePoints();
			
			_controller.routePanoDialogOpen();
		}
		
		
		private function drawPath(mousePoint:Point = null):void {
			this.graphics.clear();
			this.graphics.lineStyle(_model.lineThickness, _model.lineColor);
			this.graphics.moveTo(_points[0].x , _points[0].y);
			
			for (var i:int = 1; i < _points.length; i++) {
				//trace("CHECK " + _points[i].vo.floorId + " AND " + _points[i - 1].vo.floorId)
				if (_points[i].vo.floorId != _points[i - 1].vo.floorId) {
					this.graphics.moveTo(getPositionX(_points[i]), getPositionY(_points[i]));
				} else {
					this.graphics.lineTo(getPositionX(_points[i]), getPositionY(_points[i]));
				}
				
			}
			
			if (mousePoint){
				this.graphics.lineTo(mousePoint.x, mousePoint.y);
			}
		}
		
		
		private function calculateAngles():void {
			for (var i:int = 0; i < _points.length; i++) {
				if ((i - 1) >= 0) {
					_points[i].vo.angleTransitionIn = calculateAngleRad(_points[i].x, _points[i].y, _points[i - 1].x, _points[i - 1].y) * 180 / Math.PI;
					
					if (_points[i].vo.panorama) {
						if (isNaN(_points[i].vo.panorama.angleTransitionIn)) {
							_points[i].vo.panorama.angleTransitionIn = _points[i].vo.angleTransitionIn;
						}
					}
					//trace(i + " routePoint angle - Transition In: " + _points[i].vo.angleTransitionIn);
				}
				if ((i + 1) < _points.length) {
					_points[i].vo.angleTransitionOut = calculateAngleRad(_points[i].x, _points[i].y, _points[i + 1].x, _points[i + 1].y) * 180 / Math.PI;
					//trace(i + " routePoint angle - Transition Out: " + _points[i].vo.angleTransitionOut);
					
					if (_points[i].vo.panorama) {
						if (isNaN(_points[i].vo.panorama.angleTransitionOut)) {
							_points[i].vo.panorama.angleTransitionOut = _points[i].vo.angleTransitionOut;
						}
					}
				}
			}
		}
		
		private function calculateAngleRad(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			var angle:Number = Math.atan2(y2 - y1, x2 - x1);
			if (angle < 0) { angle += Math.PI * 2; }
			return angle;
		}
		
		
		
		
		// TEMP
		private function getPointOffsetX(floorId:String):Number {
			if ((_modelRoute.selectedRouteVO.floors.length > 1)  &&  (floorId != _modelRoute.selectedRouteVO.floors[0].id)) {
				// SECOND FLOOR!!!!
				return _floor2OffsetX;
				
			} else {
				return 0;
			}
		}
		private function getPointOffsetY(floorId:String):Number {
			if ((_modelRoute.selectedRouteVO.floors.length > 1)  &&  (floorId != _modelRoute.selectedRouteVO.floors[0].id)) {
				// SECOND FLOOR!!!!
				return _floor2OffsetY;
				
			} else {
				return 0;
			}
		}
		
		
		
		
		private function getPositionX(point:RoutePoint):Number {
			if ((_modelRoute.selectedRouteVO.floors.length > 1)  &&  (point.vo.floorId != _modelRoute.selectedRouteVO.floors[0].id)) {
				// SECOND FLOOR!!!!
				return point.vo.x + _floor2OffsetX;
				
			} else {
				return point.vo.x;
			}
		}
		private function getPositionY(point:RoutePoint):Number {
			if ((_modelRoute.selectedRouteVO.floors.length > 1)  &&  (point.vo.floorId != _modelRoute.selectedRouteVO.floors[0].id)) {
				// SECOND FLOOR!!!!
				return point.vo.y + _floor2OffsetY;
				
			} else {
				return point.vo.y;
			}
		}
		
		
		public function prepareForPrint():void {
			hideArrowAnimation();
		}
		
		
		
		
		
		
		
		
		public function set isEditable(value:Boolean):void {
			trace("RouteContainer -> isEditable("+value+")");
			_isEditable = value;
		}
		public function get floor2OffsetX():Number { return floor2OffsetX; }
		public function set floor2OffsetX(value:Number):void {
			_floor2OffsetX = value;
		}
		public function get floor2OffsetY():Number { return floor2OffsetY; }
		public function set floor2OffsetY(value:Number):void {
			_floor2OffsetY = value;
		}
		
		public function get isPrintable():Boolean { return _isPrintable; }
		public function set isPrintable(value:Boolean):void {
			_isPrintable = value;
			if (_isPrintable) {
				prepareForPrint();
			}
		}
		
		public function get arrowPlayFast():Boolean { return _arrowPlayFast; }
		public function set arrowPlayFast(value:Boolean):void {
			_arrowPlayFast = value;
		}
	}
}