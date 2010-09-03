;(function($){
	$(function() {
		var sortables = $(".sortable");
		
		sortables.sortable({
			connectWith: sortables
		});
		
		// Set the ground work for the titles
		$('.title', sortables)
			.each(storePathTitle)
			.blur(updatePathTitle);// TODO find a better event to bind on for the contenteditable attribute
	});
	
	function storePathTitle(index, element) {
		var title = $(element);
		
		title.data('original', title.html());
	}
	
	function updatePathTitle(event) {
		var title = $(event.target);
		var hasChanged = (title.data('original') != title.html());
		
		if(hasChanged) {
			// TODO API call to change the path's title
		}
	}
})(jQuery);
