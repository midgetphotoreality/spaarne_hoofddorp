package nl.photoreality.map_editor.model.vo 
{
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	import com.adobe.crypto.SHA256;
	public class FloorVO
	{
		private var _name			:String;
		private var _linkage		:String;
		private var _isBaseFloor	:Boolean;
		private var _icons			:Vector.<IconVO>;
		private var _id				:String;
		
		public function FloorVO(name:String, linkage:String, isBaseFloor:Boolean,icons:Vector.<IconVO>,id:String = "" ) {
			_id = id;
			if (_id == "") {
				_id = "fl" + SHA256.hash( name + linkage + String(Math.random() * 100) );
				//trace("FloorVO -> id: "+_id);
			}
			_icons = icons;
			_isBaseFloor = isBaseFloor;
			_linkage = linkage;
			_name = name;
		}
		
		
		
		public function get linkage():String { return _linkage; }
		public function set linkage(value:String):void {
			_linkage = value;
		}
		
		public function get isBaseFloor():Boolean { return _isBaseFloor; }
		
		public function get icons():Vector.<IconVO> { return _icons; }
		public function set icons(value:Vector.<IconVO>):void {
			_icons = value;
		}
		
		public function get name():String { return _name; }
		public function set name(value:String):void {
			_name = value;
		}
		
		public function get id():String { return _id; }
		
		
		
	}

}