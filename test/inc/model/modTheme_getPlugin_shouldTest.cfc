component extends="algid.inc.resource.base.modelTest" {
	public void function setup() {
		super.setup();
		
		variables.theme = createObject('component', 'plugins.content.inc.model.modTheme').init(variables.i18n);
	}
	
	/**
	 * Tests pulling a plugin from a blank directory path
	 */
	public void function testReturnBlankWithoutDirectory() {
		assertEquals('', variables.theme.getPlugin());
	}
	
	/**
	 * Tests pulling a plugin from a directory path
	 */
	public void function testReturnPluginWithDirectory() {
		variables.theme.setDirectory('content/extend/content/theme/content');
		
		assertEquals('content', variables.theme.getPlugin());
	}
	
	/**
	 * Tests pulling a plugin from a directory path with a hyphen
	 */
	public void function testReturnPluginWithDirectory_hyphen() {
		variables.theme.setDirectory('some-plugin/extend/content/theme/content');
		
		assertEquals('some-plugin', variables.theme.getPlugin());
	}
}
