component extends="algid.inc.resource.base.model" {
	public component function init(required component i18n, string locale = 'en_US') {
		super.init(arguments.i18n, arguments.locale);
		
		// Set the bundle information for translation
		add__bundle('plugins/content/i18n/inc/model', 'modDomain');
		
		// Host ID
		add__attribute(
			attribute = 'hostID'
		);
		
		// Domain ID
		add__attribute(
			attribute = 'domainID'
		);
		
		// Hostname
		add__attribute(
			attribute = 'hostname'
		);
		
		// Is Primary
		add__attribute(
			attribute = 'isPrimary',
			defaultValue = false
		);
		
		// hasSSL
		add__attribute(
			attribute = 'hasSSL',
			defaultValue = false
		);
		
		return this;
	}
	
	public string function getUrl() {
		return (this.getHasSSL() ? 'https' : 'http') & '://' & this.getHostname();
	}
}
