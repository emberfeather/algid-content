<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cfscript>
		public void function setup() {
			variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/'));
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
	</cfscript>
</cfcomponent>
