;(function($){
	var positions;
	var basePath;
	
	$(function() {
		positions = $(".sortable");
		basePath = $("#basePath");
		
		positions.each(function() {
			$(this).sortable({
				connectWith: positions,
				stop: updatePositions
			});
		});
		
		// Set the ground work for the titles
		$('.title', positions)
			.each(storePathTitle)
			.blur(updatePathTitle); // TODO find a better event to bind on for the contenteditable attribute
	});
	
	function storePathTitle(index, element) {
		var title = $(element);
		
		title.data('original', title.text());
	}
	
	function updatePathTitle(event) {
		var titleElement = $(event.target);
		var pathID = '';
		
		if(titleElement.data('original') != titleElement.text()) {
			$.api({
				plugin: 'content',
				service: 'path',
				action: 'renamePath'
			}, {
				title: titleElement.text(),
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
	
	function updatePositions(event, ui) {
		var navigation = [];
		
		// Serialize the positions information
		positions.each(function() {
			var i;
			var item = $(this);
			var position = {
				navigationID: item.attr('data-navigationID'),
				paths: item.sortable('toArray')
			};
			
			// Remove the path prefix
			for(i = 0; i < position.paths.length; i++) {
				position.paths[i] = position.paths[i].substr(5);
			}
			
			navigation.push(position);
		});
		
		// Send the new positions off to the database
		$.api({
			plugin: 'content',
			service: 'navigation',
			action: 'setPositions'
		}, {
			path: basePath.text(),
			positions: navigation
		}, {
			success: function( data ) {
				if(data.HEAD.result) {
					// Successfully changed... now what?
				} else {
					$('.content').after($('<div />', { html: data.HEAD.errors.HEAD.error.detail }))
					$('.content').after($('<div />', { html: data.HEAD.errors.HEAD.error.stacktrace }))
					window.console.error(data.HEAD.errors);
				}
			}
		});
	}
})(jQuery);
