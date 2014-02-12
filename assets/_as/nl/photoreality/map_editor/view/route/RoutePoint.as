//nl.photoreality.map_editor.view.route.RoutePoint
package nl.photoreality.map_editor.view.route {
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import nl.photoreality.map_editor.controller.RouteController;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.map_editor.model.vo.RoutePointVO;
	import nl.photoreality.utils.debug.Debug;
	
	
	public class RoutePoint extends MovieClip {
		
		private var _model					: RouteModel;
		
		private var _isEditable				: Boolean;
		private var _isEnabled				: Boolean;
		private var _offsetX				: Number;
		private var _offsetY				: Number;
		private var _vo						: RoutePointVO;
		
		// stage instances
		public var hitter_mc				: MovieClip;
		public var outline_mc				: MovieClip;
		
		
		public function RoutePoint(vo:RoutePointVO, isEditable:Boolean, offsetX:Number = 0, offsetY:Number = 0) {
			if (isEditable) {
				trace("RoutePoint -> editable point x: "+vo.x+" y: "+vo.y)
			}
			_isEditable = isEditable;
			//_isEditable = isEditable;
			_model = RouteModel.getInstance();
			_offsetX = offsetX;
			_offsetY = offsetY;
			_vo = vo;
			
			x = vo.x + _offsetX;
			y = vo.y + _offsetY;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			deselect();
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			
			//if (!_isEditable) { return; }
			removeListeners();
		}
		
		private function addListeners():void {
			//Debug.log ("RoutePoint -> addListeners()",true);
			hitter_mc.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			hitter_mc.buttonMode = true;
			hitter_mc.useHandCursor = true;
		}
		
		private function removeListeners():void {
			//Debug.log ("RoutePoint -> removeListeners()",true);
			hitter_mc.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			hitter_mc.buttonMode = false;
			hitter_mc.useHandCursor = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
		}
		
		
		
		//-- Enable
		public function enable():void {
			//Debug.log("RoutePoint -> enable, _isEditable: "+_isEditable,true)
			//if (!_isEditable) { return; }
			
			_isEnabled = true;
			//this.mouseChildren = true;
			//this.mouseEnabled = true;
			addListeners();
		}
		
		public function disable():void {
			//if (!_isEditable) { return; }
			
			_isEnabled = false;
			//this.mouseChildren = false;
			//this.mouseEnabled = false;
			removeListeners();
			deselect();
		}
		
		
		
		
		//-- Mouse Listeners
		private function mouseDownListener(e:MouseEvent):void {
			trace("RoutePoint -> mouseDownListener : " + x + "/" + y);
			if (_isEditable) {
				if (!outline_mc.visible) {
					select();
					
				} else {
					stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
					stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
				}
			} else {
				select();
			}
		}
		
		private function mouseMoveListener(e:MouseEvent):void {
			
			var mousePoint:Point = this.parent.globalToLocal(new Point(stage.mouseX, stage.mouseY));
			trace("RoutePoint -> mouseMoveListener x: "+mousePoint.x+", y:"+mousePoint.y);
			//edit(mousePoint.x - _offsetX, mousePoint.y - _offsetY);
			_vo.x = mousePoint.x - _offsetX;
			_vo.y = mousePoint.y - _offsetY;
			//this.x = mousePoint.x;
			//this.y = mousePoint.y;
			
			RouteController.getInstance().changeRoutePoint();
			trace("RoutePoint -> mouseMoveListener this x: "+x+", this y:"+y);
		}
		
		private function mouseUpListener(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
		}
		
		
		
		
		
		//-- Outline
		public function select():void {
			//if (!_isEditable) { return; }
			trace("RoutePoint -> select()"+x+","+y);
			RouteController.getInstance().selectRoutePoint(this);
			
			if (_isEditable) {
				outline_mc.visible = true;
			}
		}
		
		public function deselect():void {
			outline_mc.visible = false;
		}
		
		
		
		//-- Last Point
		public function setAsLastPoint():void {
			this.gotoAndStop("LAST");
		}
		
		public function showLastAnimation():void {
			this.gotoAndPlay("LAST");
		}
		
		//-- Getters & Setters
		public function get isEnabled():Boolean { return _isEnabled; }
		
		public function get vo():RoutePointVO { return _vo; }
	}
}