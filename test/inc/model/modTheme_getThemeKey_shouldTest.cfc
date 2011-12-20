component extends="algid.inc.resource.base.modelTest" {
	public void function setup() {
		super.setup();
		
		variables.theme = createObject('component', 'plugins.content.inc.model.modTheme').init(variables.i18n);
	}
	
	/**
	 * Tests pulling a theme key from a blank directory path
	 */
	public void function testReturnBlankWithoutDirectory() {
		assertEquals('', variables.theme.getThemeKey());
	}
	
	/**
	 * Tests pulling a theme key from a directory path
	 */
	public void function testReturnPluginWithDirectory() {
		variables.theme.setDirectory('plugin/extend/content/theme/content');
		
		assertEquals('content', variables.theme.getThemeKey());
	}
	
	/**
	 * Tests pulling a theme key from a directory path with a hyphen
	 */
	public void function testReturnPluginWithDirectory_hyphen() {
		variables.theme.setDirectory('content/extend/content/theme/content-theme');
		
		assertEquals('content-theme', variables.theme.getThemeKey());
	}
}
