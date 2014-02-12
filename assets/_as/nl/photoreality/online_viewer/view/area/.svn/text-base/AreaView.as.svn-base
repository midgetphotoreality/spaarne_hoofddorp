// nl.photoreality.online_viewer.view.area.AreaView
package nl.photoreality.online_viewer.view.area 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nl.photoreality.online_viewer.manager.MenuManager;
	import nl.photoreality.utils.debug.Debug;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class AreaView extends MovieClip
	{
		public var overzicht_btn		: SimpleButton;
		public var back_btn		 		: SimpleButton;
		public var area_mc		 		: MovieClip;
		private var _menuMan			: MenuManager;
		
		public function AreaView() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			_menuMan = MenuManager.getInstance();
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
			//init();
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
			//destroy();
		}
		
		private function addListeners():void {
			area_mc.visible = false;
			back_btn.visible = false;
			overzicht_btn.addEventListener(MouseEvent.CLICK, handleOverzichtClick);
			back_btn.addEventListener(MouseEvent.CLICK, handleBackClick);
		}
		
		private function removeListeners():void {
			overzicht_btn.removeEventListener(MouseEvent.CLICK, handleOverzichtClick);
			back_btn.removeEventListener(MouseEvent.CLICK, handleBackClick);
		}
		
		private function handleOverzichtClick(e:MouseEvent):void {
			Debug.log("AreaView -> handleOverzichtClick")
			overzicht_btn.visible 	= false;
			area_mc.visible 		= true;
			back_btn.visible 		= true;
			area_mc.gotoAndPlay(1);
			_menuMan.hideMenu();
			_menuMan.dispatch(MenuManager.SHOW_AREA);
		}
		
		private function handleBackClick(e:MouseEvent):void {
			Debug.log("AreaView -> handleBackClick")
			overzicht_btn.visible 	= true;
			area_mc.visible 		= false;
			back_btn.visible 		= false;
			area_mc.gotoAndStop(1);
			_menuMan.showMenu();
			_menuMan.dispatch(MenuManager.HIDE_AREA);
		}
		
	}

}