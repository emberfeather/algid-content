<cfset themes = servTheme.getThemes( filter ) />

<cfset paginate = variables.transport.theApplication.factories.transient.getPaginate(themes.recordcount, session.numPerPage, theURL.searchID('onPage')) />

<cfoutput>#viewMaster.datagrid(transport, themes, viewTheme, paginate, filter)#</cfoutput>
