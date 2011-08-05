<cfcomponent extends="cf-compendium.inc.resource.structure.form.common" output="false">
	<cffunction name="elementMeta" access="public" returntype="string" output="false">
		<cfargument name="element" type="struct" required="true" />
		
		<cfset local.ele = {
			type: 'text',
			class: arguments.element.class & ' metaname',
			id: arguments.element.id & '-name',
			name: arguments.element.name & '.name',
			value: arguments.element.value.name
		} />
		
		<cfset local.formatted = '<div><label>Meta Name: ' & elementInput(local.ele) & '</label></div>' />
		
		<cfset local.ele = {
			type: 'textarea',
			class: 'elastic',
			id: arguments.element.id & '-value',
			name: arguments.element.name & '.value',
			value: arguments.element.value.value
		} />
		
		<cfset local.formatted &= '<div>' & elementTextarea(local.ele) & '</div>' />
		
		<cfset local.ele = {
			type: 'hidden',
			id: arguments.element.id & '-id',
			name: arguments.element.name & '.id',
			value: arguments.element.value.id
		} />
		
		<cfset local.formatted &= elementInput(local.ele) />
		
		<cfreturn '<div class="options">' & local.formatted & '</div>' />
	</cffunction>
</cfcomponent>
