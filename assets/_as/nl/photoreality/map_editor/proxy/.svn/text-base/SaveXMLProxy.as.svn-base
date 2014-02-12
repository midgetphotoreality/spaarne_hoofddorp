package nl.photoreality.map_editor.proxy 
{
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import nl.photoreality.map_editor.constants.EditorConstants;
	import nl.photoreality.map_editor.model.vo.FloorVO;
	import nl.photoreality.map_editor.model.vo.IconVO;
	import nl.photoreality.map_editor.model.vo.RouteVO;
	import nl.photoreality.map_editor.model.vo.SettingsVO;
	import nl.photoreality.utils.debug.Debug;
	public class SaveXMLProxy
	{
		private var _xmlDoc						: XMLDocument;
		private var _floors							: Vector.<FloorVO>;
		private var _icons							: Vector.<IconVO>;
		private var _xmlString						: String;
		private var _xml								: XML;
		private var _xmlByteArray				: ByteArray;
		
		private var _file								: FileReference;
		private var _routes:Vector.<RouteVO>;
		private var _settings:SettingsVO;
		
		public function SaveXMLProxy(settings:SettingsVO,icons:Vector.<IconVO>, floors:Vector.<FloorVO>, routes:Vector.<RouteVO>) {
			_settings = settings;
			_routes = routes;
			_icons 											= icons;
			_floors 										= floors;
			_xmlDoc											= new XMLDocument;
			_xml											= new XML();
			init();
		}
		
		private function init():void {
			var isBaseFloor			: int = 0;
			var i					: int = 0;
			var u					: int = 0;
			_xmlString				= '<?xml version="1.0" encoding="utf-8" ?><project>';
			_xmlString 				+= '<settings>';
			_xmlString 				+= '<version><![CDATA['+_settings.version+']]></version>';
			_xmlString 				+= '<lineColor><![CDATA['+_settings.lineColor+']]></lineColor>';
			_xmlString 				+= '<lineThickness><![CDATA['+_settings.lineThickness+']]></lineThickness>';
			_xmlString 				+= '</settings>';
			if (_icons.length == 0) {
				_xmlString			+= '<icons total="0"/>';
			}else{
				_xmlString			+= '<icons total="'+String(_icons.length)+'">';
				for (i = 0; i < _icons.length; i++) {
					_xmlString		+= '<icon type="'+_icons[i].name+'">';
					_xmlString		+= '<name><![CDATA['+_icons[i].name+']]></name>';
					_xmlString		+= '<linkage><![CDATA['+_icons[i].linkage+']]></linkage>';
					_xmlString		+= '</icon>';
				}
				_xmlString			+= '</icons>';
			}
			if (_floors.length == 0) {
				_xmlString			+= '<floors total="0"/>';
			}else {
				_xmlString			+= '<floors total="' + String(_floors.length) + '">';
				//
				for (i = 0; i < _floors.length; i++) {
					isBaseFloor		= 0;
					if (_floors[i].isBaseFloor) {
						isBaseFloor	= 1;
					}
					_xmlString		+= '<floor type="'+String(isBaseFloor)+'" x="0" y="0" rotation="0">';
					_xmlString		+= '<id><![CDATA['+_floors[i].id+']]></id>';
					_xmlString		+= '<name><![CDATA['+_floors[i].name+']]></name>';
					_xmlString		+= '<linkage><![CDATA[' + _floors[i].linkage + ']]></linkage>';
					if (_floors[i].icons.length == 0) {
						_xmlString 	+= '<icons total="0"/>';
					}else {
						_xmlString += '<icons total="'+String(_floors[i].icons.length)+'">';
						for (u = 0; u < _floors[i].icons.length; u++) {
							_xmlString += '<icon type="'+_floors[i].icons[u].name+'" x="'+_floors[i].icons[u].x+'" y="'+_floors[i].icons[u].y+'" rotation="'+_floors[i].icons[u].rotation+'" id="'+_floors[i].icons[u].id+'"/>';
						}
						_xmlString += '</icons>';
					}
					
					_xmlString		+= '</floor>';
				}
				_xmlString			+= '</floors>';
			}
			
			var iconStr:String = "";
			var panoStr:String = "";
			var iconNode:String = "";
			var panoNode:String = "";
			
			if (_routes.length == 0) {
				_xmlString			+= '<routes total="0"/>';
			}else {
				_xmlString			+= '<routes total="'+_routes.length+'">';
				for (i = 0; i < _routes.length; i++) {
					_xmlString		+= '<route>';
					_xmlString		+= '<name><![CDATA[' + _routes[i].name + ']]></name>';
					if (_routes[i].floors.length == 0 ) {
						_xmlString		+= '<floors total="0"/>';
					}else {
						_xmlString		+= '<floors total="'+String(_routes[i].floors.length)+'">';
						for (u = 0; u < _routes[i].floors.length; u++) {
							_xmlString		+= '<floor id="' + _routes[i].floors[u].id + '">';
							Debug.log("SaveXMLProxy -> init() route"+i+", floor"+u+" label :"+_routes[i].labels[u].label+":"+_routes[i].labels.length, true);
							_xmlString		+= '<label><![CDATA[' + _routes[i].labels[u].label + ']]></label>';
							trace(String(_routes[i].labels[u].startLabel.position));// .substr(9));
							trace(String(_routes[i].labels[u].endLabel.position));// .substr(9));
							//_xmlString		+= '<start pos="'+String(_routes[i].labels[u].startLabel.position).substr(9)+'" x="'+String(_routes[i].labels[u].endLabel.offsetX)+'" y="'+String(_routes[i].labels[u].endLabel.offsetY)+'"><![CDATA['+_routes[i].labels[u].startLabel.label+']]></start>';
							//_xmlString		+= '<end pos="'+String(_routes[i].labels[u].endLabel.position).substr(9)+'"><![CDATA['+_routes[i].labels[u].endLabel.label+']]></end>';
							
							_xmlString		+= '<start pos="'+String(_routes[i].labels[u].startLabel.position).substr(9)+'" x="'+String(_routes[i].labels[u].startLabel.offsetX)+'" y="'+String(_routes[i].labels[u].startLabel.offsetY)+'"><![CDATA['+_routes[i].labels[u].startLabel.label+']]></start>';
							_xmlString		+= '<end pos="'+String(_routes[i].labels[u].endLabel.position).substr(9)+'" x="'+String(_routes[i].labels[u].endLabel.offsetX)+'" y="'+String(_routes[i].labels[u].endLabel.offsetY)+'"><![CDATA['+_routes[i].labels[u].endLabel.label+']]></end>';
							
							
							//_xmlString		+= '<start pos="'+String(_routes[i].labels[u].startLabel.position).substr(9)+'"><![CDATA['+_routes[i].labels[u].startLabel.label+']]></start>';
							//_xmlString		+= '<end pos="'+String(_routes[i].labels[u].endLabel.position).substr(9)+'"><![CDATA['+_routes[i].labels[u].endLabel.label+']]></end>';
							_xmlString		+= '</floor>';
						}
						_xmlString		+= '</floors>';
					}
					if (_routes[i].points.length == 0 ) {
							_xmlString		+= '<points total="0"/>';
					}else {
						_xmlString		+= '<points total="' + _routes[i].points.length + '">';
						for (u = 0; u < _routes[i].points.length; u++) {
							// loop through points
							iconStr = ' icons="0"';
							panoStr = ' panoramas="0"';
							iconNode = '';
							panoNode = '';
							if (_routes[i].points[u].icon) {
								iconStr = ' icons="1"';
								iconNode = '<icon id="' + _routes[i].points[u].icon.id + '"/>';
							}
							if (_routes[i].points[u].panorama) {
								panoStr = ' panoramas="1"';
								panoNode = '<panorama angleIn="'+_routes[i].points[u].panorama.angleTransitionIn+'" angleOut="'+_routes[i].points[u].panorama.angleTransitionOut+'"><name><![CDATA['+_routes[i].points[u].panorama.name+']]></name><linkage><![CDATA['+_routes[i].points[u].panorama.linkage+']]></linkage></panorama>';
							}
							_xmlString		+= '<point id="'+u+'" x="' + _routes[i].points[u].x + '" y="' + _routes[i].points[u].y + '" angleIn="'+_routes[i].points[u].angleTransitionIn+'" angleOut="'+_routes[i].points[u].angleTransitionOut+'"' + iconStr + '' + panoStr + '>';
							_xmlString		+= '<floor id="' + _routes[i].points[u].floorId + '"/>';
							_xmlString		+= iconNode;
							_xmlString		+= panoNode;
							_xmlString		+= '</point>';
							
						}
						_xmlString		+= '</points>';
					}
					_xmlString		+= '</route>';
				}
				_xmlString			+= '</routes>';
			}
			_xmlString				+= '</project>';
			_xml							= new XML(_xmlString);
			//trace("SaveXMLProxy -> init");
			//trace("---------------------------------");
			//trace(_xml);
			//trace("---------------------------------");
			
			
			_file 							= new FileReference();
			//	_xmlByteArray 			= new ByteArray();
			//	_xmlByteArray.writeUTFBytes(_xml);
			
			
			
			// /*
			_file.addEventListener(Event.SELECT, handleSelect);
			_file.addEventListener(Event.CANCEL, handleCancel);
			_file.save(_xml,"application.xml");
			// */
		}
		
		private function handleCancel(e:Event):void {
			trace("SaveXMLProxy -> handleCancel");
		}
		
		private function handleSelect(e:Event):void {
			trace("SaveXMLProxy -> handleSelect");
		}
		
	}
	/*
	XmlDocument xmlDoc = new XmlDocument();
 
	//Adding the parent <Books> Element
	XmlElement booksElement = xmlDoc.CreateElement("Books");
	 
	//Adding the <Book> Element
	XmlElement bookElement = xmlDoc.CreateElement("Book");
	booksElement.AppendChild(bookElement);
	 
	// Adding <title> and Setting Value
	XmlElement titleElement = xmlDoc.CreateElement("title");
	titleElement.InnerText = "Great Gatsby";
	bookElement.AppendChild(titleElement);
	 
	// Adding <author> and Setting Value
	XmlElement authorElement = xmlDoc.CreateElement("author");
	authorElement.InnerText = "F. Scott Fitzgerald";
	bookElement.AppendChild(authorElement);
	 
	// Creating Attribute and assigning it to <Book>
	XmlAttribute bookAttribute = xmlDoc.CreateAttribute("ISBN");
	bookElement.SetAttributeNode(bookAttribute);
	bookAttribute.Value = "0553212419";
	 
	// Adding root element and saving file to disk
	xmlDoc.AppendChild(booksElement);
	xmlDoc.Save(@"C:\Users\Kirupa\Desktop\books.xml");
	*/

}