SHoofddorp.view.Home = (function() {
	var _divAsset;


	/*__FUNCTIONS_____________________________________________________________________________________________________*/

	/*__CORE_FUNCTIONS________________________________________________________________________________________________*/
	var _init = function() {
		Core.debug.log("SHoofddorp.view.Home -> _init()");
		_divAsset = document.getElementById("Home");
		SHoofddorp.AnimationManager.genContentInit(_divAsset);
		
		HOSPITALS.MapsContainer.init();

		SHoofddorp.Menu.buildDesktopMenu();

		document.getElementById('print').onclick = function(){
			window.print();
		}
		// HOOFDDORP
		//Core.dom.addClass(document.getElementById('infoNorthLabels'),"hidden");
		Core.dom.addClass(document.getElementById('infoSouthLabels'),"hidden");
		
		document.getElementById("menuBtnOverzichtsplattegrond").onclick  = onBtnOverzichtsplattegrond
	}

	var onBtnOverzichtsplattegrond = function(event) {
		
		Core.debug.log("SHoofddorp.view.Menu -> onBtnOverzichtsplattegrond()");
		Core.managers.NavigationManager.showAsset(SHoofddorp.Setup.content.Overzichtsplattegrond);
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