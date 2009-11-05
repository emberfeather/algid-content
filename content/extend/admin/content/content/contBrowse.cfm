<!--- TODO Tree-based navigation --->
<cfset contents = servContent.getContents( filter ) />

<cfset paginate = variables.transport.theApplication.factories.transient.getPaginate(contents.recordcount, SESSION.numPerPage, theURL.searchID('onPage')) />

<cfoutput>#viewMaster.datagrid(transport, contents, viewContent, paginate, filter)#</cfoutput>
