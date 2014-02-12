//  nl.photoreality.map_editor.view.floors.IconView
package nl.photoreality.map_editor.view.floors 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.map_editor.model.vo.IconVO;
	import nl.photoreality.map_editor.view.floors.icon.IconHolder;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class IconView extends MovieClip
	{
		public var _container	: MovieClip;
		private var _model		: Model;
		
		private var 	_icons		: Vector.<IconHolder>
		public function IconView() {
			
			_model 		= Model.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
			init();
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
		}
		
		private function addListeners():void {
			
		}
		
		private function removeListeners():void {
			
		}
		
		private function init():void {
			trace("IconView -> init(), icons: " + _model.icons.length);
			_container 	= new MovieClip();
			addChild(_container); 
			var icon		: IconHolder	
			for (var i:int = 0; i < _model.icons.length; i++) {
				icon = new IconHolder(IconVO(_model.icons[i]));
				icon.x = i*(IconHolder.WIDTH+5)
				_container.addChild(icon);
			}
		}
		
	}

}