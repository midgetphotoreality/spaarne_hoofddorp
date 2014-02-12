//nl.photoreality.map_editor.view.route.RoutePointDetails
package nl.photoreality.map_editor.view.route {
	
	import com.greensock.TweenLite;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import nl.photoreality.map_editor.controller.RouteController;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.map_editor.model.vo.PanoramaVO;
	import nl.photoreality.map_editor.model.vo.RoutePointVO;
	import nl.photoreality.panorama.model.PanoramaModel;
	
	
	public class RoutePointDetails extends Sprite {
		
		private var _controller				: RouteController;
		private var _model					: RouteModel;
		private var _currentRoutePointVO	: RoutePointVO;
		
		// stage instances
		public var btn_add_point_after		: SimpleButton;
		public var btn_close				: SimpleButton;
		public var btn_get_pano_angle_in	: SimpleButton;
		public var btn_get_pano_angle_out	: SimpleButton;
		public var btn_remove				: SimpleButton;
		public var btn_update				: SimpleButton;
		public var txt_angle_in				: TextField;
		public var txt_angle_out			: TextField;
		public var txt_floor				: TextField;
		public var txt_id					: TextField;
		public var txt_panorama				: TextField;
		public var txt_pos_x				: TextField;
		public var txt_pos_y				: TextField;
		
		
		public function RoutePointDetails() {
			_controller = RouteController.getInstance();
			_model = RouteModel.getInstance();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			hide(true);
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
			
			this.mouseEnabled = false;
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeButtonListeners();
			removeListeners();
		}
		
		private function addListeners():void {
			_model.addEventListener(RouteModel.ROUTE_SELECTED, routeSelectedListener);
			_model.addEventListener(RouteModel.ROUTEPOINT_CHANGED, routePointChangedListener);
			_model.addEventListener(RouteModel.ROUTEPOINT_SELECTED, routePointSelectedListener);
		}
		
		private function addButtonListeners():void {
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			
			btn_add_point_after.addEventListener(MouseEvent.CLICK, btnAddPointAfterListener);
			btn_close.addEventListener(MouseEvent.CLICK, btnCloseListener);
			btn_get_pano_angle_in.addEventListener(MouseEvent.CLICK, btnGetPanoAngleInListener);
			btn_get_pano_angle_out.addEventListener(MouseEvent.CLICK, btnGetPanoAngleOutListener);
			btn_remove.addEventListener(MouseEvent.CLICK, btnRemoveListener);
			btn_update.addEventListener(MouseEvent.CLICK, btnUpdateListener);
		}
		
		private function removeListeners():void {
			_model.removeEventListener(RouteModel.ROUTE_SELECTED, routeSelectedListener);
			_model.removeEventListener(RouteModel.ROUTEPOINT_CHANGED, routePointChangedListener);
			_model.removeEventListener(RouteModel.ROUTEPOINT_SELECTED, routePointSelectedListener);
		}
		
		private function removeButtonListeners():void {
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			
			btn_add_point_after.removeEventListener(MouseEvent.CLICK, btnAddPointAfterListener);
			btn_close.removeEventListener(MouseEvent.CLICK, btnCloseListener);
			btn_get_pano_angle_in.removeEventListener(MouseEvent.CLICK, btnGetPanoAngleInListener);
			btn_get_pano_angle_out.removeEventListener(MouseEvent.CLICK, btnGetPanoAngleOutListener);
			btn_remove.removeEventListener(MouseEvent.CLICK, btnRemoveListener);
			btn_update.removeEventListener(MouseEvent.CLICK, btnUpdateListener);
		}
		
		
		//-- Button Listeners
		private function keyUpListener(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ENTER) {
				if ((stage.focus == txt_angle_in)  ||  (stage.focus == txt_angle_out)  ||  (stage.focus == txt_floor)  ||  (stage.focus == txt_id)  ||  (stage.focus == txt_panorama)  ||  (stage.focus == txt_pos_x)  ||  (stage.focus == txt_pos_y)) {
					update();
				}
			}
		}
		
		private function btnAddPointAfterListener(e:MouseEvent):void {
			_controller.addRoutePointAfterCurrent();
		}
		
		private function btnCloseListener(e:MouseEvent):void {
			_controller.deselectRoutePoint();
			hide();
		}
		
		private function btnGetPanoAngleInListener(e:MouseEvent):void {
			txt_angle_in.text = PanoramaModel.getInstance().currentRotationForAngleIn.toString();
		}
		
		private function btnGetPanoAngleOutListener(e:MouseEvent):void {
			txt_angle_out.text = PanoramaModel.getInstance().currentRotationForAngleOut.toString();
		}
		
		private function btnRemoveListener(e:MouseEvent):void {
			_controller.removeRoutePoint();
			hide();
		}
		
		private function btnUpdateListener(e:MouseEvent):void {
			update();
		}
		
		
		
		//-- Listeners
		private function routeSelectedListener(e:Event):void {
			hide(true);
		}
		
		private function routePointChangedListener(e:Event):void {
			init(_model.selectedRoutePoint.vo);
		}
		
		private function routePointSelectedListener(e:Event):void {
			init(_model.selectedRoutePoint.vo);
			show();
		}
		
		
		
		//-- Show
		private function show(directly:Boolean = false):void {
			addButtonListeners();
			
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
		
		
		
		
		//-- Init
		public function init(routePointVO:RoutePointVO):void {
			_currentRoutePointVO = routePointVO;
			
			txt_floor.text = _model.getFloorNameById(_currentRoutePointVO.floorId);
			txt_id.text = _currentRoutePointVO.id.toString();
			txt_pos_x.text = _currentRoutePointVO.x.toString();
			txt_pos_y.text = _currentRoutePointVO.y.toString();
			
			if (_currentRoutePointVO.panorama  &&  (_currentRoutePointVO.panorama.linkage != "")  &&  (_currentRoutePointVO.panorama.linkage != "-")) {
				txt_panorama.text = _currentRoutePointVO.panorama.linkage;
			} else {
				txt_panorama.text = "-";
			}
			
			if (_currentRoutePointVO.panorama) {
				// panorama exists, show the panorama's angles
				if (isNaN(_currentRoutePointVO.panorama.angleTransitionIn)) {
					txt_angle_in.text = "-";
				} else {
					txt_angle_in.text = _currentRoutePointVO.panorama.angleTransitionIn.toString();
				}
				
				if (isNaN(_currentRoutePointVO.panorama.angleTransitionOut)) {
					txt_angle_out.text = "-";
				} else {
					txt_angle_out.text = _currentRoutePointVO.panorama.angleTransitionOut.toString();
				}
				
				
			} else {
				// panorama doesnt exist, shot the route point's angles
				if (isNaN(_currentRoutePointVO.angleTransitionIn)) {
					txt_angle_in.text = "-";
				} else {
					txt_angle_in.text = _currentRoutePointVO.angleTransitionIn.toString();
				}
				
				if (isNaN(_currentRoutePointVO.angleTransitionOut)) {
					txt_angle_out.text = "-";
				} else {
					txt_angle_out.text = _currentRoutePointVO.angleTransitionOut.toString();
				}
			}
			
			
			txt_angle_in.restrict = "0-9.";
			txt_angle_out.restrict = "0-9.";
			txt_pos_y.restrict = "0-9.";
			txt_pos_y.restrict = "0-9.";
			
			showConnectionLine();
		}		
		
		private function update():void {
			_model.selectedRoutePoint.vo.x = Number(txt_pos_x.text);
			_model.selectedRoutePoint.vo.y = Number(txt_pos_y.text);
			//_model.selectedRoutePointVO.angleTransitionIn = Number(txt_angle_in.text);
			//_model.selectedRoutePointVO.angleTransitionOut = Number(txt_angle_out.text);
			
			if (_model.selectedRoutePoint.vo.panorama) {
				_model.selectedRoutePoint.vo.panorama.linkage = txt_panorama.text;
				_model.selectedRoutePoint.vo.panorama.angleTransitionIn = Number(txt_angle_in.text);
				_model.selectedRoutePoint.vo.panorama.angleTransitionOut = Number(txt_angle_out.text);
			} else {
				_model.selectedRoutePoint.vo.panorama = new PanoramaVO("", txt_panorama.text, Number(txt_angle_in.text), Number(txt_angle_out.text));
			}
			
			_controller.changeRoutePoint();
		}
		
		
		//-- Line
		private function showConnectionLine():void {
			var globalPoint:Point = _model.selectedRoutePoint.parent.localToGlobal(new Point(_model.selectedRoutePoint.x, _model.selectedRoutePoint.y));
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