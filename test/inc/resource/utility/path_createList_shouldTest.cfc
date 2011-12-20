component extends="mxunit.framework.TestCase" {
	public void function setup() {
		variables.path = createObject('component', 'plugins.content.inc.resource.utility.path').init();
	}
	
	public void function testReturnWithEmptyKeys_WithRootPath() {
		assertEquals('/', variables.path.createList('/', []));
	}
	
	public void function testReturnWithEmptyKeys_WithMultiLevelPath() {
		assertEquals('/,/one,/one/two', variables.path.createList('/one/two', []));
	}
	
	public void function testReturnWithEmptyKeys_WithSingleLevelPath() {
		assertEquals('/,/one', variables.path.createList('/one', []));
	}
	
	public void function testReturnWithMultipleKeys_WithRootPath() {
		assertEquals('/~,/^', variables.path.createList('/', ['~', '^']));
	}
	
	public void function testReturnWithMultipleKeys_WithMultiLevelPath() {
		assertEquals('/~,/^,/one/~,/one/^,/one/two/~,/one/two/^', variables.path.createList('/one/two', ['~', '^']));
	}
	
	public void function testReturnWithMultipleKeys_WithSingleLevelPath() {
		assertEquals('/~,/^,/one/~,/one/^', variables.path.createList('/one', ['~', '^']));
	}
	
	public void function testReturnWithoutKeys_WithRootPath() {
		assertEquals('/', variables.path.createList('/'));
	}
	
	public void function testReturnWithoutKeys_WithMultiLevelPath() {
		assertEquals('/,/one,/one/two', variables.path.createList('/one/two'));
	}
	
	public void function testReturnWithoutKeys_WithSingleLevelPath() {
		assertEquals('/,/one', variables.path.createList('/one'));
	}
	
	public void function testReturnWithSingleKey_WithRootPath() {
		assertEquals('/~', variables.path.createList('/', ['~']));
	}
	
	public void function testReturnWithSimpleKey_WithMultiLevelPath() {
		assertEquals('/~,/one/~,/one/two/~', variables.path.createList('/one/two', ['~']));
	}
	
	public void function testReturnWithSimpleKey_WithSingleLevelPath() {
		assertEquals('/~,/one/~', variables.path.createList('/one', ['~']));
	}
}
