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
				path.setPath('test/path');
				
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
		public void function testSetPath_withBackwordSlash_shouldConvertToForwardSlash() {
			var path = createObject('component', 'plugins.content.inc.model.modPath').init(variables.i18n);
			
			path.setPath('\test\path');
			
			assertEquals('/test/path', path.getPath());
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
		 * Tests the conversion of forward slashing paths to dot notation
		 */
		public void function testSetPath_withForwardSlash() {
			var path = createObject('component', 'plugins.content.inc.model.modPath').init(variables.i18n);
			
			path.setPath('/test/path');
			
			assertEquals('/test/path', path.getPath());
		}
		
		/**
		 * Tests the validity of valid characters
		 */
		public void function testSetPath_withInvalidCharacters_shouldError() {
			var path = createObject('component', 'plugins.content.inc.model.modPath').init(variables.i18n);
			
			try {
				path.setPath('/test@a/path##with*invalid()characters');
				
				fail("Should not be able to set the path to a blank string.");
			} catch(mxunit.exception.AssertionFailedError exception) {
				rethrow();
			} catch(any exception) {
				// expect to get here
			}
		}
		
		/**
		 * Tests the validity of valid characters
		 */
		public void function testSetPath_withSpace_shouldConvertToUnderscore() {
			var path = createObject('component', 'plugins.content.inc.model.modPath').init(variables.i18n);
			
			path.setPath('/test a/path with valid spaces');
			
			assertEquals('/test_a/path_with_valid_spaces', path.getPath());
		}
		
		/**
		 * Tests the validity of valid characters
		 */
		public void function testSetPath_withValidCharacters() {
			var path = createObject('component', 'plugins.content.inc.model.modPath').init(variables.i18n);
			
			path.setPath('/test-a/path~with_valid.characters');
			
			assertEquals('/test-a/path~with_valid.characters', path.getPath());
		}
	</cfscript>
</cfcomponent>