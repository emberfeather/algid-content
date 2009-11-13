<cfset domains = servDomain.getDomains( filter ) />

<cfset paginate = variables.transport.theApplication.factories.transient.getPaginate(domains.recordcount, SESSION.numPerPage, theURL.searchID('onPage')) />

<cfoutput>#viewMaster.datagrid(transport, domains, viewDomain, paginate, filter)#</cfoutput>
