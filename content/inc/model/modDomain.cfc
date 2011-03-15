component extends="algid.inc.resource.base.model" {
	public component function init(required component i18n, string locale = 'en_US') {
		super.init(arguments.i18n, arguments.locale);
		
		// Set the bundle information for translation
		add__bundle('plugins/content/i18n/inc/model', 'modDomain');
		
		// Domain ID
		add__attribute(
			attribute = 'domainID'
		);
		
		// Archived On
		add__attribute(
			attribute = 'archivedOn'
		);
		
		// CreatedOn
		add__attribute(
			attribute = 'createdOn'
		);
		
		// Domain
		add__attribute(
			attribute = 'domain'
		);
		
		// Hosts
		add__attribute(
			attribute = 'hosts',
			defaultValue = []
		);
		
		return this;
	}
	
	public component function getPrimaryHost() {
		local.hosts = this.getHosts();
		
		for(local.i = 1; local.i <= arrayLen(local.hosts); local.i++) {
			if(local.hosts[local.i].getIsPrimary()) {
				local.hosts[local.i];
			}
		}
		
		// Default to the first host available
		return local.hosts[1];
	}
}
