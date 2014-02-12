package nl.photoreality.online_viewer.view.menu 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import nl.photoreality.map_editor.model.vo.RouteVO;
	import nl.photoreality.online_viewer.manager.MenuManager;
	import nl.photoreality.online_viewer.view.menu.button.IndexLabelButton;
	import nl.photoreality.utils.display.Provider;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class Menu extends MovieClip
	{
		/* array met alfabet letters + counts
		 * array met letter items + lame print bladibladi
		 * all letter bladi mus be on fixed place
		 * jee
		 * 
		 */
		public static const	INDEX_BUTTON_LINKAGE		:String 	= "menuIndexBtn_mc";
		public static const	DEPARTMENT_BUTTON_LINKAGE	:String 	= "departmentBtn_mc";
		
		private var _routes								: Vector.<RouteVO>;
		private var _indexButton						: Vector.<IndexLabelButton>;
		private var _alphabeth							: Array;
		private var _indexItems							: Object;
		public var _indexButtonContainer				: MovieClip;
		private var _menuMan							: MenuManager;
		
		public function Menu(routes:Vector.<RouteVO>) {
			_routes 	= routes
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			_menuMan	= MenuManager.getInstance();
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
			//destroy();
		}
		
		private function addListeners():void {
			_menuMan.addEventListener(MenuManager.SHOW_MENU , handleShowMenu);
			_menuMan.addEventListener(MenuManager.HIDE_MENU , handleHideMenu);
		}
		
		private function removeListeners():void {
			_menuMan.removeEventListener(MenuManager.SHOW_MENU , handleShowMenu);
			_menuMan.removeEventListener(MenuManager.HIDE_MENU , handleHideMenu);
		}
		
		private function handleShowMenu(e:Event):void {
			visible = true;
		}
		
		private function handleHideMenu(e:Event):void {
			visible = false;
		}
		
		public function destroy():void {
			
		}
		private function vectorToArray(v:*):Array {
			var n:int = v.length; var a:Array = new Array();
			for(var i:int = 0; i < n; i++) a[i] = v[i];
			return a;
		}
		private function init():void {
			//trace("Menu -> init(), routes.length: "+_routes.length,this)
			//_alphabeth = new Array("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z");
			//var al:Array = new Array("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z");
			var al:Array = new Array("A", "B", "C", "D", "F", "G", "H", "I",  "K", "L", "M", "N", "O", "P",  "R", "S", "T", "U", "V", "W");
			//_alphabeth.push("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z");
			_alphabeth = al;
			//trace("Menu -> init(), route slice 1");
			var _routesSearch:Array = vectorToArray(_routes);
			_routesSearch.sortOn("nameLower");
			_routesSearch.reverse();
			//var _routesSearch:Vector.<RouteVO> = _routes.slice(0);
			//trace("Menu -> init(), route slice 2");
			var _currentLetter:Vector.<RouteVO>;// = _routes.slice(0);
			var _currentLetterArray:Array;// = _routes.slice(0);
			//trace("Menu ->_routesSearch.length :" + _routesSearch.length);
			_indexItems = new Object();
			var i:int
			
			for (i = 0; i < _alphabeth.length; i++) {
				_currentLetter = new Vector.<RouteVO>();
				//_currentLetterArray = 
				for (var u:int = _routesSearch.length - 1; u >= 0 ; u--) {
					if (RouteVO(_routesSearch[u]).name.substr(0, 1).toLowerCase() == _alphabeth[i].toLowerCase() ) {
						_currentLetterArray = _routesSearch.splice(u, 1);
						_currentLetter.push(RouteVO(_currentLetterArray[0]));
					}
				}
				_indexItems["item" + _alphabeth[i].toLowerCase()] = _currentLetter;
			}
			_indexButtonContainer = new MovieClip();
			addChild(_indexButtonContainer);
			_indexButtonContainer.x = _indexButtonContainer.y = 0;
			var _indexButton		: IndexLabelButton;
			for (i = 0; i < _alphabeth.length; i++) {
				//menuIndexBtn_mc
				_indexButton = IndexLabelButton(provideMc(INDEX_BUTTON_LINKAGE));//new IndexLabelButton();
				var name: String = _alphabeth[i].toUpperCase();
				var buttonDepartments:Vector.<RouteVO> = _indexItems["item" + _alphabeth[i].toLowerCase()];
				_indexButtonContainer.addChild(_indexButton);
				_indexButton.x = 2;
				_indexButton.y = (35 * i) + 4;
				_indexButton.init(name, buttonDepartments);
				
				
			}
			/*
			 * TypeError: Error #1034: Type Coercion failed: cannot convert 
			 * __AS3__.vec::Vector.<nl.photoreality.map_editor.model.vo::RouteVO>@2a61f101 
			 * to nl.photoreality.map_editor.model.vo.RouteVO.
	at Vector$object/http://adobe.com/AS3/2006/builtin::push()
			 */
		}
		
		private function provideMc(linkage:String):DisplayObject {
			var tCL:Class = getDefinitionByName(linkage) as Class;
			var tMC:DisplayObject = new tCL() as DisplayObject;
			return(tMC);
		}
	}

}