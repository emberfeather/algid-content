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
				<!--- TODO add functionality for changing the theme
				<div class="theme float-right">
					Theme: 
					
					<form action="#theUrl.get()#" method="post">
						<select id="theme" name="theme">
							<option value="">{ inherit theme }</option>
							<cfloop query="arguments.themes">
								<option value="#arguments.themes.themeID.toString()#"<cfif arguments.path.getThemeID() eq arguments.themes.themeID.toString()> selected="selected"</cfif>>#arguments.themes.theme#</option>
							</cfloop>
						</select>
						
						<input type="submit" value="Update" class="hidden" />
					</form>
				</div>
				 --->
				
				<div class="path">
					<form action="#theUrl.get()#" method="post">
						<input type="text" id="path" name="path" value="<cfoutput>#arguments.path.getPath()#</cfoutput>" class="inlineEdit" placeholder="Path" />
						
						<input type="submit" value="Update" class="hidden" />
					</form>
				</div>
				
				<div class="grid_9 alpha">
					<cfloop query="arguments.navigation">
						<cfswitch expression="#arguments.navigation.currentRow mod 3#">
							<cfcase value="1">
								<cfset class = 'alpha' />
							</cfcase>
							<cfcase value="0">
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
									<ul class="sortable" data-navigationID="#arguments.navigation.navigationID.toString()#">
										<cfloop query="currentPaths">
											<cfset theUrl.setEdit('content', currentPaths.contentID.toString()) />
											
											<li id="path_#currentPaths.pathID#" data-pathID="#currentPaths.pathID#">
												<cfoutput>
													<div><input class="title inlineEdit" value="#currentPaths.title#" /></div>
													<div class="float-right">
														<a href="#theUrl.getEdit()#" class="edit float-right" title="edit"><span class="ui-icon ui-icon-pencil"></span></a>
													</div>
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
							<ul class="sortable" data-navigationID="">
								<cfloop query="arguments.hidden">
									<cfset theUrl.setEdit('content', arguments.hidden.contentID.toString()) />
									
									<li id="path_#arguments.hidden.pathID#" data-pathID="#arguments.hidden.pathID#">
										<cfoutput>
											<div><input class="title inlineEdit" value="#arguments.hidden.contentTitle#" /></div>
											<div class="float-right">
												<a href="#theUrl.getEdit()#" class="edit float-right" title="edit"><span class="ui-icon ui-icon-pencil"></span></a>
											</div>
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
