(function($){
	var positions;
	var path;
	
	$(function() {
		// Setup a cache for the paths
		var searchCache = {};
		
		positions = $(".sortable");
		path = $("#path");
		
		// Prime the previous index for copy purposes
		updatePreviousIndex();
		
		positions.sortable({
			connectWith: positions,
			receive: receivePosition,
			stop: updatePositions
		});
		
		// Set the ground work for the titles
		$('.title', positions)
			.change(updatePositions);
		
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
			minLength: 1
		});
	});
	
	function receivePosition(event, ui) {
		var cloned;
		var previousIndex;
		var sender;
		
		if(event.ctrlKey === true) {
			cloned = $(ui.item[0]).clone(true);
			previousIndex = cloned.data('previousIndex');
			sender = $(ui.sender[0]);
			
			// Insert the clone into the same index it was previously
			if(previousIndex == 0) {
				sender.prepend(cloned);
			} else {
				$('li:eq(' + (previousIndex - 1) + ')', sender).after(cloned);
			}
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
				position.paths[i] = {
					"pathID": position.paths[i].substr(5),
					"groupBy": ""
				};
				
				position.paths[i].title = $('[data-pathid=' + position.paths[i].pathID + '] input.title').val();
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
		
		updatePreviousIndex();
	}
	
	function updatePreviousIndex() {
		positions.each(function(){
			$('li', this).each(function(index){
				$(this).data('previousIndex', index);
			});
		});
	}
}(jQuery));
