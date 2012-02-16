component extends="plugins.widget.inc.resource.base.widget" {
	public string function process( required string content, required struct args ) {
		if(structKeyExists(arguments.args, 'format') && arguments.args.format == 'AP') {
			local.formatAP = variables.transport.theApplication.managers.singleton.getPluralize();
			local.forceYear = structKeyExists(arguments.args, 'forceYear') && arguments.args.forceYear == true;
			
			if(!isArray(arguments.args.date)) {
				arguments.args.date = listToArray(arguments.args.date);
			}
			
			if(arrayLen(arguments.args.date) < 2) {
				arrayAppend(arguments.args.date, '');
			}
			
			return local.formatAP.dateFormat(arguments.args.date[1], arguments.args.date[2], local.forceYear);
		}
		
		if(!structKeyExists(arguments.args, 'mask')) {
			arguments.args.mask = 'medium';
		}
		
		return dateFormat(arguments.args.date, arguments.args.mask);
	}
}
