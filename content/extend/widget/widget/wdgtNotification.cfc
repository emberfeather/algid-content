component extends="plugins.widget.inc.resource.base.widget" {
	public string function add( required string content, required struct args ) {
		arguments.args.type = __validateType(structKeyExists(arguments.args, 'type') ? arguments.args.type : '');
		
		local.notification = variables.transport.theSession.managers.singleton.get(arguments.args.type);
		
		local.notification.addMessages(arguments.content);
		
		return '';
	}
	
	public string function reset( required string content, required struct args ) {
		arguments.args.type = __validateType(structKeyExists(arguments.args, 'type') ? arguments.args.type : '');
		
		local.notification = variables.transport.theSession.managers.singleton.get(arguments.args.type);
		
		local.notification.resetMessages();
		
		return '';
	}
	
	public string function set( required string content, required struct args ) {
		arguments.args.type = __validateType(structKeyExists(arguments.args, 'type') ? arguments.args.type : '');
		
		local.notification = variables.transport.theSession.managers.singleton.get(arguments.args.type);
		
		local.notification.setMessages(arguments.content);
		
		return '';
	}
	
	private string function __validateType(required string type) {
		switch(arguments.type) {
			case 'warning':
			case 'error':
			case 'success':
				break;
			default:
				return 'Message';
		}
		
		return arguments.type;
	}
}
