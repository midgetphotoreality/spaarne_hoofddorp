// nl.photoreality.map_editor.view.route.LabelContainer
package nl.photoreality.map_editor.view.route 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import nl.photoreality.map_editor.constants.EditorConstants;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.map_editor.model.vo.PositionLabelVO;
	import nl.photoreality.online_viewer.view.map.PointLabel;
	import nl.photoreality.utils.debug.Debug;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class LabelContainer extends Sprite {
		private var _model			: RouteModel;
		
		public var startLabelMC		: PointLabel
		public var endLabelMC		: PointLabel
		private var _offSet			: Point;
		
		public function LabelContainer() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			_offSet		= new Point(EditorConstants.FLOOR2_HORIZONTAL_OFFSET_X, EditorConstants.FLOOR2_HORIZONTAL_OFFSET_Y);
			_model 		= RouteModel.getInstance();
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			startLabelMC.visible 	= false;
			endLabelMC.visible 		= false;
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
		}
		
		private function addListeners():void {
			_model.addEventListener(RouteModel.LABEL_POSITION_CHANGED, routeSelectedListener);
			_model.addEventListener(RouteModel.ROUTE_SELECTED, labelPositionChanged);
		}
		
		private function removeListeners():void {
			_model.removeEventListener(RouteModel.ROUTE_SELECTED, routeSelectedListener);
			_model.removeEventListener(RouteModel.LABEL_POSITION_CHANGED, labelPositionChanged);
		}
		
		private function labelPositionChanged(e:Event):void {
			Debug.log("LabelContainer -> labelPositionChanged")
			routeSelectedListener(e);
		}
		
		private function routeSelectedListener(e:Event):void {
			Debug.log("LabelContainer -> routeSelectedListener")
			trace("1 OFFSET X: " + _model.selectedRouteVO.labels[0].startLabel.offsetX);
			trace("1 OFFSET Y: " + _model.selectedRouteVO.labels[0].endLabel.offsetY);
			
			trace("2 OFFSET X: " + _model.selectedRouteVO.labels[1].startLabel.offsetX);
			trace("2 OFFSET Y: " + _model.selectedRouteVO.labels[1].endLabel.offsetY);
			if (_model.selectedRouteVO.points.length < 1) {
				startLabelMC.init(_model.selectedRouteVO.labels[0].startLabel, new Point( -100, -100) );
				endLabelMC.init(_model.selectedRouteVO.labels[0].endLabel, new Point( -100, -100) );
				trace("startLabel")
				trace(new Point( -100, -100) )
				
				trace("endLabel")
				trace(new Point( -100, -100) )
			}else{
				startLabelMC.init(_model.selectedRouteVO.labels[0].startLabel, new Point(_model.selectedRouteVO.points[0].x, _model.selectedRouteVO.points[0].y));
				trace("startLabel")
				trace(new Point(_model.selectedRouteVO.points[0].x, _model.selectedRouteVO.points[0].y))
				trace("endLabel");
				if (_model.selectedRouteVO.floors[0].id == _model.selectedRouteVO.floors[1].id) {
					endLabelMC.init(_model.selectedRouteVO.labels[0].endLabel, new Point(_model.selectedRouteVO.points[_model.selectedRouteVO.points.length - 1].x, _model.selectedRouteVO.points[_model.selectedRouteVO.points.length - 1].y));
					
					trace(new Point(_model.selectedRouteVO.points[_model.selectedRouteVO.points.length - 1].x, _model.selectedRouteVO.points[_model.selectedRouteVO.points.length - 1].y))
				}else {
					trace("endLabelMC: "+ _offSet.x+","+ _offSet.y)
					endLabelMC.init(_model.selectedRouteVO.labels[0].endLabel, new Point(_model.selectedRouteVO.points[_model.selectedRouteVO.points.length - 1].x + _offSet.x, _model.selectedRouteVO.points[_model.selectedRouteVO.points.length - 1].y + _offSet.y));
					trace(new Point(_model.selectedRouteVO.points[_model.selectedRouteVO.points.length - 1].x + _offSet.x, _model.selectedRouteVO.points[_model.selectedRouteVO.points.length - 1].y + _offSet.y))
				}
			}
			
			startLabelMC.style 		= PointLabel.STYLE_START;
			endLabelMC.style 		= PointLabel.STYLE_END;
			startLabelMC.visible 	= true;
			endLabelMC.visible 		= true;
			startLabelMC.editable 	= true;
			endLabelMC.editable 	= true;
			/*
			startLabelMC.init(_model.selectedRouteVO.labels[0].startLabel, new Point(_model.selectedRouteVO.points[0].x, _model.selectedRouteVO.points[0].y));
			if (_model.selectedRouteVO.floors[0].id == _model.selectedRouteVO.floors[1].id) {
				endLabelMC.init(_model.selectedRouteVO.labels[0].endLabel, new Point(_model.selectedRouteVO.points[0].x, _model.selectedRouteVO.points[0].x));
				//endLabelMC.init(PositionLabelVO(_model.selectedRouteVO.labels[0].endLabel), new Point(_model.selectedRouteVO.points[0].x, _model.selectedRouteVO.points[0].x));
			}//endLabelMC.init(
			endLabelMC.init(_model.selectedRouteVO.labels[1].startLabel, new Point(_model.selectedRouteVO.points[0].x, _model.selectedRouteVO.points[0].x));
			startLabelMC.visible 	= false;
			endLabelMC.visible 		= false;
			*/
		}
		
		public function get offSet():Point { return _offSet; }
		
		public function set offSet(value:Point):void 
		{
			_offSet = value;
		}
		
	}

}