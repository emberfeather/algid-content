component extends="algid.inc.resource.base.modelTest" {
	public void function setup() {
		super.setup();
		
		variables.content = createObject('component', 'plugins.content.inc.model.modContent').init(variables.i18n);
	}
	
	/**
	 * Tests that the setting of the contentHtml does not change the value of the content.
	 */
	public void function testReturnTrueWhenSetDoCachingIsNotCalled() {
		assertEquals(true, variables.content.getDoCaching());
	}
	
	/**
	 * Tests that the setting of the normal content resets the value of the contentHtml.
	 */
	public void function testReturnSameAsContentWhenSetContentIsCalled() {
		variables.content.setDoCaching(false);
		
		assertEquals(false, variables.content.getDoCaching());
	}
}
