(function(d){d(function(){var e={};d("input[name^=path]").autocomplete({source:function(c,f){c.term in e?f(e[c.term]):d.api({plugin:"content",service:"path",action:"searchPath"},{path:c.term},{success:function(a){if(a.HEAD.result){for(var b=0;b<a.BODY.length;b++){a.BODY[b].value=a.BODY[b].path;a.BODY[b].label=a.BODY[b].path}e[c.term]=a.BODY;f(a.BODY)}else{window.console.error&&window.console.error(a.HEAD.errors);f([])}}})},minLength:0})})})(jQuery);
