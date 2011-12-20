component extends="plugins.widget.inc.resource.base.widget" {
	public string function process( required string content, required struct args ) {
		local.theUrl = variables.transport.theRequest.managers.singleton.getUrl();
		
		if(!structKeyExists(arguments.args, 'name')) {
			arguments.args.name = 'Temp';
		}
		
		if(structKeyExists(arguments.args, 'clean') && isBoolean(arguments.args.clean) && arguments.args.clean == true) {
			local.theUrl['clean' & arguments.args.name]();
		}
		
		if(structKeyExists(arguments.args, 'url')) {
			local.theUrl['set' & arguments.args.name](arguments.args.url);
		}
		
		return local.theUrl['get' & arguments.args.name]();
	}
}
