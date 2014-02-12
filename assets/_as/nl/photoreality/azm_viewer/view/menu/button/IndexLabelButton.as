// nl.photoreality.online_viewer.view.menu.button.IndexLabelButton
package nl.photoreality.azm_viewer.view.menu.button 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import nl.photoreality.map_editor.model.vo.RouteVO;
	import nl.photoreality.azm_viewer.manager.MenuManager;
	import nl.photoreality.azm_viewer.view.menu.Menu;
	import nl.photoreality.utils.display.Provider;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class IndexLabelButton extends MovieClip//extends Provider
	{
		private var _departments			: Vector.<RouteVO>;
		private var _departmentButtons		: Vector.<DepartmentLabelButton>
		public var departmentContainer		: MovieClip;
		public var overstate_mc				: MovieClip;
		public var hitter_mc				: MovieClip;
		public var label					: TextField;
		private var _inited					: Boolean = false;
		private var _manager				: MenuManager;
		private var _postFixPatternToExclude:String;
		
		public function IndexLabelButton() {
			////trace("IndexLabelButton -> constructor")
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			_manager = MenuManager.getInstance();
			
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
			_manager.addEventListener(MenuManager.MENU_ITEM_CLICKED, handleGlobalIndexClick);
		}
		
		private function removeListeners():void {
			_manager.removeEventListener(MenuManager.MENU_ITEM_CLICKED, handleGlobalIndexClick);
			if (_inited) {
				//hitter_mc.removeEventListener(MouseEvent.CLICK, handleClick);
				hitter_mc.removeEventListener(MouseEvent.ROLL_OVER, handleClick);
			}
		}
		
		private function handleClick(e:MouseEvent):void {
			trace("IndexLabelButton -> handleClick "+name+":"+departmentContainer.x+"/"+departmentContainer.y)
			_manager.selectIndex();
			overstate_mc.alpha = 1;
			departmentContainer.visible = true;
		}
		
		private function handleGlobalIndexClick(e:Event):void {
			//trace("IndexLabelButton -> handleGlobalIndexClick")
			overstate_mc.alpha = 0;
			//revertAllButtons();
			departmentContainer.visible = false;
		}
		
		public function init(lblStr:String, departments:Vector.<RouteVO>,postFixPatternToExclude:String=""):void {
			_postFixPatternToExclude = postFixPatternToExclude;
			trace("IndexLabelButton: "+departments)
			//trace("IndexLabelButton -> init")
			_departments 				= departments;
			if (_postFixPatternToExclude != "") {
				var newDepartments:Vector.<RouteVO> = new Vector.<RouteVO>();
				for (var i:int = 0; i < departments.length; i++) {
					//1: _2 == _2
					trace(i+":"+departments[i].name.substr( -2)+":==:"+_postFixPatternToExclude+":");
					if (departments[i].name.substr( -2) == _postFixPatternToExclude) {
						trace(i + " == HIT")
					//	departments[i].name = departments[i].name.substr(0, -2)
						newDepartments.push(departments[i]);
					}
				}
				_departments  = newDepartments;
			}
			
			
			label.text 					= lblStr;
			hitter_mc.useHandCursor 	= hitter_mc.buttonMode = true;
			//hitter_mc.addEventListener(MouseEvent.CLICK, handleClick);
			hitter_mc.addEventListener(MouseEvent.ROLL_OVER, handleClick);
			departmentContainer.visible = false;
			overstate_mc.alpha 			= 0;
			overstate_mc.label.text = lblStr;
			buildDepartments();
			_inited 					= true;
		}
		
		public function revertAllButtons():void {
			//trace("IndexLabelButton -> revertAllButtons: "+_departmentButtons.length);
			var departmentButton:DepartmentLabelButton;
			for (var i:int = 0; i < _departmentButtons.length; i++) {
				departmentButton = _departmentButtons[i];
				//trace("revertAllButtons, i : "+i+" / "+departmentButton.name);
				departmentButton.revert();
			}
		}
		
		
		
		private function buildDepartments():void {
			//trace("A: "+label.text);
			_departmentButtons = new Vector.<DepartmentLabelButton>();
			//trace("A");
			var departmentButton:DepartmentLabelButton;
			//trace("A");
			
			
			
			for (var i:int = 0; i < _departments.length; i++) {
				trace(i+" buildDepartments")
				trace(i + " A:"+Menu.DEPARTMENT_BUTTON_LINKAGE+":");
				
				departmentButton = DepartmentLabelButton(provideMc(Menu.DEPARTMENT_BUTTON_LINKAGE));
				//trace(i+" A");
				departmentButton.init( RouteVO(_departments[i]),_postFixPatternToExclude );
				//trace(i+" A");
				departmentButton.x = 0;
				//trace(i+" A");
				departmentButton.y = i * 20;
				;
				departmentContainer.addChild(departmentButton);
				//trace(i+" A");
				_departmentButtons.push(departmentButton);
				//trace(i+" A");
			}
			//trace(" B: "+label.text+" / "+this.x+","+this.y+", stage: "+stage);
			var thisPosition:Point = stage.localToGlobal(new Point(this.x, this.y));
			//trace(" B");
			//trace(thisPosition.y + departmentContainer.height + " > " + stage.stageHeight);
			if (thisPosition.y + departmentContainer.height > stage.stageHeight) {
				//trace(" RePOS");
				departmentContainer.y = - departmentContainer.height + (stage.stageHeight - thisPosition.y);
			}
		}
		private function provideMc(linkage:String):DisplayObject {
			var tCL:Class = getDefinitionByName(linkage) as Class;
			var tMC:DisplayObject = new tCL() as DisplayObject;
			return(tMC);
		}
	}

}