SHoofddorp = {};
SHoofddorp.view = {};
SHoofddorp.Setup = (function () {

	var _level = {
		content: Core.display.Level("content", "levelContent"),
		menu: Core.display.Level("menu", "levelMenu"),
		overlay: Core.display.Level("overlay", "levelOverlay")
	}

	var _content = {
		Home: Core.display.Asset("Home", "NORMAL", {
			preload: true,
			level: _level.content,
			html: "assets/html/Home.html",
			js: "assets/js/Home.js",
			css: "assets/css/Home.css"
		}),
		Area: Core.display.Asset("About", "NORMAL", {
			preload: true,
			level: _level.content,
			html: "assets/html/About.html",
			js: "assets/js/About.js",
			css: "assets/css/About.css"
		}),
		/*Print: Core.display.Asset("Contact","NORMAL",{
			preload:	true,
			level:		_level.overlay,
			html:		"assets/html/Contact.html",
			js:			"assets/js/Contact.js",
			css:		"assets/css/Contact.css"
		}),
		Overzichtsplattegrond: Core.display.Asset("Overzichtsplattegrond", "NORMAL", {
			preload: true,
			level: _level.overlay,
			html: "assets/html/Overzichtsplattegrond.html",
			js: "assets/js/Overzichtsplattegrond.js",
			css: "assets/css/Overzichtsplattegrond.css"
		})
		*/
	}

	return {
		level: _level,
		content: _content
	}
})();

