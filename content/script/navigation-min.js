(function(b){function e(a,c){var d=b(c);d.data("original",d.html())}function f(a){a=b(a.target);a.data("original")!=a.html()&&b.api({plugin:"content",service:"path",action:"renamePath"},{title:a.html(),pathID:a.parents("[data-pathID]").attr("data-pathID")},{success:function(c){c.HEAD.result||window.console.error(c.HEAD.errors)}})}b(function(){var a=b(".sortable");a.sortable({connectWith:a});b(".title",a).each(e).blur(f)})})(jQuery);
