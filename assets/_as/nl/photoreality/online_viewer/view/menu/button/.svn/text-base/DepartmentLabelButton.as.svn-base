// nl.photoreality.online_viewer.view.menu.button.DepartmentLabelButton
package nl.photoreality.online_viewer.view.menu.button 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import nl.photoreality.map_editor.model.vo.RouteVO;
	import nl.photoreality.online_viewer.manager.MenuManager;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class DepartmentLabelButton extends MovieClip {
		public static const		SELECT		: String = "select";
		public static const		REVERT		: String = "revert";
		public static const		OVER		: String = "over";
		public static const		DEFAULT		: String = "default";
		public var label_mc					: MovieClip;
		public var hitter_mc				: MovieClip;
		public var label					: TextField;
		private var _isSelected				: Boolean = false;
		private var _routeVO				: RouteVO;
		private var _menuManager			: MenuManager;
		
		public function DepartmentLabelButton() {
			////trace("DepartmentLabelButton -> constructor");
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			_menuManager = MenuManager.getInstance();
			label	 = TextField(label_mc.label);
			stop();
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
			hitter_mc.useHandCursor = true;
			hitter_mc.buttonMode 	= true;
			hitter_mc.addEventListener(MouseEvent.CLICK, handleClick);
			hitter_mc.addEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			hitter_mc.addEventListener(MouseEvent.ROLL_OUT, handleRollOut);
			_menuManager.addEventListener(MenuManager.ROUTE_SELECTED , handleRouteSelected);
		}
		
		private function removeListeners():void {
			hitter_mc.removeEventListener(MouseEvent.CLICK, handleClick);
			hitter_mc.removeEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			hitter_mc.removeEventListener(MouseEvent.ROLL_OUT, handleRollOut);
			_menuManager.removeEventListener(MenuManager.ROUTE_SELECTED , handleRouteSelected);
		}
		
		private function handleRouteSelected(e:Event):void 	{
			if (_menuManager.selectedDepartmentButton == this) {
				select();
				//_isSelected = true;
				
			}else {
				revert();
				//_isSelected = false;
				//revert();
			}
		}
		
		private function handleRollOut(e:MouseEvent):void {
			if (!_isSelected){
				gotoAndStop(DEFAULT);
			}
		}
		
		private function handleRollOver(e:MouseEvent):void {
			if (!_isSelected){
				gotoAndStop(OVER);
			}
		}
		
		public function init(routeVO:RouteVO):void {
			_routeVO = routeVO;
			label.text = _routeVO.name;
		}
		
		private function handleClick(e:MouseEvent):void {
			if (_isSelected) {
				_menuManager.printFromMenu();
			}else {
				_menuManager.selectRoute(this);
			}
			
			//if (_isSelected) {
				//gotoAndPlay(REVERT);
				//trace("Do Print! : " + _routeVO.name);
			//}else{
				//gotoAndPlay(SELECT);
				//_isSelected = true;
				//_menuManager.selectRoute(_routeVO);
			//}
		}
		
		public function revert():void {
			if (_isSelected) {
				gotoAndPlay(REVERT);
			}
		}
		
		public function select():void {
			if (!_isSelected) {
				_isSelected = true;
				gotoAndPlay(SELECT);
			}
		}
		
		public function defaultCallback():void {
			_isSelected = false;
			stop();
		}
		public function selectedCallback():void {
			_isSelected = true;
			stop();
		}
		public function overCallback():void {
			//_isSelected = true;
			stop();
		}
		
		public function get routeVO():RouteVO { return _routeVO; }
	}

}