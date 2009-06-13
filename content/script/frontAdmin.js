/**
 * Content Admin for the Front-end JavaScript
 * 
 * Making administration cool again.
 */
;(function($) {
	$adminMenu = null;
	
	$(function() {
		initialize();
		
		$adminMenu.text('Content Administration');
	});
	
	$.fn.extend({
		myPunk: function() {
			return this;
		}
	});
	
	function initialize() {
		// Create the admin menu div
		var adminDiv = '<div id="contentAdminMenu"></div>';
		$(adminDiv).appendTo($('body'));
		
		// Set the variable for referencing the menu
		$adminMenu = $('#contentAdminMenu');
	}
})(jQuery);