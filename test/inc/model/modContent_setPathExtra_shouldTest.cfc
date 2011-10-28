component extends="algid.inc.resource.base.modelTest" {
	public void function setup() {
		super.setup();
		
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
	
	public void function testReturnExtraWhenWildcardPathFoundInRoot() {
		variables.content.setPathExtra('/my/path/here/it/is', '/*');
		
		assertEquals('/my/path/here/it/is', variables.content.getPathExtra());
	}
}
