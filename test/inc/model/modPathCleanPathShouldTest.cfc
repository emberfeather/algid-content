<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cfscript>
		public void function setup() {
			variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/'));
			variables.path = createObject('component', 'plugins.content.inc.model.modPath').init(variables.i18n);
		}
		
		/**
		 * Tests the conversion of backward slashing paths to forward slash notation
		 */
		public void function testConvertToForwardSlashWithBackwordSlash() {
			assertEquals('/test/path', variables.path.cleanPath('\test\path'));
		}
		
		/**
		 * Tests the validity of valid characters
		 */
		public void function testConvertToUnderscoreWithSpace() {
			assertEquals('/test_a/path_with_valid_spaces', variables.path.cleanPath('/test a/path with valid spaces'));
		}
		
		/**
		 * Tests setting the path to a blank string. Defaults to a / since all paths must have at least a /.
		 */
		public void function testDefaultToRootWithBlank() {
			assertEquals('/', variables.path.cleanPath(''));
		}
		
		/**
		 * Tests setting the path to multiple forward slashes only.
		 * Defaults to a / since all paths must have at least a /.
		 */
		public void function testDefaultToRootWithMultipleSlashes() {
			assertEquals('/', variables.path.cleanPath('///'));
		}
		
		public void function testPrependSlashSansStartingSlash() {
			assertEquals('/test/path', variables.path.cleanPath('test/path'));
		}
		
		/**
		 * Tests the conversion of forward slashing paths to dot notation
		 */
		public void function testRemainSameWithForwardSlash() {
			assertEquals('/test/path', variables.path.cleanPath('/test/path'));
		}
		
		/**
		 * Tests the conversion of backward slashing paths to forward slash notation
		 */
		public void function testRemainSameWithValidCharacters() {
			var testPath = '/testValid._~-$@&+-!*"''(),';
			
			assertEquals(testPath, variables.path.cleanPath(testPath));
		}
		
		/**
		 * Tests the stripping of multiple dashes
		 */
		public void function testStripDuplicatesWithMultipleSymbols_2dashes() {
			assertEquals('/test/path/with-multiple', variables.path.cleanPath('/test/path/with--multiple'));
		}
		
		public void function testStripDulicatesWithMultipleSymbols_5dashes() {
			assertEquals('/test/path/with-multiple', variables.path.cleanPath('/test/path/with-----multiple'));
		}
		
		/**
		 * Tests the stripping of multiple forward slashes
		 */
		public void function testStripDuplicatesWithMultipleSymbols_2slashes() {
			assertEquals('/test/path/multiple', variables.path.cleanPath('/test/path//multiple'));
		}
		
		public void function testStripDulicatesWithMultipleSymbols_5slashes() {
			assertEquals('/test/path/multiple', variables.path.cleanPath('/test/path/////multiple'));
		}
		
		/**
		 * Tests the stripping of multiple tildes
		 */
		public void function testStripDuplicatesWithMultipleSymbols_2tildes() {
			assertEquals('/test/path~multiple', variables.path.cleanPath('/test/path~~multiple'));
		}
		
		public void function testStripDulicatesWithMultipleSymbols_5tildes() {
			assertEquals('/test/path~multiple', variables.path.cleanPath('/test/path~~~~~multiple'));
		}
		
		/**
		 * Tests the stripping of multiple underscore
		 */
		public void function testStripDuplicatesWithMultipleSymbols_2underscore() {
			assertEquals('/test/path/with_multiple', variables.path.cleanPath('/test/path/with__multiple'));
		}
		
		public void function testStripDulicatesWithMultipleSymbols_5underscore() {
			assertEquals('/test/path/with_multiple', variables.path.cleanPath('/test/path/with_____multiple'));
		}
		
		/**
		 * Tests the stripping of trailing forward slashes
		 */
		public void function testStripTrailingSlashWithTrailingSlash() {
			assertEquals('/test/path', variables.path.cleanPath('/test/path/'));
		}
	</cfscript>
</cfcomponent>
