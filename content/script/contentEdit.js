/**
 *
 */
(function($){
	// Setup a cache for the paths
	var searchCache = {};
	
	$(function(){
		$('input[name^=path]').autocomplete({
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
		
		// Change the richtext editor based upon the selection of the type
		$('input[name=typeID]').change(function(){
			$('textarea[name=content]')
				.addClass('editor-' + $.one20.content.typeMap['type-' + this.value].toLowerCase())
				.richtext();
		}).filter(':checked').change();
	});
}(jQuery));
