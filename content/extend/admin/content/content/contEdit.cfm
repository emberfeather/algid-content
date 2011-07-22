<cfset viewContent = views.get('content', 'content') />

<!--- Check for existing paths --->
<cfset filter = {
	contentID: content.getContentID(),
	domainID: content.getDomainID(),
	orderBy: 'path',
	showNavigationFields: false
} />

<cfset paths = servPath.getPaths(filter) />

<!--- Check for existing types --->
<cfset types = servType.getTypes() />

<!--- Check for existing metas --->
<cfset metas = servMeta.getMetas({
	contentID: content.getContentID()
}) />

<cfoutput>
	#viewContent.edit( content, paths, metas, types, form )#
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
