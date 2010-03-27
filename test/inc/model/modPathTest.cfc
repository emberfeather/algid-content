<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cfscript>
		/**
		 * 
		 */
		public void function setup() {
			variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/'));
			variables.path = createObject('component', 'plugins.content.inc.model.modPath').init(variables.i18n);
		}
		
		public void function testSetPath_sansStartingSlash_shouldPrependSlash() {
			variables.path.setPath('test/path');
			
			assertEquals('/test/path', variables.path.getPath());
		}
		
		/**
		 * Tests the conversion of backward slashing paths to forward slash notation
		 */
		public void function testSetPath_withBackwordSlash_shouldConvertToForwardSlash() {
			variables.path.setPath('\test\path');
			
			assertEquals('/test/path', variables.path.getPath());
		}
		
		/**
		 * Tests setting the path to a blank string. Defaults to a / since all paths must have at least a /.
		 */
		public void function testSetPath_withBlank_shouldDefaultToRoot() {
			variables.path.setPath('');
			
			assertEquals('/', variables.path.getPath());
		}
		
		/**
		 * Tests the conversion of forward slashing paths to dot notation
		 */
		public void function testSetPath_withForwardSlash() {
			variables.path.setPath('/test/path');
			
			assertEquals('/test/path', variables.path.getPath());
		}
		
		/**
		 * Tests the validity of valid characters
		 */
		public void function testSetPath_withInvalidCharacters_shouldError() {
			try {
				variables.path.setPath('/test@a/path##with*invalid()characters');
				
				fail("Should not be able to set the path to a blank string.");
			} catch(mxunit.exception.AssertionFailedError exception) {
				rethrow();
			} catch(any exception) {
				// expect to get here
			}
		}
		
		/**
		 * Tests the stripping of multiple dashes
		 */
		public void function testSetPath_withMultipleSymbols_2dashes_shouldStripDuplicates() {
			variables.path.setPath('/test/path/with--multiple');
			
			assertEquals('/test/path/with-multiple', variables.path.getPath());
		}
		
		public void function testSetPath_withMultipleSymbols_5dashes_shouldStripDulicates() {
			variables.path.setPath('/test/path/with-----multiple');
			
			assertEquals('/test/path/with-multiple', variables.path.getPath());
		}
		
		/**
		 * Tests the stripping of multiple forward slashes
		 */
		public void function testSetPath_withMultipleSymbols_2slashes_shouldStripDuplicates() {
			variables.path.setPath('/test/path//multiple');
			
			assertEquals('/test/path/multiple', variables.path.getPath());
		}
		
		public void function testSetPath_withMultipleSymbols_5slashes_shouldStripDulicates() {
			variables.path.setPath('/test/path/////multiple');
			
			assertEquals('/test/path/multiple', variables.path.getPath());
		}
		
		/**
		 * Tests the stripping of multiple tildes
		 */
		public void function testSetPath_withMultipleSymbols_2tildes_shouldStripDuplicates() {
			variables.path.setPath('/test/path~~multiple');
			
			assertEquals('/test/path~multiple', variables.path.getPath());
		}
		
		public void function testSetPath_withMultipleSymbols_5tildes_shouldStripDulicates() {
			variables.path.setPath('/test/path~~~~~multiple');
			
			assertEquals('/test/path~multiple', variables.path.getPath());
		}
		
		/**
		 * Tests the stripping of multiple underscore
		 */
		public void function testSetPath_withMultipleSymbols_2underscore_shouldStripDuplicates() {
			variables.path.setPath('/test/path/with__multiple');
			
			assertEquals('/test/path/with_multiple', variables.path.getPath());
		}
		
		public void function testSetPath_withMultipleSymbols_5underscore_shouldStripDulicates() {
			variables.path.setPath('/test/path/with_____multiple');
			
			assertEquals('/test/path/with_multiple', variables.path.getPath());
		}
		
		/**
		 * Tests the validity of valid characters
		 */
		public void function testSetPath_withSpace_shouldConvertToUnderscore() {
			variables.path.setPath('/test a/path with valid spaces');
			
			assertEquals('/test_a/path_with_valid_spaces', variables.path.getPath());
		}
		
		/**
		 * Tests the stripping of trailing forward slashes
		 */
		public void function testSetPath_withTrailingSlash_shouldStripTrailingSlash() {
			variables.path.setPath('/test/path/');
			
			assertEquals('/test/path', variables.path.getPath());
		}
		
		/**
		 * Tests the validity of valid characters
		 */
		public void function testSetPath_withValidCharacters() {
			variables.path.setPath('/test-a/path~with_valid.characters');
			
			assertEquals('/test-a/path~with_valid.characters', variables.path.getPath());
		}
	</cfscript>
</cfcomponent>