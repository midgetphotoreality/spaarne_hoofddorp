package nl.photoreality.map_editor.view.floors 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nl.photoreality.map_editor.model.vo.FloorVO;
	import nl.photoreality.map_editor.view.map.icons.Icon;
	import nl.photoreality.utils.display.Provider;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class FloorContainer extends Provider
	{
		private var _floor									: FloorVO;
		public var _container								: MovieClip;
		public var _floorContainer							: MovieClip;
		public var _iconContainer							: MovieClip;
		public var _outline									: Sprite;
		public var _bg										: Sprite;
		private var _icons									: Vector.<Icon>;
		
		private var _printable								: Boolean;
		
		public function FloorContainer() {
			_container 										= new MovieClip();
			_floorContainer 								= new MovieClip();
			_iconContainer 									= new MovieClip();
			_bg			 									= new MovieClip();
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
			//init();
		}
		
		private function removeListeners():void {
			deinit();
		}
		
		public function drawOutline():void {
			_outline = new Sprite();
			_outline.graphics.lineStyle(1, 0xff0000, 1);
			_outline.graphics.moveTo(0, 0);
			_outline.graphics.lineTo(_floorContainer.width, 0);
			_outline.graphics.lineTo(_floorContainer.width, _floorContainer.height);
			_outline.graphics.lineTo(0, _floorContainer.height);
			_outline.graphics.lineTo(0, 0);
		}
		
		public function drawBackGround():void {
			_bg = new Sprite();
			_bg.graphics.beginFill(0xFF0000, 1);
			_bg.graphics.moveTo(0, 0);
			_bg.graphics.lineTo(_floorContainer.width, 0);
			_bg.graphics.lineTo(_floorContainer.width, _floorContainer.height);
			_bg.graphics.lineTo(0, _floorContainer.height);
			_bg.graphics.lineTo(0, 0);
			_bg.graphics.endFill();
		}
		
		private function init():void {
			trace("FloorContainer -> init: " +_floor.icons.length);
			deinit();
			
			_container.x 	=_container.y				= 0;
			addChild(_container);
			_bg.visible = false;
			_bg.x = _bg.y	= 0;
			_container.addChild(_bg);
			
			_floorContainer.x = _floorContainer.y	= 0;
			_container.addChild(_floorContainer);
			_floorContainer.addChild(MovieClip(provideMc(_floor.linkage)));
			
			drawOutline();
			_container.addChild(_outline);
			outline = false;
			_iconContainer.x = _iconContainer.y 	= 0;
			_container.addChild(_iconContainer);
			
			drawBackGround();
			
			
			
			
			_icons = new Vector.<Icon>();
			for (var i:int = 0; i < _floor.icons.length; i++) {
				var icon:Icon = Icon(provideMc(_floor.icons[i].linkage));
				icon.vo = _floor.icons[i];
				_icons.push( icon );
				icon.x = _floor.icons[i].x;
				icon.y = _floor.icons[i].y;
				icon.rotation = _floor.icons[i].rotation;
				_iconContainer.addChild(icon);
			//	trace("FloorContainer -> Adding icon to _iconContainer," + String(i) + ": " + icon.name);
			}
			//trace("FloorContainer -> init done, icons: " + _icons.length + " / numChildren :" + _iconContainer.numChildren);
		}
		public function reinit():void {
			init();
		}
		
		public function deinit():void {
			/*
			for (var i:int = 0; i < _icons.length; i++) {
				var mc:MovieClip = MovieClip(_icons[i]["icon"]);
				mc.hasEventListener(MouseEvent.CLICK)
			}
			*/
			while (_floorContainer.numChildren) {
				_floorContainer.removeChildAt(0);
			}
			while (_iconContainer.numChildren) {
				_iconContainer.removeChildAt(0);
			}
			while (_container.numChildren) {
				_container.removeChildAt(0);
			}
			while (numChildren) {
				removeChildAt(0);
			}
		}
		
		public function get floor():FloorVO { return _floor; }
		public function set floor(value:FloorVO):void 	{
			_floor = value;
			init();
		}
		
		public function get icons():Vector.<Icon> { return _icons; }
		
		public function set outline(value:Boolean):void {
			_outline.visible = value;
		}
		
		public function get printable():Boolean { return _printable; }
		
		public function set printable(value:Boolean):void 
		{
			trace("FloorContainer -> printable: "+value);
			_printable = value;
			_bg.visible = _printable;
		}
	}

}