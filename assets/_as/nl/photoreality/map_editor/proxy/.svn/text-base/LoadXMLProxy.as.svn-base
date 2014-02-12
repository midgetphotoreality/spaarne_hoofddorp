package nl.photoreality.map_editor.proxy 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.XMLNode;
	import nl.photoreality.map_editor.constants.EditorConstants;
	import nl.photoreality.map_editor.controller.Controller;
	import nl.photoreality.map_editor.model.vo.FloorVO;
	import nl.photoreality.map_editor.model.vo.IconVO;
	import nl.photoreality.map_editor.model.vo.PanoramaVO;
	import nl.photoreality.map_editor.model.vo.PositionLabelVO;
	import nl.photoreality.map_editor.model.vo.RouteFloorLabelVO;
	import nl.photoreality.map_editor.model.vo.RoutePointVO;
	import nl.photoreality.map_editor.model.vo.RouteVO;
	import nl.photoreality.map_editor.model.vo.SettingsVO;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class LoadXMLProxy
	{
		private var _loader				: URLLoader;
		private var _request			: URLRequest;
		private var _xmlFile			: String;
		private var _xml					: XML;
		private var _controller		: Controller
		private var floors:Vector.<FloorVO>;
		private var icons:Vector.<IconVO>;
		public function LoadXMLProxy(xmlFile:String) {
			trace("XML LOADED: "+xmlFile)
			_xmlFile = xmlFile;
			_request = new URLRequest(_xmlFile);
			_controller = Controller.getInstance();
		}
		
		public function execute():void {
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, handleDone);
			_loader.load(_request);
		}
		
		private function handleDone(e:Event):void {
			_xml 											= new XML(e.target.data);
			floors 			= new Vector.<FloorVO>();
			icons 			= new Vector.<IconVO>();
			var routes: Vector.<RouteVO> 			= new Vector.<RouteVO>();
			var floorIcons: Vector.<IconVO> 		= new Vector.<IconVO>();
			var iconVO	: IconVO;
			var routeVO	: RouteVO;
			var floorVO	: FloorVO;
			var routeLabels			: Vector.<RouteFloorLabelVO>;
			var routeFloorLabelVO	: RouteFloorLabelVO;
			var panoramaVO	: PanoramaVO;
			var routePoints:Vector.<RoutePointVO>;
			var routePoint:RoutePointVO;
			var routeFloors:Vector.<FloorVO>;
			var isBaseFloor: Boolean;
			var floor:XML;
			
			for each (var icon:XML in _xml.icons.icon) {
				icons.push( new IconVO( String(icon.name), String(icon.linkage) ) );
			}
			
			for each (floor in _xml.floors.floor) {
				isBaseFloor 								= false;
				if (floor.@type == "1") {
					isBaseFloor 							= true;
				}
				
				if (isBaseFloor) {
					trace(floor.name + " is a base floor");
				}else {
					trace(floor.name + " is a normal floor");
				}
				
				
				floorIcons		= new Vector.<IconVO>();
				if (int(floor.icons.@total) > 0) {
					for each (var floorIcon:XML in floor.icons.icon) {
						trace(String(floorIcon.@type));
						iconVO = getIcon(String(floorIcon.@type));
						floorIcons.push(new IconVO(iconVO.name, iconVO.linkage, Number(floorIcon.@x), Number(floorIcon.@y), Number(floorIcon.@rotation),String(floorIcon.@id) ) );
					}
				}
				trace("LoadXMLProxy -> handleDone, floorName: " + String(floor.name));
				floors.push( new FloorVO( String(floor.name), String(floor.linkage), isBaseFloor, floorIcons,String(floor.id) ) );
			}
			
			if (_xml.routes.@total != "0") {
				//trace("LoadXMLProxy -> handleDone, found routes");
				for each (var route:XML in _xml.routes.route) {
					//trace("LoadXMLProxy -> handleDone FOR EACH: "+route);
					//trace("LoadXMLProxy -> handleDone FOR EACH, routeName: "+route.name);
					routePoints = new Vector.<RoutePointVO>();
					routeFloors = new Vector.<FloorVO>();
					routeLabels = new Vector.<RouteFloorLabelVO>();
					if (route.floor.@total != "0") {
						for each (floor in route.floors.floor) {
							trace(floor);
							floorVO = getFloorById(floor.@id);
							if ( route.floors.floor.label || route.floors.floor.start || route.floors.floor.end ) {
								//routeFloorLabelVO = new RouteFloorLabelVO(String(floor.label), new PositionLabelVO(String(floor.start), String("position_" + floor.start.@pos)), new PositionLabelVO(String(floor.end), String("position_" + floor.end.@pos)) );
								routeFloorLabelVO = new RouteFloorLabelVO(String(floor.label), new PositionLabelVO(String(floor.start), String("position_" + floor.start.@pos), int(floor.start.@x), int(floor.start.@y)), new PositionLabelVO(String(floor.end), String("position_" + floor.end.@pos), int(floor.end.@x), int(floor.end.@y)) );
								trace ("OJO ---- GOT LABEL VO: "+String(route.name)+" : "+int(floor.start.@x)+" / "+int(floor.start.@y))
							}else {
								routeFloorLabelVO = new RouteFloorLabelVO();
								trace ("OJO ---- EMPTYY!@!!!!!! GOT LABEL VO")
							}
							routeFloors.push(floorVO);
							routeLabels.push(routeFloorLabelVO);
						}
					}
					//trace("LoadXMLProxy -> handleDone, --- found floors: "+routeFloors.length);
					var nrOfPoints : int = 0;
					if (route.points.@total != "0") {
						//trace(route.points)
						for each (var point:XML in route.points.point) {
							nrOfPoints ++;
							trace("LoadXMLProxy -> handleDone, --- found point: "+nrOfPoints);
							//floorVO		= getFloorById(point.floor.@id);
							floorVO		= null;
							iconVO		= null;
							panoramaVO	= null;
							if (point.@icons == "1") {
								iconVO = getIconOfFloorById(point.icon.@id,floorVO);
							}
							if (point.@panoramas == "1") {
								//panoNode = '<panorama xAngleIn="'+_routes[i].points[u].panorama.xAngleIn+'" xAngleOut="'+_routes[i].points[u].panorama.xAngleOut+'" yAngleIn="'+_routes[i].points[u].panorama.yAngleIn+'" yAngleOut="'+_routes[i].points[u].panorama.yAngleOut+'"><name><![CDATA['+_routes[i].points[u].panorama.name+']]></name><linkage><![CDATA['+_routes[i].points[u].panorama.linkage+']]></linkage></panorama>';
								panoramaVO = new PanoramaVO(point.panorama.name, point.panorama.linkage, point.panorama.@angleIn, point.panorama.@angleOut);
							}
							routePoint = new RoutePointVO(point.@id, point.@x, point.@y, point.floor.@id, iconVO, panoramaVO);
							routePoint.angleTransitionIn = Number(point.@angleIn);
							routePoint.angleTransitionOut = Number(point.@angleOut);
							routePoints.push(routePoint);
						}
						trace("LoadXMLProxy -> handleDone, --- found points: "+routePoints.length);
					}
					
					//trace("LoadXMLProxy -> handleDone, routeName: " + String(route.name));
					routeVO = new RouteVO(route.name, routePoints, routeFloors,routeLabels);
					routes.push(routeVO);
				}
			}
			
			var settings:SettingsVO =  new SettingsVO(String(_xml.settings.version));
			settings.lineThickness = uint(_xml.settings.lineThickness);
			settings.lineColor = uint(_xml.settings.lineColor);
			//trace("LoadXMLProxy -> handleDone, routes: "+routes.length)
			_controller.loadXMLDone(settings,icons, floors, routes);// , uint(_xml.route_line.color), Number(_xml.route_line.thickness));
		}
		
		private function getIcon(type:String):IconVO {
			for (var i:int = 0; i < icons.length; i++) {
				if (icons[i].name == type) {
					return IconVO( icons[i] );
				}
			}
			trace("LoadXMLProxy -> getIcon -> FAILED IconVO provided!!!");
			return (new IconVO("fail","fail"));
		}
		
		private function getIconOfFloorById(id:String,floorVO:FloorVO):IconVO {
			for (var i:int = 0; i < floorVO.icons.length; i++) {
				if (floorVO.icons[i].id == id) {
					return IconVO( floorVO.icons[i] );
				}
			}
			trace("LoadXMLProxy -> getIconOfFloorById -> FAILED IconVO provided!!!");
			return (new IconVO("fail","fail"));
		}
		
		private function getFloorById(id:String):FloorVO {
			for (var i:int = 0; i < floors.length; i++) {
				if (floors[i].id == id) {
					return FloorVO( floors[i] );
				}
			}
			trace("LoadXMLProxy -> getFloorById -> FAILED FloorVO provided!!!");
			return (new FloorVO("fail", "fail", false, new Vector.<IconVO>));
		}
		
	}
}