/**
 * 
 */
;(function($){
	$(function() {
		sortables = $(".sortable");
		
		sortables.sortable({
			connectWith: sortables
		});
	});
})(jQuery);
