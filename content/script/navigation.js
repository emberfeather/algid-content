(function($){
	var positions;
	var path;
	
	$(function() {
		// Setup a cache for the paths
		var searchCache = {};
		
		positions = $(".sortable");
		path = $("#path");
		
		positions.each(function() {
			$(this).sortable({
				connectWith: positions,
				stop: updatePositions
			});
		});
		
		// Set the ground work for the titles
		$('.title', positions)
			.each(storePathTitle)
			.change(updatePathTitle);
		
		path.autocomplete({
			select: function(event, ui) {
				path.parent().trigger('submit');
			},
			source: function(request, response) {
				// Check if the term has already been searched for
				if ( request.term in searchCache ) {
					response( searchCache[ request.term ] );
					
					return;
				}
				
				$.api({
					plugin: 'content',
					service: 'path',
					action: 'searchPath'
				}, {
					path: request.term
				}, {
					success: function( data ) {
						if(data.HEAD.result) {
							// Convert for use with the autocomplete
							for(var i = 0; i < data.BODY.length; i++) {
								data.BODY[i].value = data.BODY[i].path;
								data.BODY[i].label = data.BODY[i].path;
							}
							
							searchCache[ request.term ] = data.BODY;
							
							response( data.BODY );
						} else {
							if (window.console.error) {
								window.console.error(data.HEAD.errors);
							}
							
							response( [] );
						}
					}
				});
			},
			minLength: 0
		});
	});
	
	function storePathTitle(index, element) {
		var title = $(element);
		
		title.data('original', title.text());
	}
	
	function updatePathTitle(event) {
		var titleElement = $(event.target);
		var pathID = '';
		
		$.api({
			plugin: 'content',
			service: 'path',
			action: 'renamePath'
		}, {
			title: titleElement.val(),
			pathID: titleElement.parents('[data-pathID]').attr('data-pathID')
		}, {
			success: function( data ) {
				if(!data.HEAD.result) {
					window.console.error(data.HEAD.errors);
				}
			}
		});
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
			path: path.val(),
			positions: navigation
		}, {
			success: function( data ) {
				if(!data.HEAD.result) {
					$('.content').after($('<div />', { html: data.HEAD.errors.HEAD.error.detail }));
					$('.content').after($('<div />', { html: data.HEAD.errors.HEAD.error.stacktrace }));
					window.console.error(data.HEAD.errors);
				}
			}
		});
	}
}(jQuery));
