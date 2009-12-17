<cfsilent>
	<cfset profiler = application.factories.transient.getProfiler(transport.theApplication.managers.singleton.getApplication().getEnvironment() neq 'production') />
	
	<cfset profiler.start('startup') />
	
	<!--- Create URL object from the transient --->
	<cfset theURL = application.factories.transient.getURLForContent(CGI.QUERY_STRING) />
	
	<!--- TODO Find actual location --->
	
	<!--- TODO Create template object --->
	
	<cfset profiler.stop('startup') />
	
	<cfset profiler.start('process') />
	
	<!--- TODO Process request --->
	
	<cfset profiler.stop('process') />
	
	<cfset profiler.start('content') />
	
	<!--- TODO Include Content --->
	
	<cfset profiler.stop('content') />
	
	<cfset profiler.start('template') />
</cfsilent>

<!--- TODO Include Template File --->

<cfset profiler.stop('template') />