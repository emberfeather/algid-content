component extends="algid.inc.resource.base.event" {
	public void function generate(required struct transport, required component task, required struct options, required component report) {
		local.servContent = getService(arguments.transport, 'content', 'content');
		local.servDomain = getService(arguments.transport, 'content', 'domain');
		
		local.filter = {
			endOn: now(),
			startOn: dateAdd('s', -1 * arguments.task.getInterval(), now())
		};
		
		local.content = local.servContent.getContentStats(local.filter);
		local.domains = local.servDomain.getDomainStats(local.filter);
		
		local.viewReport = getView(arguments.transport, 'content', 'report');
		
		local.section = local.servContent.getModel('admin', 'reportSection');
		
		local.section.setTitle('Content');
		local.section.setContent(local.viewReport.contentStats(local.content, local.domains));
		
		// Only add if actually has something to display
		if(len(local.section.getContent())) {
			report.addSections(local.section);
		}
	}
}
