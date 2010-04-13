<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cfscript>
		public void function setup() {
			variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/'));
			variables.path = createObject('component', 'plugins.content.inc.model.modPath').init(variables.i18n);
		}
		
		/**
		 * Tests the invalidity of the colon character
		 */
		public void function testErrorWithInvalidCharacter_colon() {
			expectException('validation');
			
			variables.path.validatePath('/test:');
		}
		
		/**
		 * Tests the invalidity of the equal character
		 */
		public void function testErrorWithInvalidCharacter_equal() {
			expectException('validation');
			
			variables.path.validatePath('/test=');
		}
		
		/**
		 * Tests the invalidity of the hash character
		 */
		public void function testErrorWithInvalidCharacter_hash() {
			expectException('validation');
			
			variables.path.validatePath('/test##');
		}
		
		/**
		 * Tests the invalidity of the question character
		 */
		public void function testErrorWithInvalidCharacter_question() {
			expectException('validation');
			
			variables.path.validatePath('/test?');
		}
		
		/**
		 * Tests the invalidity of the semicolon character
		 */
		public void function testErrorWithInvalidCharacter_semicolon() {
			expectException('validation');
			
			variables.path.validatePath('/test;');
		}
		
		/**
		 * Tests the invalidity of the space character
		 */
		public void function testErrorWithInvalidCharacter_space() {
			expectException('validation');
			
			variables.path.validatePath('/test path');
		}
		
		/**
		 * Tests the validity of invalid characters
		 */
		public void function testErrorWithoutStartingSlash() {
			expectException('validation');
			
			variables.path.validatePath('test');
		}
		
		/**
		 * Tests the invalidity of the percent character
		 */
		public void function testErrorWithoutValidEscape_trailing() {
			expectException('validation');
			
			variables.path.validatePath('/test%');
		}
		
		/**
		 * Tests the invalidity of the percent character
		 */
		public void function testErrorWithoutValidEscape_trailingMulti() {
			expectException('validation');
			
			variables.path.validatePath('/test%a');
		}
		
		/**
		 * Tests the validity of valid ampersand character
		 */
		public void function testNotErrorWithValidCharacter_ampersand() {
			variables.path.validatePath('/test&path');
		}
		
		/**
		 * Tests the validity of valid at character
		 */
		public void function testNotErrorWithValidCharacter_at() {
			variables.path.validatePath('/test@path');
		}
		
		/**
		 * Tests the validity of valid dollar character
		 */
		public void function testNotErrorWithValidCharacter_dollar() {
			variables.path.validatePath('/test$path');
		}
		
		/**
		 * Tests the validity of valid double quote character
		 */
		public void function testNotErrorWithValidCharacter_doublequote() {
			variables.path.validatePath('/test"path');
		}
		
		/**
		 * Tests the validity of valid exclamation character
		 */
		public void function testNotErrorWithValidCharacter_exclamation() {
			variables.path.validatePath('/test!path');
		}
		
		/**
		 * Tests the validity of valid left parentheses character
		 */
		public void function testNotErrorWithValidCharacter_leftParentheses() {
			variables.path.validatePath('/test(path');
		}
		
		/**
		 * Tests the validity of valid minus character
		 */
		public void function testNotErrorWithValidCharacter_minus() {
			variables.path.validatePath('/test-path');
		}
		
		/**
		 * Tests the validity of valid period character
		 */
		public void function testNotErrorWithValidCharacter_period() {
			variables.path.validatePath('/test.path');
		}
		
		/**
		 * Tests the validity of valid plus character
		 */
		public void function testNotErrorWithValidCharacter_plus() {
			variables.path.validatePath('/test+path');
		}
		
		/**
		 * Tests the validity of valid right parentheses character
		 */
		public void function testNotErrorWithValidCharacter_rightParentheses() {
			variables.path.validatePath('/test)path');
		}
		
		/**
		 * Tests the validity of valid single quote character
		 */
		public void function testNotErrorWithValidCharacter_singlequote() {
			variables.path.validatePath('/test''path');
		}
		
		/**
		 * Tests the validity of valid star character
		 */
		public void function testNotErrorWithValidCharacter_star() {
			variables.path.validatePath('/test*path');
		}
		
		/**
		 * Tests the validity of valid tilde character
		 */
		public void function testNotErrorWithValidCharacter_tilde() {
			variables.path.validatePath('/test~path');
		}
		
		/**
		 * Tests the validity of valid underscore character
		 */
		public void function testNotErrorWithValidCharacter_underscore() {
			variables.path.validatePath('/test_path');
		}
		
		/**
		 * Tests the invalidity of the percent character
		 */
		public void function testNotErrorWithValidEscape() {
			variables.path.validatePath('/test%3apath');
		}
	</cfscript>
</cfcomponent>
