component extends="algid.inc.resource.base.modelTest" {
	public void function setup() {
		super.setup();
		
		variables.content = createObject('component', 'plugins.content.inc.model.modContent').init(variables.i18n);
	}
	
	/**
	 * Tests that the setting of the contentHtml does not change the value of the content.
	 */
	public void function testReturnDifferentFromContentWhenSetContentHtmlIsCalled() {
		variables.content.setContent('test content');
		variables.content.setContentHtml('test contentHtml');
		
		assertEquals('test content', variables.content.getContent());
	}
	
	/**
	 * Tests that the setting of the normal content resets the value of the contentHtml.
	 */
	public void function testReturnSameAsContentWhenSetContentIsCalled() {
		variables.content.setContent('test content');
		
		assertEquals('test content', variables.content.getContentHtml());
	}
	
	/**
	 * Test that getting the contentHtml with explicitly setting the content or contentHtml works.
	 */
	public void function testReturnBlankWhenNotSet() {
		assertEquals('', variables.content.getContentHtml());
	}
}
