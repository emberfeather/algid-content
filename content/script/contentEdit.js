require([ 'jquery' ], function(jQuery) {
	(function($){
		var pathCache = {};
		var metaNames = ['Author',
		                 'Cache-Control',
		                 'Content-Language',
		                 'Content-Type',
		                 'Copyright',
		                 'Description',
		                 'Expires',
		                 'Googlebot',
		                 'Keywords',
		                 'Pragma No-Cache',
		                 'Refresh',
		                 'Robots'];
		
		$(function(){
			// Bind to the duplication
			$('.element').live({
				afterduplicate: function(){
					var container = $(this);
					
					$('input[name^="path"]', container).autocomplete({
						delay: 280,
						source: pathSource,
						minLength: 0
					});
					
					$('input.metaname', container).autocomplete({
						minLength: 0,
						source: metaNames
					});
				}
			}).trigger('afterduplicate');
		});
		
		function pathSource(request, response) {
			var i;
			
			// Check if the term has already been searched for
			if ( pathCache[ request.term ] !== undefined ) {
				response( pathCache[ request.term ] );
				
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
						
						pathCache[ request.term ] = data.BODY;
						
						response( data.BODY );
					} else {
						response( [] );
					}
				}
			});
		}
	}(jQuery));
});
