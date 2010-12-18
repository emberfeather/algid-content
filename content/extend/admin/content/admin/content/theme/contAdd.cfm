<cfset themes = servTheme.readThemes( '', filter ) />

<cfset paginate = variables.transport.theApplication.factories.transient.getPaginate(arrayLen(themes), session.numPerPage, theURL.searchID('onPage')) />

<cfoutput>#viewMaster.datagrid(transport, themes, viewTheme, paginate, filter, { function = 'addTheme' })#</cfoutput>
