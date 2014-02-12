// nl.photoreality.map_editor.view.map.RoutePlane 
package nl.photoreality.map_editor.view.map 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import nl.photoreality.map_editor.controller.Controller;
	import nl.photoreality.map_editor.model.Model
	import flash.display.MovieClip;
	import flash.events.Event;
	import nl.photoreality.map_editor.view.map.icons.ElevatorIcon;
	/**
	 * ...
	 * @author Miguel Fuentes // DioVoiD 2012
	 */
	public class RoutePlane extends MovieClip
	{
		private var _model			: Model;
		private var _controller		: Controller;
		private var _points			: Array;
		
		public var _route			: Sprite;
		public var _outline			: Sprite;
		
		
		public function RoutePlane() {
			_model = Model.getInstance();
			_controller = Controller.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, handleToStage);
		}
		
		private function handleToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, handleToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, handleFromStage);
			addListeners();
			init();
		}
		
		private function init():void {
			_route = new Sprite();
			_route.x = _route.y = 0;
			addChild(_route);
			visible = false;
		}
		
		private function handleFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, handleFromStage);
			removeListeners();
		}
		
		private function addListeners():void {
			_model.addEventListener(Model.DRAW_MODE_CHANGE , handleStartDrawing);
			trace("RoutePlane -> addListeners");
		}
		
		private function removeListeners():void {
			_model.removeEventListener(Model.DRAW_MODE_CHANGE , handleStartDrawing);
		}
		
		private function createOutline():void {
			trace("RoutePlane -> createOutline");
			_outline = new Sprite();
			_outline.x = _outline.y = 0;
			_outline.graphics.lineStyle(3, 0xFF0000);
			_outline.graphics.moveTo(0, 0);
			_outline.graphics.lineTo(width, 0);
			_outline.graphics.lineTo(width, height);
			_outline.graphics.lineTo(0, height);
			_outline.graphics.lineTo(0, 0);
			addChild(_outline);
		}
		
		private function removeOutline():void {
			_outline.graphics.clear();
		}
		
		private function handleStartDrawing(e:Event):void  {
			startDrawing();
		}
		
		private function startDrawing():void  {
			trace("RoutePlane -> handleStartDrawing");
			createOutline();
			visible = true;
			
			_points = new Array();
			_points.push(new Point( _model.currentPathEntranceIcon.x, _model.currentPathEntranceIcon.y) );
			
			drawPath( Point(_points[0]) );
			
			addEventListener(MouseEvent.MOUSE_MOVE , handleMouseMove);
			addEventListener(MouseEvent.CLICK , handleMouseClick);
			_controller.updateCurrentRoute(_points);
		}
		
		private function stopDrawing():void {
			removeOutline();
			removeEventListener(MouseEvent.MOUSE_MOVE , handleMouseMove);
			removeEventListener(MouseEvent.CLICK , handleMouseClick);
			drawPath(  );
		}
		
		private function handleMouseClick(e:MouseEvent):void 	{
			var clickPoint:Point = new Point( mouseX, mouseY);
			createPoint(clickPoint);
			drawPath(  );
		}
		
		private function handleMouseMove(e:MouseEvent):void {
			drawPath( new Point(mouseX, mouseY) );
		}
		
		private function createPoint(point:Point) {
			trace("RoutePlane -> handleMouseClick");
			
			var currentElevator		: ElevatorIcon;
			for (var i:int = 0; i < _model.elevatorIcons.length; i++) {
				currentElevator = ElevatorIcon(_model.elevatorIcons[i]);
				trace(_model.elevatorIcons[i].name)
				if (currentElevator.hitTest(point) ) {
					trace("RoutePlane -> handleMouseClick : HIT : " + currentElevator.name);
					point = new Point(currentElevator.x, currentElevator.y);
					
					stopDrawing();
				}
			}
			
			_points.push(point);
			_controller.updateCurrentRoute(_points);
		}
		
		private function drawPath(lastPoint:Point = null):void {
			_route.graphics.clear();
			_route.graphics.lineStyle(3, 0x000000);
			_route.graphics.moveTo( Point(_points[0]).x , Point(_points[0]).y );
			for (var i:int = 1; i < _points.length; i++) {
				_route.graphics.lineTo(Point(_points[i]).x, Point(_points[i]).y);
			}
			if (lastPoint){
				_route.graphics.lineTo(lastPoint.x, lastPoint.y);
			}
		}
	}

}