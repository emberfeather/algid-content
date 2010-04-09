<div class="grid_12">
	<h2><cfoutput>#template.getPageTitle()#</cfoutput></h2>
</div>

<div class="grid_12">
	<!--- Show any messages, errors, warnings, or successes --->
	<cfset messages = session.managers.singleton.getError() />
	
	<cfoutput>#messages.toHTML()#</cfoutput>
	
	<cfset messages = session.managers.singleton.getWarning() />
	
	<cfoutput>#messages.toHTML()#</cfoutput>
	
	<cfset messages = session.managers.singleton.getSuccess() />
	
	<cfoutput>#messages.toHTML()#</cfoutput>
	
	<cfset messages = session.managers.singleton.getMessage() />
	
	<cfoutput>#messages.toHTML()#</cfoutput>
	
	<div class="clear"><!-- clear --></div>
</div>

<div class="grid_12">
	<!--- Output the main content --->
	<cfoutput>#template.getContent()#</cfoutput>
</div>
