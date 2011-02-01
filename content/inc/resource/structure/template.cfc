component extends="algid.inc.resource.structure.template" {
	/**
	 * Used to retrieve the formatted navigation element.
	 */
	public string function getNavigation( string domain = cgi.server_name, numeric level = 1, required any navPosition, struct options = {}, component authUser ) {
		var args = '';
		var defaults = {
			numLevels = 1,
			isExpanded = false,
			groupTag = '',
			outerTag = 'ul',
			innerTag = 'li'
		};
		
		// Create an argument collection
		args = {
			domain = arguments.domain,
			theURL = variables.theURL,
			level = arguments.level,
			navPosition = arguments.navPosition,
			options = extend(defaults, arguments.options),
			locale = variables.locale
		};
		
		// Check for user
		if( structKeyExists(arguments, 'authUser') ) {
			args.authUser = arguments.authUser;
		}
		
		// Check for caching
		if( this.hasNavigationCache() ) {
			args.cache = this.getNavigationCache();
		}
		
		return variables.navigation.toHTML( argumentCollection = args );
	}
}
