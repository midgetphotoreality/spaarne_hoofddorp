// nl.photoreality.online_viewer.view.area.AreaView
package nl.photoreality.azm_viewer.view.area 
{
	import fl.transitions.easing.Strong;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nl.photoreality.azm_viewer.manager.MenuManager;
	import nl.photoreality.utils.debug.Debug;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class AreaView extends MovieClip
	{
		
		private var _menuMan			: MenuManager;
		public var close_btn			: MovieClip;
		public var transport_desc_mc			: MovieClip;
		
		public function AreaView() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			_menuMan = MenuManager.getInstance();
			visible = false;
			alpha = 0;
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
			//init();
			//var myTween:Tween = new Tween(my_box, "alpha", Strong.easeOut, 1, 0, 10, true);
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
			//destroy();
		}
		
		private function addListeners():void {
			_menuMan.addEventListener(MenuManager.SHOW_AREA, handleShowArea);
			_menuMan.addEventListener(MenuManager.HIDE_AREA, handleHideArea);
			_menuMan.addEventListener(MenuManager.TRANSPORTATION_CHANGED, handleTransportChanged);
			close_btn.addEventListener(MouseEvent.CLICK, handleClose);
		}
		
		private function removeListeners():void {
			_menuMan.removeEventListener(MenuManager.SHOW_AREA, handleShowArea);
			_menuMan.removeEventListener(MenuManager.HIDE_AREA, handleHideArea);
			_menuMan.removeEventListener(MenuManager.TRANSPORTATION_CHANGED, handleTransportChanged);
			close_btn.addEventListener(MouseEvent.CLICK, handleClose);
		}
		
		private function handleClose(e:MouseEvent):void 
		{
			_menuMan.dispatch(MenuManager.HIDE_AREA);
		}
		
		private function handleTransportChanged(e:Event):void {
			transport_desc_mc.gotoAndStop(_menuMan.currentTransportation);
		}
		
		private function handleShowArea(e:Event):void {
			visible = true;
			var myTween:Tween = new Tween(this, "alpha", Strong.easeOut, 0, 1, 10, true);
			//myTween.addEventListener(TweenEvent.MOTION_FINISH, handleFinished);
		}
		
		private function handleFinished(e:TweenEvent):void 
		{
			visible = false;
			alpha = 0;
		}
		
		private function handleHideArea(e:Event):void {
			var myTween:Tween = new Tween(this, "alpha", Strong.easeOut, 1, 0, 10, true);
			myTween.addEventListener(TweenEvent.MOTION_FINISH, handleFinished);
		}
		
		
		
	}

}