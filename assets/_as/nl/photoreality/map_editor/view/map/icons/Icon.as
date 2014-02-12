//  nl.photoreality.map_editor.view.map.icons.Icon
package nl.photoreality.map_editor.view.map.icons 
{
	import flash.display.MovieClip;
	import nl.photoreality.map_editor.model.vo.IconVO;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class Icon extends MovieClip
	{
		private var _vo		: IconVO;			
		public function Icon() {
			//trace("IconVO -> constructor: "+name)
		}
		
		public function get vo():IconVO { return _vo; }
		
		public function set vo(value:IconVO):void {
			_vo = value;
		}
		
	}

}