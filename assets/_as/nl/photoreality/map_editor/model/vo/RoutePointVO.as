//nl.photoreality.map_editor.model.vo.RoutePointVO
package nl.photoreality.map_editor.model.vo {
	
	
	public class RoutePointVO {
		
		private var _angleTransitionIn		: Number;
		private var _angleTransitionOut		: Number;
		private var _floorId				: String;
		//private var _floor				: FloorVO;
		private var _icon					: IconVO;
		private var _id						: uint;
		private var _panorama				: PanoramaVO;
		private var _x						: Number;
		private var _y						: Number;
		
		
		public function RoutePointVO(id:uint, x:Number, y:Number, floorId:String/*floor:FloorVO*/, icon:IconVO = null, panorama:PanoramaVO = null) {
			_floorId = floorId;
			//_floor = floor;
			_icon = icon;
			_id = id;
			_panorama = panorama;
			_x = x;
			_y = y;
		}
		
		
		//-- Getters & Setters
		public function get angleTransitionIn():Number { return _angleTransitionIn; }
		public function set angleTransitionIn(value:Number):void {
			_angleTransitionIn = value;
		}
		
		public function get angleTransitionOut():Number { return _angleTransitionOut; }
		public function set angleTransitionOut(value:Number):void {
			_angleTransitionOut = value;
		}
		
		public function get floorId():String { return _floorId; }
		public function set floorId(value:String):void {
			_floorId = value;
		}
		/*
		public function get floor():FloorVO { return _floor; }
		public function set floor(value:FloorVO):void {
			_floor = value;
		}
		*/
		public function get id():uint { return _id; }
		public function set id(value:uint):void {
			_id = value;
		}
		
		public function get icon():IconVO { return _icon; }
		public function set icon(value:IconVO):void {
			_icon = value;
		}
		
		public function get panorama():PanoramaVO { return _panorama; }
		public function set panorama(value:PanoramaVO):void {
			_panorama = value;
		}
		
		public function get x():Number { return _x; }
		public function set x(value:Number):void {
			_x = value;
		}
		
		public function get y():Number { return _y; }
		public function set y(value:Number):void {
			_y = value;
		}
	}
}