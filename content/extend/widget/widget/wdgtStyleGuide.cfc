component extends="plugins.widget.inc.resource.base.widget" {
	public component function init(required struct transport, required string path) {
		super.init(arguments.transport, arguments.path);
		
		return this;
	}
	
	public string function process( required string content, required struct args ) {
		//Include the standard markup guide used for testing the stylesheet
		local.html = fileRead('/algid/inc/resource/structure/markupGuide.cfm');
		
		return local.html;
	}
}
