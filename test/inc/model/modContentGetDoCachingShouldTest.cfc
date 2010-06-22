<cfcomponent extends="mxunit.framework.TestCase" output="false">
<cfscript>
	public void function setup() {
		variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/'));
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
</cfscript>
</cfcomponent>
