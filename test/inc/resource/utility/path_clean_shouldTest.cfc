component extends="mxunit.framework.TestCase" {
	public void function setup() {
		variables.path = createObject('component', 'plugins.content.inc.resource.utility.path').init();
	}
	
	/**
	 * Tests the conversion of backward slashing paths to forward slash notation
	 */
	public void function testConvertToForwardSlashWithBackwordSlash() {
		assertEquals('/test/path', variables.path.clean('\test\path'));
	}
	
	/**
	 * Tests the validity of valid characters
	 */
	public void function testConvertToUnderscoreWithSpace() {
		assertEquals('/test_a/path_with_valid_spaces', variables.path.clean('/test a/path with valid spaces'));
	}
	
	/**
	 * Tests setting the path to a blank string. Defaults to a / since all paths must have at least a /.
	 */
	public void function testDefaultToRootWithBlank() {
		assertEquals('/', variables.path.clean(''));
	}
	
	/**
	 * Tests setting the path to multiple forward slashes only.
	 * Defaults to a / since all paths must have at least a /.
	 */
	public void function testDefaultToRootWithMultipleSlashes() {
		assertEquals('/', variables.path.clean('///'));
	}
	
	public void function testPrependSlashSansStartingSlash() {
		assertEquals('/test/path', variables.path.clean('test/path'));
	}
	
	/**
	 * Tests the conversion of forward slashing paths to dot notation
	 */
	public void function testRemainSameWithForwardSlash() {
		assertEquals('/test/path', variables.path.clean('/test/path'));
	}
	
	/**
	 * Tests the conversion of backward slashing paths to forward slash notation
	 */
	public void function testRemainSameWithValidCharacters() {
		var testPath = '/testValid._~-$@&+-!*"''(),';
		
		assertEquals(testPath, variables.path.clean(testPath));
	}
	
	/**
	 * Tests the stripping of multiple dashes
	 */
	public void function testStripDuplicatesWithMultipleSymbols_2dashes() {
		assertEquals('/test/path/with-multiple', variables.path.clean('/test/path/with--multiple'));
	}
	
	public void function testStripDulicatesWithMultipleSymbols_5dashes() {
		assertEquals('/test/path/with-multiple', variables.path.clean('/test/path/with-----multiple'));
	}
	
	/**
	 * Tests the stripping of multiple forward slashes
	 */
	public void function testStripDuplicatesWithMultipleSymbols_2slashes() {
		assertEquals('/test/path/multiple', variables.path.clean('/test/path//multiple'));
	}
	
	public void function testStripDulicatesWithMultipleSymbols_5slashes() {
		assertEquals('/test/path/multiple', variables.path.clean('/test/path/////multiple'));
	}
	
	/**
	 * Tests the stripping of multiple tildes
	 */
	public void function testStripDuplicatesWithMultipleSymbols_2tildes() {
		assertEquals('/test/path~multiple', variables.path.clean('/test/path~~multiple'));
	}
	
	public void function testStripDulicatesWithMultipleSymbols_5tildes() {
		assertEquals('/test/path~multiple', variables.path.clean('/test/path~~~~~multiple'));
	}
	
	/**
	 * Tests the stripping of multiple underscore
	 */
	public void function testStripDuplicatesWithMultipleSymbols_2underscore() {
		assertEquals('/test/path/with_multiple', variables.path.clean('/test/path/with__multiple'));
	}
	
	public void function testStripDulicatesWithMultipleSymbols_5underscore() {
		assertEquals('/test/path/with_multiple', variables.path.clean('/test/path/with_____multiple'));
	}
	
	/**
	 * Tests the stripping of trailing forward slashes
	 */
	public void function testStripTrailingSlashWithTrailingSlash() {
		assertEquals('/test/path', variables.path.clean('/test/path/'));
	}
}
