/**
 *
 */
(function($){
	// Setup a cache for the paths
	var searchCache = {};
	
	$(function(){
		$('input[name^="path"]').autocomplete({
			delay: 280,
			source: function(request, response) {
				var i;
				
				// Check if the term has already been searched for
				if ( searchCache[ request.term ] !== undefined ) {
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
							for(i = 0; i < data.BODY.length; i++) {
								data.BODY[i].value = data.BODY[i].path;
								data.BODY[i].label = data.BODY[i].path;
							}
							
							searchCache[ request.term ] = data.BODY;
							
							response( data.BODY );
						} else {
							response( [] );
						}
					}
				});
			},
			minLength: 0
		});
		
		var content = $('textarea[name="content"]');
		
		$('input[name="typeID"]').change(function() {
			content.data('editorType', $.trim($(this).parent().text().toLowerCase()));
			
			content.trigger('editorSwitch');
		});
	});
}(jQuery));