SHoofddorp.Menu = (function () {
	var _filterOut = false;
	if(filterOutMeta){
		_filterOut = filterOutMeta;
	}
	
	var _selectedRoute = false;
	var _currentMenu = false;

	var _alphabetLetters = String("ABCDEFGHIJKLMNOPQRSTUVWXYZ").split("");
	var _menus = {};

	var _menuDiv = false;
	var openLetter = false;
	var _selectedRouteName = "";
	var _menuHeight = 0;
	var _choice = 'south';

	var _selectedMenuElement = false;
	var _clickedMenuElement = false;

	var _selectedRouteIndex = false;

	var _initMenu = function (routes) {

		_currentMenu = routes;
	}

	var _formatName = function (str) {
		if (String(str).lastIndexOf("_") > -1) {
			str = String(str).substr(0, String(str).lastIndexOf("_"));
		}
		return str;
	}

	var _curHash = "",
		prevHash = false;

	var openLetterMenu = function (letter) {
		//console.log(letter);
		if (openLetter) {
			openLetter.container.style.display = "none";
			openLetter.container.style.width = "1px";
			openLetter.container.style.height = "1px";
			Core.dom.removeClass(openLetter.letter, "menuItemSelected");
			Core.dom.addClass(openLetter.letter, "menuItemDeSelected");
			//openLetter = _menus[letter].menu.container;
		}
		openLetter = _menus[letter];
		openLetter.container.style.display = "block";
		openLetter.container.style.width = null;
		openLetter.container.style.height = null;
		
		Core.dom.removeClass(openLetter.letter, "menuItemDeSelected");
		Core.dom.addClass(openLetter.letter, "menuItemSelected");

		if (openLetter.container.getBoundingClientRect().bottom  > _menuHeight) {
			openLetter.container.style.top = String(parseInt(openLetter.container.style.top.replace("px",""))+(_menuHeight - (openLetter.container.getBoundingClientRect().bottom))+"px");
		}

		if (openLetter.container.getBoundingClientRect().top  < 0 ) {
			openLetter.container.style.top =  "0px";
		}

		
	}

	var getCleanName = function (str) {
		var prevVal = "";
		while (prevVal != str) {
			prevVal = str;
			str = String(str).replace(" ", "_");
		}
		while (prevVal != str) {
			prevVal = str;
			str = String(str).replace("%20", "_");
		}
		return str;
	}
	
	

	var _startRoute = function (starts) {
		llog("_startRoute: "+starts)
		for (var i = 0; i < _currentMenu.length; i++) {
			if (starts && starts == _currentMenu[i].cleanName) { //(decodeURIComponent(starts) == decodeURIComponent(_currentMenu[i].name))) {
				openLetterMenu(_currentMenu[i].name.substr(0, 1).toUpperCase());
				selectRoute(i);
			}
		}
	}
	
	

	var selectRoute = function (index) {
	
		Core.debug.log("SHoofddorp.Menu._selectRoute(" + index + ")");
	
		_selectedRouteIndex = index;
		
		//console.log(index+" pre choice: "+_choice);
		_choice = "north";
		if(index%2!=0){
			_choice = "south";
			_selectedRouteIndex = index-1;
		}
		
		//console.log(index+" after choice: "+_choice);
		function getLabelName(name){
			return name.substr(0,name.length-4);
		}
		_selectedRoute = _currentMenu[index];
		_selectedRouteName = _formatName(_currentMenu[index].name);
		
		var f1 = HOSPITALS.Controller.getFLoorById(_selectedRoute.floors[0].id);
		var f2 = HOSPITALS.Controller.getFLoorById(_selectedRoute.floors[1].id);
		
		document.getElementById('infoPrintAfdelingsnaam').innerHTML = getLabelName( _selectedRouteName);
		
		document.getElementById('printDesc').innerHTML =getLabelName( _selectedRouteName);
		Core.dom.addClass(document.getElementById('infoSouthLabels'),"hidden");
		Core.dom.addClass(document.getElementById('infoNorthLabels'),"hidden");
		if(_choice == "north"){
			Core.dom.addClass(document.getElementById('maps'),"mapsNoffset");
			document.getElementById('imgSouth').src = "images/draaiknopzuidzwart.png";
			document.getElementById('imgNorth').src = "images/draaiknopnoordwit.png";	
			Core.dom.removeClass(document.getElementById('infoSouthLabels'),"hidden");
		}else{
			Core.dom.removeClass(document.getElementById('maps'),"mapsNoffset");
			document.getElementById('imgSouth').src = "images/draaiknopzuidwit.png";
			document.getElementById('imgNorth').src = "images/draaiknopnoordzwart.png";
			Core.dom.removeClass(document.getElementById('infoNorthLabels'),"hidden");
		}
		
		document.getElementById('labelMap1').innerHTML = "<b>"+_cleanFloorName(f1.name)+"</b>:"
		
		document.getElementById('instructionMap1').innerHTML = _selectedRoute.floors[0].label;
		
		document.getElementById('labelMap2').innerHTML = "";
		document.getElementById('instructionMap2').innerHTML = "";
		if (_selectedRoute.floors[0].id != _selectedRoute.floors[1].id) {
			document.getElementById('labelMap2').innerHTML = "<b>"+_cleanFloorName(f2.name)+"</b>:" 
			document.getElementById('instructionMap2').innerHTML = _selectedRoute.floors[1].label;
		}

		document.getElementById('topLabel').innerHTML = "route naar " + _selectedRouteName
		HOSPITALS.MapsContainer.selectRoute(_selectedRoute);

	}

	var _buildDesktopMenu = function () {
		try {
			document.getElementById("Core31415926535897932384626433832preload").innerHTML = "";
		} catch (e) {

		}

		if (("onhashchange" in window)) { // && !($.browser.msie)) { only for oldy ies
			window.onhashchange = function () {
				_startRoute(window.location.hash.replace("#", ""));
			}
		} else {
			var prevHash = window.location.hash;
			window.setInterval(function () {
				if (window.location.hash != _curHash) {
					_curHash = window.location.hash;
					_startRoute(window.location.hash.replace("#", ""));
				}
			}, 100);
		}

		var startRoute = false;

		var starts = window.location.hash.replace("#", "");
		if (starts == "") {
			starts = false;
		}

		var snippet = function (str) {
			return '<div class="menuItem">' +
				'<div class="menuItemLetter menuItemDeSelected" id="menuItemLetter' + str + '">' + str + '</div>' +
				'<div class="menuItemContainer" id="menuItemContainer' + str + '"></div>' +
				'</div>';
		}

		_menuDiv = document.getElementById('menuContainer');

		

		var routeLetter, i, div, container;

		

		for (i = 0; i < _alphabetLetters.length; i++) {
			routeLetter = _alphabetLetters[i];
			
			
			div = document.createElement('div');
			div.innerHTML = snippet(routeLetter);
			div.id = 'menuItem' + routeLetter;
			_menuDiv.appendChild(div);
			
			
			
			div.style.top = String((i * 30) + "px");
			container = document.getElementById("menuItemContainer" + routeLetter);
			_menus[_alphabetLetters[i]] = {
				"div": div,
				"id": routeLetter,
				"container": container,
				"items": [],
				"letter":document.getElementById("menuItemLetter" + routeLetter)
			}

			// TODO: fix container

			div.style.top = String((i * 30) + "px");
			container.style.top = String((i * 30) + "px");
			_menuHeight = (i * 30) + 30;
			Core.dom.addClass(container, "menutItemContainer");


			div.onclick = function () {
				openLetterMenu(String(this.id).substr(8, 1));
			}
			div.onmouseover = function () {
				openLetterMenu(String(this.id).substr(8, 1));
			}
			div.onmouseout = function () {
				////console.log(this);
			}
		}

		var _filters = [" - Z"," - N"];
		var _menuNoord = document.createElement('div');
		var _menuZuid = document.createElement('div');
		
		function getLabelName(name){
			return name.substr(0,name.length-4);
		}
		
		function getLabelType(name){
			return name.substr(name.length-4);
		}
		
		for (i = 0; i < _currentMenu.length; i++) {
			routeLetter = _currentMenu[i].name.substr(0, 1).toUpperCase();
			if (_menus[routeLetter]) {
				
				if(_filterOut && _currentMenu[i].meta1 != "intra"){
					
					if(i%2==1){
					
						
						
						div = document.createElement('div');
						div.innerHTML = getLabelName(_currentMenu[i].name);
						
						//console.log(i+": "+getLabelType(_currentMenu[i].name));
						
						Core.dom.addClass(div, "menuRouteItem");
						_menus[routeLetter].container.appendChild(div);
						_menus[routeLetter].items.push({
							"id": i,
							"div": div
						});
						div.id = "menuRouteItem" + i;
						div.onclick = function () {
							//console.log(this.id+" "+_choice);
							//console.log((parseInt(String(this.id).substr(13))-1)+": "+_currentMenu[parseInt(String(this.id).substr(13))-1].cleanName);
							//console.log((parseInt(String(this.id).substr(13)))+": "+_currentMenu[parseInt(String(this.id).substr(13))].cleanName);
							//console.log((parseInt(String(this.id).substr(13))+1)+": "+_currentMenu[parseInt(String(this.id).substr(13))+1].cleanName);
							
							if(_choice == 'south'){
								//console.log("south: "+(parseInt(String(this.id).substr(13))+1));
								window.location.hash = _currentMenu[parseInt(String(this.id).substr(13))].cleanName;
							}else{
								//console.log("north: "+(parseInt(String(this.id).substr(13))));
								window.location.hash = _currentMenu[parseInt(String(this.id).substr(13))-1].cleanName;
							}
						}
						
					}
					
					_currentMenu[i].cleanName = getCleanName(_currentMenu[i].name);
					_currentMenu[i].routeIndex = i;
					
					if(_currentMenu[i].cleanName == starts){
						
						openLetterMenu(routeLetter);
						_startRoute(starts);
					}
					
				
				}else{
				//	console.log("Filtering out: "+_currentMenu[i].name);
				}
			} else {
				//console.log("Unknow letter: " + routeLetter);
			}
		}
	}
	
	var _setRouteChoice = function(choice){
		_choice = choice;
		if(_selectedRouteIndex || _selectedRouteIndex == 0){
			if(_choice == 'south'){
				//console.log("south: "+(parseInt(String(this.id).substr(13))+1));
				window.location.hash = _currentMenu[_selectedRouteIndex+1].cleanName;
			}else{
				//console.log("north: "+(parseInt(String(this.id).substr(13))));
				window.location.hash = _currentMenu[_selectedRouteIndex].cleanName;
			}
		}
		// select current!!
	}
	
	var _cleanFloorName = function(name){
		llog(name);
		if(name.indexOf("- Noord")>=0){
			name = name.replace("- Noord","");
		}
		
		if(name.indexOf("- Zuid")>=0){
			name = name.replace("- Zuid","");
		}
		
		return name;
	}

	var _public = {
		initMenu: function (routes) {
			_initMenu(routes)
		},
		initDesktopMenu: function () {
			_initDesktopMenu();
		},
		buildDesktopMenu: function () {
			_buildDesktopMenu()
		},
		initialButtonOnMouseOver: function () {
			_initialButtonOnMouseOver();
		},

		selectedTransportation: function () {
			return _selectedTransportation
		},
		selectRoute: function (index) {
			_selectRoute(index)
		},
		setRouteChoice: function(choice){
			_setRouteChoice(choice);
		},
		selectNorth: function () {
			//console.log("n");
			document.getElementById('imgSouth').src = "images/draaiknopzuidzwart.png"
			document.getElementById('imgNorth').src = "images/draaiknopnoordwit.png"
			SHoofddorp.Menu.setRouteChoice('north');
		},
		selectSouth: function () {
			document.getElementById('imgSouth').src = "images/draaiknopzuidwit.png"
			document.getElementById('imgNorth').src = "images/draaiknopnoordzwart.png"
			SHoofddorp.Menu.setRouteChoice('south');
		}
		
		
	}
	return _public;

})();

