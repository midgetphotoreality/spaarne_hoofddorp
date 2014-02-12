// nl.photoreality.online_viewer.view.map.LabelContainer
package nl.photoreality.online_viewer.view.map 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.online_viewer.manager.MenuManager;
	import nl.photoreality.utils.debug.Debug;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class LabelContainer extends Sprite
	{
		private var _model		: RouteModel;
		
		public var label_start		: PointLabel
		public var label_end		: PointLabel
		public var f1_label		: MovieClip;
		public var f2_label		: MovieClip;
		
		private var _offSet		: Point;
		private var _isOnFirstFloor:Boolean = true;
		
		public function LabelContainer() {
			trace ("LabelContainer -> constructor")
			_model = RouteModel.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			visible = false;
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
		}
		
		private function addListeners():void {			
			_model.addEventListener(RouteModel.ROUTE_PLAY_FLOOR_CHANGED, handleFloorChange);
			//_model.addEventListener(RouteModel.ROUTE_SELECTED, handleRouteSelected);
			MenuManager.getInstance().addEventListener(MenuManager.ROUTE_SELECTED , handleRouteSelected);
		}
		
		private function removeListeners():void {
			_model.addEventListener(RouteModel.ROUTE_PLAY_FLOOR_CHANGED, handleFloorChange);
			MenuManager.getInstance().removeEventListener(MenuManager.ROUTE_SELECTED , handleRouteSelected);
			//_model.removeEventListener(RouteModel.ROUTE_SELECTED, handleRouteSelected);
		}
		
		private function handleFloorChange(e:Event):void {
			Debug.log("LabelContainer -> handleFloorChange(): "+_model.selectedRouteVO.floors.length);
			if (_isOnFirstFloor) {
				f1_label.gotoAndStop(1);
				f2_label.gotoAndStop(1);
				f2_label.play();
			}else {
				f2_label.gotoAndStop(1);
				f1_label.gotoAndStop(1);
				f1_label.play();
			}
			_isOnFirstFloor = !_isOnFirstFloor;
		}
		
		private function init():void {
			label_start.visible = false;
			label_end.visible = false;
			f1_label.visible = false;
			f2_label.visible = false;
		}
		
		private function handleRouteSelected(e:Event):void {
			Debug.log ("LabelContainer -> handleRouteSelected(): " + _model.selectedRouteVO.floors.length);
			var startPoint:Point
			var endPoint:Point
			label_start.visible = false;
			label_end.visible = false;
			f1_label.visible = false;
			f2_label.visible = false;
			if (_model.selectedRouteVO.floors.length > 0) {
				
				f1_label.tekstmc.tekst.text = _model.selectedRouteVO.labels[0].label;		
				if (!MenuManager.getInstance().virtualTourIsOpen){
					f1_label.visible = true;
				}
				f1_label.gotoAndStop(1);
				f1_label.play();
				_isOnFirstFloor = true;
				
				startPoint = new Point(_model.selectedRouteVO.points[0].x, _model.selectedRouteVO.points[0].y);
				label_start.init(_model.selectedRouteVO.labels[0].startLabel, startPoint);
				label_start.style = PointLabel.STYLE_START;
				label_start.visible = true;
				
				endPoint = new Point(_model.selectedRouteVO.points[_model.selectedRouteVO.points.length - 1].x, _model.selectedRouteVO.points[_model.selectedRouteVO.points.length - 1].y);
				if (_model.selectedRouteVO.floors.length > 1 && _model.selectedRouteVO.floors[0].id != _model.selectedRouteVO.floors[1].id) {
					endPoint = new Point(endPoint.x + _offSet.x, endPoint.y + _offSet.y);
					f2_label.tekstmc.tekst.text = _model.selectedRouteVO.labels[1].label;				
					f2_label.gotoAndStop(1);
					if (!MenuManager.getInstance().virtualTourIsOpen){
						f2_label.visible = true;
					}
				}
				label_end.style = PointLabel.STYLE_END;
				label_end.init(_model.selectedRouteVO.labels[0].endLabel, endPoint);
				
				label_end.visible = true;
			}
			
			visible = true;
		}
		
		public function get offSet():Point { return _offSet; }
		
		public function set offSet(value:Point):void 
		{
			_offSet = value;
		}
		
		public function printVersion():void {
			trace("LabelContainer -> printVersion")
			f1_label.visible = false;
			f2_label.visible = false;
		}
		
		public function normalVersion():void {
			trace("LabelContainer -> normalVersion")
			f1_label.visible = true;
			f2_label.visible = false;
			if (_model.selectedRouteVO.floors.length > 1 && _model.selectedRouteVO.floors[0].id != _model.selectedRouteVO.floors[1].id) {
				f2_label.visible = true;
			}
			
		}
	}

}