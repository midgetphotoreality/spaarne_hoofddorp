SHoofddorp.view.Home = (function() {
	var _divAsset;


	/*__FUNCTIONS_____________________________________________________________________________________________________*/

	/*__CORE_FUNCTIONS________________________________________________________________________________________________*/
	var _init = function() {
		Core.debug.log("SHoofddorp.view.Home -> _init()");
		console.log("HOME");
		Core.managers.NavigationManager.showAsset(SHoofddorp.Setup.content.Menu);
		_divAsset = document.getElementById("Home");
		SHoofddorp.AnimationManager.genContentInit(_divAsset);
		var f1 =  HOSPITALS.Controller.getFLoorById("fl5a09086faa86ba6d507c8721aca6f1b265b3e41262d2a6bb4c668e2067e8b51c");

		
		
		document.getElementById('map1').style.top = parseInt(document.getElementById('floor1Text').offsetHeight)+10+"px" ;
		Core.dom.addClass(document.getElementById('floor2Text'),"hidden");
		document.getElementById('mobileFooter').style.top = (60+Math.ceil( f1.floorHeight ))+"px";
		
		document.getElementById('versionText').style.top = (parseInt(document.getElementById('mobileFooter').style.top)+180)+"px";
		
		//document.getElementById('mobileFooter').style.top = (60+Math.ceil( f1.floorHeight ))+"px";
		SHoofddorp.Menu.initMenu(HOSPITALS.Model.routes())
		
		document.getElementById('versionText').innerHTML = HOSPITALS.Model.settings().version;
		
		HOSPITALS.MapsContainer.init();
	}

	var _show = function() {
		Core.debug.log("SHoofddorp.view.Home1 -> _show()");
		SHoofddorp.AnimationManager.genContentShow(_divAsset);
	}

	var _hide = function(callback) {
		Core.debug.log("SHoofddorp.view.Home1 -> _hide()");
		SHoofddorp.AnimationManager.genContentHide(_divAsset, callback);
	}

	var _remove = function() {
		Core.debug.log("SHoofddorp.view.Home1 -> _remove()");
		SHoofddorp.Setup.content.Home.removeView(SHoofddorp.view.Home);
		_divAsset = null;
	}


	/*__PUBLIC_FUNCTIONS______________________________________________________________________________________________*/
	var _public = {
		init: function() { _init(); },
		show: function() { _show(); },
		hide: function(callback) { _hide(callback); },
		remove: function() { _remove(); }
	}
	return _public;
})();
SHoofddorp.Setup.content.Home.addView(SHoofddorp.view.Home);