SHoofddorp.SiteManager = (function () {

	var _init = function () {
		////console.log("SHoofddorp.SiteManager INIT")
		// Preloader
		// CanvasLoader
		var cl = new CanvasLoader('preloaderSpinner');
		cl.setColor('#008fd0'); // default is '#000000'
		cl.setShape('spiral'); // default is 'oval'
		cl.setDiameter(35); // default is 40
		cl.setDensity(16); // default is 40
		cl.setRange(1.1); // default is 1.3
		cl.setSpeed(1); // default is 2
		cl.setFPS(25); // default is 24
		cl.show(); // Hidden by default
		var loaderObj = document.getElementById("canvasLoader");
		loaderObj.style.position = "absolute";
		loaderObj.style["top"] = cl.getDiameter() * -0.5 + "px";
		loaderObj.style["left"] = cl.getDiameter() * -0.5 + "px";

		//TweenLite.from(document.getElementById("logo"), 0.5, {css:{autoAlpha:0, right:"0px"}});
		HOSPITALS.MapsContainer.init();

		HOSPITALS.Controller.setFloorWidth(550);
		
		HOSPITALS.Controller.loadJSON(function () {
			document.getElementById('versionText').innerHTML = HOSPITALS.Model.settings().version;
			SHoofddorp.Menu.initMenu(HOSPITALS.Model.routes())
			////console.log("SHoofddorp.SiteManager -> Loading Floors")
			HOSPITALS.Controller.loadFloors(function () {
				//SHoofddorp.Menu.initMenu(HOSPITALS.Model.routes())
				Core.debug.info("Floors Loaded");
				
				_initComplete();
			})
		});


	}




	var _initComplete = function () {
		//	
		var preloader = document.getElementById("preloaderSpinner");
		document.getElementById('application').removeChild(preloader);
		//document.getElementById('Core31415926535897932384626433832preload').innerHTML="";
				Core.managers.NavigationManager.showAsset(SHoofddorp.Setup.content.Home);
		
		
		//Core.managers.NavigationManager.showAsset(SHoofddorp.Setup.content.Menu);

		//alert("SHoofddorp.SiteManager -> _initComplete ")
	}

	var _public = {
		init: function () {
			_init()
		}
	}
	return _public;
})();

//SHoofddorp.SiteManager.init();




SHoofddorp.AnimationManager = (function () {

	var _genContentInit = function (div) {
		TweenLite.set(div, {
			css: {
				autoAlpha: 0
			}
		});
	}

	var _genContentShow = function (div) {
		TweenLite.to(div, 0.5, {
			css: {
				autoAlpha: 1
			}
		});
	}

	var _genContentHide = function (div, callback) {
		TweenLite.to(div, 0.5, {
			css: {
				autoAlpha: 0
			},
			onComplete: callback
		});
	}

	var _public = {
		genContentHide: _genContentHide,
		genContentInit: _genContentInit,
		genContentShow: _genContentShow
	}
	return _public;
})();

Core.dom.addLoadEvent(function () {
	SHoofddorp.SiteManager.init();
});

function llog(msg){
	console.log(msg);
}
	