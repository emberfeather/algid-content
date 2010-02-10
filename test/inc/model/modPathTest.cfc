<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cfscript>
		/**
		 * 
		 */
		public void function setup() {
			variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/'));
		}
		
		/**
		 * Tests the conversion of backward slashing paths to dot notation
		 */
		public void function testSetPath_sansStartingDot_shouldError() {
			var path = createObject('component', 'plugins.content.inc.model.modPath').init(variables.i18n);
			
			try {
				path.setPath('test.path');
				
				fail("Should not be able to set the path that does not start with a dot.");
			} catch(mxunit.exception.AssertionFailedError exception) {
				rethrow();
			} catch(any exception) {
				// expect to get here
			}
		}
		
		/**
		 * Tests the conversion of backward slashing paths to dot notation
		 */
		public void function testSetPath_withBackwordSlash_shouldConvertToDotNotation() {
			var path = createObject('component', 'plugins.content.inc.model.modPath').init(variables.i18n);
			
			path.setPath('\test\path');
			
			assertEquals('.test.path', path.getPath());
		}
		
		/**
		 * Tests setting the path to a blank string. Should not work. All paths must have at least a .
		 */
		public void function testSetPath_withBlank_shouldError() {
			var path = createObject('component', 'plugins.content.inc.model.modPath').init(variables.i18n);
			
			try {
				path.setPath('');
				
				fail("Should not be able to set the path to a blank string.");
			} catch(mxunit.exception.AssertionFailedError exception) {
				rethrow();
			} catch(any exception) {
				// expect to get here
			}
		}
		
		/**
		 * Tests the conversion of backward slashing paths to dot notation
		 */
		public void function testSetPath_withDots() {
			var path = createObject('component', 'plugins.content.inc.model.modPath').init(variables.i18n);
			
			path.setPath('.test.path');
			
			assertEquals('.test.path', path.getPath());
		}
		
		/**
		 * Tests the conversion of forward slashing paths to dot notation
		 */
		public void function testSetPath_withForwardSlash_shouldConvertToDotNotation() {
			var path = createObject('component', 'plugins.content.inc.model.modPath').init(variables.i18n);
			
			path.setPath('/test/path');
			
			assertEquals('.test.path', path.getPath());
		}
	</cfscript>
</cfcomponent>