//nl.photoreality.map_editor.model.vo.IconVO
package nl.photoreality.map_editor.model.vo {
	import com.adobe.crypto.SHA256;
	
	
	public class IconVO {
		
		private var _linkage		: String;
		private var _name			: String;
		private var _x				: Number;
		private var _y				: Number;
		private var _rotation		: Number;
		private var _id				: String;
		
		
		public function IconVO(name:String, linkage:String, x:Number = 0, y:Number = 0, rotation:Number = 0, id:String = "" ) {
			_id = id;
			if (_id == "") {
				_id = "fl" + SHA256.hash( name + linkage + String(Math.random() * 100) );
				//trace("IconVO -> id: "+_id);
			}
			_rotation = rotation;
			_name = name;
			_linkage = linkage;
			_x = x;
			_y = y;
		}
		
		
		//-- Getters & Setters
		public function get linkage():String { return _linkage; }
		public function set linkage(value:String):void {
			_linkage = value;
		}
		
		public function get name():String { return _name; }
		public function set name(value:String):void {
			_name = value;
		}
		
		public function get x():Number { return _x; }
		public function set x(value:Number):void {
			_x = value;
		}
		
		public function get y():Number { return _y; }
		public function set y(value:Number):void {
			_y = value;
		}
		
		public function get rotation():Number { return _rotation; }
		public function set rotation(value:Number):void {
			_rotation = value;
		}
		
		public function get id():String { return _id; }
	}
}