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
		var titleElement = $(event.target);
		var pathID = '';
		
		if(titleElement.data('original') != titleElement.html()) {
			$.api({
				plugin: 'content',
				service: 'path',
				action: 'renamePath'
			}, {
				title: titleElement.html(),
				pathID: titleElement.parents('[data-pathID]').attr('data-pathID')
			}, {
				success: function( data ) {
					if(data.HEAD.result) {
						// Successfully changed... now what?
					} else {
						window.console.error(data.HEAD.errors);
					}
				}
			});
		}
	}
})(jQuery);
