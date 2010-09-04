<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="navigation" access="public" returntype="string" output="false">
		<cfargument name="themes" type="query" required="true" />
		<cfargument name="path" type="component" required="true" />
		<cfargument name="hidden" type="query" required="true" />
		<cfargument name="navigation" type="query" required="true" />
		<cfargument name="paths" type="array" default="#[]#" />
		
		<cfset var class = '' />
		<cfset var currentPaths = '' />
		<cfset var i = '' />
		<cfset var i18n = '' />
		<cfset var theURL = '' />
		<cfset var html = '' />
		<cfset var nav = '' />
		
		<cfset theURL = variables.transport.theRequest.managers.singleton.getUrl() />
		
		<cfset theUrl.setEdit('_base', '/content/edit') />
		
		<cfsavecontent variable="html">
			<cfoutput>
				<div class="float-right">
					<select id="theme" name="theme">
						<option value="">{ inherit theme }</option>
						<cfloop query="arguments.themes">
							<option value="#arguments.themes.themeID.toString()#"<cfif arguments.path.getThemeID() eq arguments.themes.themeID.toString()> selected="selected"</cfif>>#arguments.themes.theme#</option>
						</cfloop>
					</select>
				</div>
				
				<h3>Path: <span id="basePath" class="editable" contenteditable="true"><cfoutput>#arguments.path.getPath()#</cfoutput></span></h3>
				
				<div class="grid_9 alpha">
					<cfloop query="arguments.navigation">
						<cfswitch expression="#arguments.navigation.currentRow mod 3#">
							<cfcase value="0">
								<cfset class = 'alpha' />
							</cfcase>
							<cfcase value="2">
								<cfset class = 'omega' />
							</cfcase>
							<cfdefaultcase>
								<cfset class = '' />
							</cfdefaultcase>
						</cfswitch>
						
						<cfset currentPaths = arguments.paths[arguments.navigation.currentRow] />
						
						<div class="grid_3 #class#">
							<h4>#arguments.navigation.navigation#</h4>
							
							<div class="dragarea">
								<div class="position">
									<ul class="sortable">
										<cfloop query="currentPaths">
											<cfset theUrl.setEdit('content', currentPaths.contentID.toString()) />
											
											<li data-pathid="#currentPaths.pathID#">
												<cfoutput>
													<div class="float-right">
														<a href="#theUrl.getEdit()#" class="edit"><span class="ui-icon ui-icon-pencil"></span></a>
													</div>
													<div class="float-left">
														<span class="ui-icon ui-icon-arrowthick-2-n-s"></span>
													</div>
													<div><strong class="title" contenteditable="true">#currentPaths.title#</strong></div>
													<div>#currentPaths.path#</div>
												</cfoutput>
											</li>
										</cfloop>
									</ul>
								</div>
							</div>
						</div>
					</cfloop>
				</div>
				
				<div class="grid_3 omega">
					<h4>Hidden</h4>
					
					<div class="dragarea">
						<div class="position">
							<ul class="sortable">
								<cfloop query="arguments.hidden">
									<cfset theUrl.setEdit('content', arguments.hidden.contentID.toString()) />
									
									<li data-pathid="#arguments.hidden.pathID#">
										<cfoutput>
											<div class="float-right">
												<a href="#theUrl.getEdit()#" class="edit"><span class="ui-icon ui-icon-pencil"></span></a>
											</div>
											<div class="float-left">
												<span class="ui-icon ui-icon-arrowthick-2-n-s"></span>
											</div>
											<div><strong class="title" contenteditable="true">#arguments.hidden.title#</strong></div>
											<div>#arguments.hidden.path#</div>
										</cfoutput>
									</li>
								</cfloop>
							</ul>
						</div>
					</div>
				</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn html />
	</cffunction>
</cfcomponent>
