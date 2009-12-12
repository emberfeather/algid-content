<!--- TODO Tree-based navigation --->
<cfset contents = servContent.getContents( filter ) />

<cfset paginate = variables.transport.theApplication.factories.transient.getPaginate(contents.recordcount, session.numPerPage, theURL.searchID('onPage')) />

<cfoutput>#viewMaster.datagrid(transport, contents, viewContent, paginate, filter)#</cfoutput>
