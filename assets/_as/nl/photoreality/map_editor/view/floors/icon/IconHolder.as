//  nl.photoreality.map_editor.view.floors.icon.IconHolder 
package nl.photoreality.map_editor.view.floors.icon 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import nl.photoreality.map_editor.controller.FloorController;
	import nl.photoreality.map_editor.model.vo.IconVO;
	import nl.photoreality.utils.display.Provider;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class IconHolder extends Provider
	{
		public var _hitter				: Sprite;
		
		public static const WIDTH			: Number = 25;
		public static const HEIGHT			: Number = 25;
		private var _icon					: IconVO;
		public var _iconMc				: MovieClip;
		private var _controller			: FloorController;
		
		public function IconHolder(icon:IconVO) {
			_icon = icon;
			_controller = FloorController.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
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
			init();
		}
		
		private function removeListeners():void {
			_hitter.removeEventListener(MouseEvent.CLICK, handleIconClick);
		}
		
		private function init():void {
			trace("init crap" + _icon.linkage);
			_iconMc 					= MovieClip( provideMc(_icon.linkage) );
			_iconMc.x 				= WIDTH / 2;// - _iconMc.width / 2;
			_iconMc.y 				= HEIGHT / 2;// - _iconMc.height / 2;
			addChild(_iconMc);
			
			_hitter						= new Sprite();
			_hitter.graphics.beginFill(0xFF0000, 0);
			_hitter.graphics.drawRect(0, 0, WIDTH, HEIGHT);
			_hitter.graphics.endFill();
			_hitter.x = _hitter.y 	= 0;
			addChild(_hitter);
			_hitter.addEventListener(MouseEvent.CLICK, handleIconClick);
			_hitter.useHandCursor = _hitter.buttonMode = true;
		}
		
		private function handleIconClick(e:MouseEvent):void {
			trace("IconHolder -> handleIconClick()");
			_controller.placeIcon( this, new Point(this.mouseX, this.mouseY) );
		}
		
		public function get iconMc():MovieClip {
			return MovieClip(provideMc(_icon.linkage));
		}
		
		public function get icon():IconVO { return _icon; }
		
		/*
		var shitHitRectangle:Rectangle = shit.getBounds(this);
			var shitHit:Sprite = new Sprite();
			shitHit.graphics.beginFill(0xFF0000, 1);
			shitHit.graphics.drawRect(shitHitRectangle.x, shitHitRectangle.y, shitHitRectangle.width, shitHitRectangle.height);
			shitHit.graphics.endFill();
		*/
		
	}

}