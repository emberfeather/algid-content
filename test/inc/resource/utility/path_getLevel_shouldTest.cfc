component extends="mxunit.framework.TestCase" {
	public void function setup() {
		variables.path = createObject('component', 'plugins.content.inc.resource.utility.path').init();
	}
	
	public void function testReturn_blank() {
		assertEquals(0, variables.path.getLevel(''));
	}
	
	public void function testReturn_noLevels() {
		assertEquals(0, variables.path.getLevel('/'));
	}
	
	public void function testReturn_singleLevel() {
		assertEquals(1, variables.path.getLevel('/one'));
	}
	
	public void function testReturn_singleLevel() {
		assertEquals(2, variables.path.getLevel('/one/two'));
	}
	
	public void function testReturn_emptyLevel() {
		assertEquals(2, variables.path.getLevel('/one//two'));
	}
	
	public void function testReturn_trailingSlash() {
		assertEquals(2, variables.path.getLevel('/one/two/'));
	}
}
