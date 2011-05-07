component extends="algid.inc.resource.base.event" {
	public void function onUpdate( required struct transport, required component collection ) {
		local.servContent = getService(arguments.transport, 'content', 'content');
		
		// Find content to index
		// Assumes that the collection matches the domain name
		local.content = local.servContent.getContents({ domain: arguments.collection.getName(), orderBy: 'path' });
		
		if(local.content.recordCount) {
			local.urls = [];
			
			loop query="local.content" {
				arrayAppend(local.urls, local.content.path);
			}
			
			queryAddColumn(local.content, 'url', 'varchar', local.urls);
			
			index action="update" collection="#arguments.collection.getName()#" type="custom" query="local.content" key="contentID" body="content" title="title" category="content" urlPath="url";
			
			// Log the event
			local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
			local.eventLog.logEvent('content', 'updateCollection', 'Updated content for the ''' & arguments.collection.getName() & ''' collection.');
			
			// Add success message
			arguments.transport.theSession.managers.singleton.getSuccess().addMessages('Updated the content for the ''' & arguments.collection.getName() & ''' collection.');
		}
	}
}
