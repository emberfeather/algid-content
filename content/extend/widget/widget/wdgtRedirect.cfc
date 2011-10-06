component extends="plugins.widget.inc.resource.base.widget" {
	public component function init(required struct transport) {
		super.init(arguments.transport);
		
		preventCaching();
		
		return this;
	}
	
	public string function process( required string content, required struct args ) {
		if(structKeyExists(arguments.args, 'url')) {
			if(isStruct(arguments.args.url)) {
				local.theUrl = variables.transport.theRequest.managers.singleton.getUrl();
				
				if(structKeyExists(arguments.args, 'clean') && isBoolean(arguments.args.clean) && arguments.args.clean == true) {
					local.theUrl.cleanRedirect();
				}
				
				local.theUrl.setRedirect(arguments.args.url);
				local.theUrl.redirectRedirect();
			}
			
			location(arguments.args.url, false);
		}
	}
	
	public string function javascript( required string content, required struct args ) {
		local.html = '';
		local.target = (structKeyExists(arguments.args, 'target') ? arguments.args.target : 'top');
		
		if(structKeyExists(arguments.args, 'url')) {
			local.html = '<script>window.#local.target#.location.href = "#arguments.args.url#";</script>';
			local.html &= 'You should be redirected automatically, but if not please click this link: <a href="#arguments.args.url#" target="#local.target#">#arguments.args.url#</a>';
		}
		
		return local.html;
	}
}
