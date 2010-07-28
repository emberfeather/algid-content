<cfcomponent extends="mxunit.framework.TestCase" output="false">
<cfscript>
	public void function setup() {
		variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/'));
		variables.content = createObject('component', 'plugins.content.inc.model.modContent').init(variables.i18n);
	}
	
	public void function testReturnBlankWhenNotSet() {
		variables.content.setPathExtra('', '');
		
		assertEquals('', variables.content.getPathExtra());
	}
	
	public void function testReturnBlankWhenPathsEqual() {
		variables.content.setPathExtra('/my/path/here', '/my/path/here');
		
		assertEquals('', variables.content.getPathExtra());
	}
	
	public void function testReturnExtraWhenExtraFoundWithPath() {
		variables.content.setPathExtra('/my/path/here/it/is', '/my/path/here');
		
		assertEquals('/it/is', variables.content.getPathExtra());
	}
	
	public void function testReturnExtraWhenWildcardPathFound() {
		variables.content.setPathExtra('/my/path/here/it/is', '/my/path/*');
		
		assertEquals('/here/it/is', variables.content.getPathExtra());
	}
</cfscript>
</cfcomponent>
