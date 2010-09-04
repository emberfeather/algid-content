/**
 *
 */
;(function($){
	$(function(){
		// Setup a cache for the search terms
		var searchCache = {};
		
		// Find the path form fields
		paths = $('input[name^=path]');
		
		paths.autocomplete({
			source: function(request, response) {
				// Check if the term has already been searched for
				if ( request.term in searchCache ) {
					response( searchCache[ request.term ] );
					
					return;
				}
				
				$.ajax({
					url: $.algid.admin.options.base.url + $.algid.admin.options.base.api,
					dataType: 'json',
					type: 'post',
					data: {
						HEAD: JSON.stringify({
							plugin: 'content',
							service: 'path',
							action: 'searchPath'
						}),
						BODY: JSON.stringify({
							path: request.term
						})
					},
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
							window.console.error(data.HEAD.errors);
							
							response( [] );
						}
					}
				});
			},
			minLength: 0
		});
	});
})(jQuery);
