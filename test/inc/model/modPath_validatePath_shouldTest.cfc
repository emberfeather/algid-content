component extends="algid.inc.resource.base.modelTest" {
	public void function setup() {
		super.setup();
		
		variables.path = createObject('component', 'plugins.content.inc.model.modPath').init(variables.i18n);
		
		local.validator = createObject('component', 'plugins.content.inc.resource.validation.path').init();
		
		add__validator(local.validator, 'plugins/content/i18n/inc/resource/validation', 'path');
	}
	
	/**
	 * Tests the invalidity of the colon character
	 */
	public void function testErrorWithInvalidCharacter_colon() {
		variables.path.setPath('/test:');
		
		super.expectException('validation');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the invalidity of the equal character
	 */
	public void function testErrorWithInvalidCharacter_equal() {
		variables.path.setPath('/test=');
		
		super.expectException('validation');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the invalidity of the hash character
	 */
	public void function testErrorWithInvalidCharacter_hash() {
		variables.path.setPath('/test##');
		
		super.expectException('validation');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the invalidity of the question character
	 */
	public void function testErrorWithInvalidCharacter_question() {
		variables.path.setPath('/test?');
		
		super.expectException('validation');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the invalidity of the semicolon character
	 */
	public void function testErrorWithInvalidCharacter_semicolon() {
		variables.path.setPath('/test;');
		
		super.expectException('validation');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the invalidity of the space character
	 */
	public void function testErrorWithInvalidCharacter_space() {
		variables.path.setPath('/test path');
		
		super.expectException('validation');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the validity of invalid characters
	 */
	public void function testErrorWithoutStartingSlash() {
		variables.path.setPath('test');
		
		super.expectException('validation');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the invalidity of the percent character
	 */
	public void function testErrorWithoutValidEscape_trailing() {
		variables.path.setPath('/test%');
		
		super.expectException('validation');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the invalidity of the percent character
	 */
	public void function testErrorWithoutValidEscape_trailingMulti() {
		variables.path.setPath('/test%a');
		
		super.expectException('validation');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the validity of valid ampersand character
	 */
	public void function testNotErrorWithValidCharacter_ampersand() {
		variables.path.setPath('/test&path');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the validity of valid at character
	 */
	public void function testNotErrorWithValidCharacter_at() {
		variables.path.setPath('/test@path');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the validity of valid dollar character
	 */
	public void function testNotErrorWithValidCharacter_dollar() {
		variables.path.setPath('/test$path');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the validity of valid double quote character
	 */
	public void function testNotErrorWithValidCharacter_doublequote() {
		variables.path.setPath('/test"path');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the validity of valid exclamation character
	 */
	public void function testNotErrorWithValidCharacter_exclamation() {
		variables.path.setPath('/test!path');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the validity of valid left parentheses character
	 */
	public void function testNotErrorWithValidCharacter_leftParentheses() {
		variables.path.setPath('/test(path');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the validity of valid minus character
	 */
	public void function testNotErrorWithValidCharacter_minus() {
		variables.path.setPath('/test-path');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the validity of valid period character
	 */
	public void function testNotErrorWithValidCharacter_period() {
		variables.path.setPath('/test.path');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the validity of valid plus character
	 */
	public void function testNotErrorWithValidCharacter_plus() {
		variables.path.setPath('/test+path');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the validity of valid right parentheses character
	 */
	public void function testNotErrorWithValidCharacter_rightParentheses() {
		variables.path.setPath('/test)path');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the validity of valid single quote character
	 */
	public void function testNotErrorWithValidCharacter_singlequote() {
		variables.path.setPath('/test''path');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the validity of valid star character
	 */
	public void function testNotErrorWithValidCharacter_star() {
		variables.path.setPath('/test*path');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the validity of valid tilde character
	 */
	public void function testNotErrorWithValidCharacter_tilde() {
		variables.path.setPath('/test~path');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the validity of valid underscore character
	 */
	public void function testNotErrorWithValidCharacter_underscore() {
		variables.path.setPath('/test_path');
		
		validate__model(variables.path);
	}
	
	/**
	 * Tests the invalidity of the percent character
	 */
	public void function testNotErrorWithValidEscape() {
		variables.path.setPath('/test%3apath');
		
		validate__model(variables.path);
	}
}
