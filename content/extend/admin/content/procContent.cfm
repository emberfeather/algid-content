<cfset servContent = transport.theApplication.factories.transient.getServContentForContent(transport.theApplication.managers.singleton.getApplication().getDSUpdate(), transport) />

<!--- Redirect to the browse page until a good reason for this page exists --->
<cfset theURL.setRedirect('_base', '/content/browse') />
<cfset theURL.redirectRedirect() />
