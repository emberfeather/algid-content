<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cfscript>
		public void function setup() {
			variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/'));
			variables.path = createObject('component', 'plugins.content.inc.model.modPath').init(variables.i18n);
		}
		
		public void function testCleanPath_sansStartingSlash_shouldPrependSlash() {
			assertEquals('/test/path', variables.path.cleanPath('test/path'));
		}
		
		/**
		 * Tests the conversion of backward slashing paths to forward slash notation
		 */
		public void function testCleanPath_withValidCharacters_shouldRemainSame() {
			var testPath = '/testValid._~-$@&+-!*"''(),';
			
			assertEquals(testPath, variables.path.cleanPath(testPath));
		}
		
		/**
		 * Tests the conversion of backward slashing paths to forward slash notation
		 */
		public void function testCleanPath_withBackwordSlash_shouldConvertToForwardSlash() {
			assertEquals('/test/path', variables.path.cleanPath('\test\path'));
		}
		
		/**
		 * Tests setting the path to a blank string. Defaults to a / since all paths must have at least a /.
		 */
		public void function testCleanPath_withBlank_shouldDefaultToRoot() {
			assertEquals('/', variables.path.cleanPath(''));
		}
		
		/**
		 * Tests setting the path to multiple forward slashes only.
		 * Defaults to a / since all paths must have at least a /.
		 */
		public void function testCleanPath_withMultipleSlashes_shouldDefaultToRoot() {
			assertEquals('/', variables.path.cleanPath('///'));
		}
		
		/**
		 * Tests the conversion of forward slashing paths to dot notation
		 */
		public void function testCleanPath_withForwardSlash() {
			assertEquals('/test/path', variables.path.cleanPath('/test/path'));
		}
		
		/**
		 * Tests the stripping of multiple dashes
		 */
		public void function testCleanPath_withMultipleSymbols_2dashes_shouldStripDuplicates() {
			assertEquals('/test/path/with-multiple', variables.path.cleanPath('/test/path/with--multiple'));
		}
		
		public void function testCleanPath_withMultipleSymbols_5dashes_shouldStripDulicates() {
			assertEquals('/test/path/with-multiple', variables.path.cleanPath('/test/path/with-----multiple'));
		}
		
		/**
		 * Tests the stripping of multiple forward slashes
		 */
		public void function testCleanPath_withMultipleSymbols_2slashes_shouldStripDuplicates() {
			assertEquals('/test/path/multiple', variables.path.cleanPath('/test/path//multiple'));
		}
		
		public void function testCleanPath_withMultipleSymbols_5slashes_shouldStripDulicates() {
			assertEquals('/test/path/multiple', variables.path.cleanPath('/test/path/////multiple'));
		}
		
		/**
		 * Tests the stripping of multiple tildes
		 */
		public void function testCleanPath_withMultipleSymbols_2tildes_shouldStripDuplicates() {
			assertEquals('/test/path~multiple', variables.path.cleanPath('/test/path~~multiple'));
		}
		
		public void function testCleanPath_withMultipleSymbols_5tildes_shouldStripDulicates() {
			assertEquals('/test/path~multiple', variables.path.cleanPath('/test/path~~~~~multiple'));
		}
		
		/**
		 * Tests the stripping of multiple underscore
		 */
		public void function testCleanPath_withMultipleSymbols_2underscore_shouldStripDuplicates() {
			assertEquals('/test/path/with_multiple', variables.path.cleanPath('/test/path/with__multiple'));
		}
		
		public void function testCleanPath_withMultipleSymbols_5underscore_shouldStripDulicates() {
			assertEquals('/test/path/with_multiple', variables.path.cleanPath('/test/path/with_____multiple'));
		}
		
		/**
		 * Tests the validity of valid characters
		 */
		public void function testCleanPath_withSpace_shouldConvertToUnderscore() {
			assertEquals('/test_a/path_with_valid_spaces', variables.path.cleanPath('/test a/path with valid spaces'));
		}
		
		/**
		 * Tests the stripping of trailing forward slashes
		 */
		public void function testCleanPath_withTrailingSlash_shouldStripTrailingSlash() {
			assertEquals('/test/path', variables.path.cleanPath('/test/path/'));
		}
		
		/**
		 * Tests the invalidity of the colon character
		 */
		public void function testValidatePath_withInvalidCharacter_colon_shouldError() {
			expectException('validation');
			
			variables.path.validatePath('/test:');
		}
		
		/**
		 * Tests the invalidity of the equal character
		 */
		public void function testValidatePath_withInvalidCharacter_equal_shouldError() {
			expectException('validation');
			
			variables.path.validatePath('/test=');
		}
		
		/**
		 * Tests the invalidity of the hash character
		 */
		public void function testValidatePath_withInvalidCharacter_hash_shouldError() {
			expectException('validation');
			
			variables.path.validatePath('/test##');
		}
		
		/**
		 * Tests the invalidity of the question character
		 */
		public void function testValidatePath_withInvalidCharacter_question_shouldError() {
			expectException('validation');
			
			variables.path.validatePath('/test?');
		}
		
		/**
		 * Tests the invalidity of the semicolon character
		 */
		public void function testValidatePath_withInvalidCharacter_semicolon_shouldError() {
			expectException('validation');
			
			variables.path.validatePath('/test;');
		}
		
		/**
		 * Tests the invalidity of the space character
		 */
		public void function testValidatePath_withInvalidCharacter_space_shouldError() {
			expectException('validation');
			
			variables.path.validatePath('/test path');
		}
		
		/**
		 * Tests the validity of valid ampersand character
		 */
		public void function testValidatePath_withValidCharacter_ampersand_shouldNotError() {
			variables.path.validatePath('/test&path');
		}
		
		/**
		 * Tests the validity of valid at character
		 */
		public void function testValidatePath_withValidCharacter_at_shouldNotError() {
			variables.path.validatePath('/test@path');
		}
		
		/**
		 * Tests the validity of valid dollar character
		 */
		public void function testValidatePath_withValidCharacter_dollar_shouldNotError() {
			variables.path.validatePath('/test$path');
		}
		
		/**
		 * Tests the validity of valid double quote character
		 */
		public void function testValidatePath_withValidCharacter_doublequote_shouldNotError() {
			variables.path.validatePath('/test"path');
		}
		
		/**
		 * Tests the validity of valid exclamation character
		 */
		public void function testValidatePath_withValidCharacter_exclamation_shouldNotError() {
			variables.path.validatePath('/test!path');
		}
		
		/**
		 * Tests the validity of valid left parentheses character
		 */
		public void function testValidatePath_withValidCharacter_leftParentheses_shouldNotError() {
			variables.path.validatePath('/test(path');
		}
		
		/**
		 * Tests the validity of valid minus character
		 */
		public void function testValidatePath_withValidCharacter_minus_shouldNotError() {
			variables.path.validatePath('/test-path');
		}
		
		/**
		 * Tests the validity of valid period character
		 */
		public void function testValidatePath_withValidCharacter_period_shouldNotError() {
			variables.path.validatePath('/test.path');
		}
		
		/**
		 * Tests the validity of valid plus character
		 */
		public void function testValidatePath_withValidCharacter_plus_shouldNotError() {
			variables.path.validatePath('/test+path');
		}
		
		/**
		 * Tests the validity of valid right parentheses character
		 */
		public void function testValidatePath_withValidCharacter_rightParentheses_shouldNotError() {
			variables.path.validatePath('/test)path');
		}
		
		/**
		 * Tests the validity of valid single quote character
		 */
		public void function testValidatePath_withValidCharacter_singlequote_shouldNotError() {
			variables.path.validatePath('/test''path');
		}
		
		/**
		 * Tests the validity of valid star character
		 */
		public void function testValidatePath_withValidCharacter_star_shouldNotError() {
			variables.path.validatePath('/test*path');
		}
		
		/**
		 * Tests the validity of valid tilde character
		 */
		public void function testValidatePath_withValidCharacter_tilde_shouldNotError() {
			variables.path.validatePath('/test~path');
		}
		
		/**
		 * Tests the validity of valid underscore character
		 */
		public void function testValidatePath_withValidCharacter_underscore_shouldNotError() {
			variables.path.validatePath('/test_path');
		}
		
		/**
		 * Tests the invalidity of the percent character
		 */
		public void function testValidatePath_withValidEscape_shouldNotError() {
			variables.path.validatePath('/test%3apath');
		}
		
		/**
		 * Tests the validity of invalid characters
		 */
		public void function testValidatePath_withoutStartingSlash_shouldError() {
			expectException('validation');
			
			variables.path.validatePath('test');
		}
		
		/**
		 * Tests the invalidity of the percent character
		 */
		public void function testValidatePath_withoutValidEscape_trailing_shouldError() {
			expectException('validation');
			
			variables.path.validatePath('/test%');
		}
		
		/**
		 * Tests the invalidity of the percent character
		 */
		public void function testValidatePath_withoutValidEscape_trailingMulti_shouldError() {
			expectException('validation');
			
			variables.path.validatePath('/test%a');
		}
	</cfscript>
</cfcomponent>
