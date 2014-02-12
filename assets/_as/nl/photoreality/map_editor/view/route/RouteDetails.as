// nl.photoreality.map_editor.view.route.RouteDetails
package nl.photoreality.map_editor.view.route {
	
	import com.greensock.TweenLite;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import nl.photoreality.map_editor.controller.RouteController;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.map_editor.model.vo.RouteVO;
	import nl.photoreality.map_editor.view.route.details.LabelPositionWidget;
	import nl.photoreality.utils.debug.Debug;
	
	
	public class RouteDetails extends Sprite {
		
		private var _controller								: RouteController;
		private var _model									: RouteModel;
		private var _route									: RouteVO;
		
		// stage instances				
		public var btn_close								: SimpleButton;
		public var btn_remove								: SimpleButton;
		public var btn_update								: SimpleButton;
		
		public var txt_name									: TextField;
		
		public var btn_endLabelPosition						: LabelPositionWidget;
		public var btn_startLabelPosition 					: LabelPositionWidget;
		
		public var txt_f1_label								: TextField;
		public var txt_start_label							: TextField;
		public var txt_end_label							: TextField;
		public var txt_f2_label								: TextField;
		
		
		public function RouteDetails() {
			trace("RouteDetails -> constructor");
			_controller = RouteController.getInstance();
			_model = RouteModel.getInstance();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			//hide(true);
			show(true);
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
		}
		
		private function addButtonListeners():void {
			btn_close.addEventListener(MouseEvent.CLICK, btnCloseListener);
			btn_remove.addEventListener(MouseEvent.CLICK, btnRemoveListener);
			btn_update.addEventListener(MouseEvent.CLICK, btnUpdateListener);
			
			btn_startLabelPosition.addEventListener(LabelPositionWidget.POSITION_CHANGED, handlePositionChange);
			btn_endLabelPosition.addEventListener(LabelPositionWidget.POSITION_CHANGED, handlePositionChange);
		}
		
		private function removeListeners():void {
			_model.removeEventListener(RouteModel.ROUTE_SELECTED, routeSelectedListener);
		}
		
		private function removeButtonListeners():void {
			btn_close.removeEventListener(MouseEvent.CLICK, btnCloseListener);
			btn_remove.removeEventListener(MouseEvent.CLICK, btnRemoveListener);
			btn_update.removeEventListener(MouseEvent.CLICK, btnUpdateListener);
			
			btn_startLabelPosition.removeEventListener(LabelPositionWidget.POSITION_CHANGED, handlePositionChange);
			btn_endLabelPosition.removeEventListener(LabelPositionWidget.POSITION_CHANGED, handlePositionChange);
		}
		
		
		
		//-- Button Listeners
		private function btnCloseListener(e:MouseEvent):void {
			hide();
		}
		
		private function btnRemoveListener(e:MouseEvent):void {
			hide();
		}
		
		private function btnUpdateListener(e:MouseEvent):void {
			trace("RouteDetails -> btnUpdateListener");
			update();
		}
		
		
		
		//-- Listeners
		private function routeSelectedListener(e:Event):void {
			// hide(true);
			init(_model.selectedRouteVO);
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
		public function init(route:RouteVO):void {
			
			_route 					= route;
			Debug.log("RouteDetails -> init()", true);
			Debug.log("-- _route.floors.length :" + _route.floors.length, true);
			Debug.log("-- _route.labels.length :" + _route.labels.length, true);
			
			
			clearInputFields();
			txt_name.text			= _route.name;
			
			
			trace("1. RouteDetails -> init , btn_startLabelPosition.position: "+btn_startLabelPosition.position+", _route.labels[0].startLabel.position: "+_route.labels[0].startLabel.position)
			trace("1. RouteDetails -> init , btn_endLabelPosition.position: "+btn_endLabelPosition.position+", _route.labels[0].endLabel.position: "+_route.labels[0].endLabel.position)
			btn_startLabelPosition.initPosition(_route.labels[0].startLabel.position);
			trace("1c. RouteDetails -> init , btn_endLabelPosition.position: "+btn_endLabelPosition.position+", _route.labels[0].endLabel.position: "+_route.labels[0].endLabel.position)
			btn_endLabelPosition.initPosition(_route.labels[0].endLabel.position);
			trace("2. RouteDetails -> init , btn_startLabelPosition.position: "+btn_startLabelPosition.position+", _route.labels[0].startLabel.position: "+_route.labels[0].startLabel.position)
			trace("2. RouteDetails -> init , btn_endLabelPosition.position: "+btn_endLabelPosition.position+", _route.labels[0].endLabel.position: "+_route.labels[0].endLabel.position)
			txt_f1_label.text		= _route.labels[0].label;
			txt_start_label.text	= _route.labels[0].startLabel.label;
			txt_end_label.text		= _route.labels[0].endLabel.label;
			txt_f2_label.text		= _route.labels[1].label;
			
			
			trace (btn_startLabelPosition);
			trace(_route.labels[0].startLabel.position);
			
		}		
		
		private function clearInputFields():void {
			txt_name.text			= "";
			txt_f1_label.text		= "";
			txt_start_label.text	= "";
			txt_end_label.text		= "";
			txt_f2_label.text		= "";
		}
		
		private function update():void {
			Debug.log("RouteDetails -> update...",true)
			_route.name 					= txt_name.text;
			if (_route.floors.length > 0 ) {
				Debug.log("RouteDetails -> updating floor 1 labels...",true)
				_model.selectedRouteVO.labels[0].label 					= txt_f1_label.text;
				_model.selectedRouteVO.labels[0].startLabel.label		= txt_start_label.text;
				_model.selectedRouteVO.labels[0].startLabel.position 	= btn_startLabelPosition.position;
				_model.selectedRouteVO.labels[0].endLabel.label			= txt_end_label.text;
				_model.selectedRouteVO.labels[0].endLabel.position 		= btn_endLabelPosition.position;
			}
			if (_route.floors.length > 1 ) {
				Debug.log("RouteDetails -> updating floor 2 labels...",true)
				_model.selectedRouteVO.labels[1].label					= txt_f2_label.text;
				_model.selectedRouteVO.labels[1].startLabel.label		= txt_start_label.text;
				_model.selectedRouteVO.labels[1].startLabel.position 	= btn_startLabelPosition.position;
				_model.selectedRouteVO.labels[1].endLabel.label			= txt_end_label.text;
				_model.selectedRouteVO.labels[1].endLabel.position 		= btn_endLabelPosition.position;
			}
			
			handlePositionChange(null);
		}
		
		private function handlePositionChange(e:Event):void {
			_model.selectedRouteVO.labels[0].startLabel.position 	= btn_startLabelPosition.position;
			_model.selectedRouteVO.labels[0].endLabel.position 		= btn_endLabelPosition.position;
			
			_model.selectedRouteVO.labels[1].startLabel.position 	= btn_startLabelPosition.position;
			_model.selectedRouteVO.labels[1].endLabel.position 		= btn_endLabelPosition.position;
			
			_model.dispatch(RouteModel.LABEL_POSITION_CHANGED);
			
			trace ("handlePositionChange :"+_model.selectedRouteVO.labels[0].startLabel.position+" / "+_model.selectedRouteVO.name);
			trace ("handlePositionChange :"+_model.selectedRouteVO.labels[0].endLabel.position);
		}
		
		
	}
}