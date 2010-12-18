<cfset viewContent = views.get('content', 'content') />

<!--- Check for existing paths --->
<cfset filter = {
		contentID = content.getContentID()
	} />

<cfset paths = servPath.getPaths(filter) />

<!--- Check for existing types --->
<cfset types = servType.getTypes() />

<cfoutput>
	#viewContent.edit( content, paths, types, form )#
</cfoutput>

<cfsavecontent variable="tempScript">
	<cfoutput>
		;(function($){
			var typeMap = {};
			
			$.one20 = $.one20 || {};
			
			<cfloop query="types">
				typeMap['type-#types.typeID.toString()#'] = '#types.type#';
			</cfloop>
			
			$.one20.content = $.extend({}, $.one20.content, { typeMap: typeMap });
		})(jQuery);
	</cfoutput>
</cfsavecontent>

<cfset template.addScript(trim(tempScript)) />
