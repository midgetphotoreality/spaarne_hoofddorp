package nl.photoreality.map_editor.proxy 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import nl.photoreality.map_editor.constants.EditorConstants;
	import nl.photoreality.map_editor.controller.FloorController;
	import nl.photoreality.map_editor.model.vo.FloorVO;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class LoadFloorsProxy
	{
		private var _loader				: URLLoader;
		private var _request			: URLRequest;
		private var _xmlFile			: String;
		private var _xml					: XML;
		private var _floorController	: FloorController
		public function LoadFloorsProxy(xmlFile:String) {
			_xmlFile = xmlFile;
			_request = new URLRequest(_xmlFile);
			_floorController = FloorController.getInstance();
		}
		
		public function execute():void {
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, handleDone);
			_loader.load(_request);
		}
		
		private function handleDone(e:Event):void {
			_xml 						= new XML(e.target.data);
			var floors: Vector.<FloorVO> 		= new Vector.<FloorVO>();
			var isBaseFloor: Boolean
			for each (var floor:XML in _xml.floor) {
				isBaseFloor 			= false;
				if (floor.@isBaseFloor == "1") {
					isBaseFloor 		= true;
				}
				floors.push( new FloorVO(String(floor.name), String(floor.linkage), isBaseFloor, new Array() ) );
			}
			_floorController.loadFloorsDone(floors);
		}
		
	}
}