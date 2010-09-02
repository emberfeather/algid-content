<h3>Base Path: <span id="basePath" class="editable" contenteditable="true">/path</span></h3>

<h4>Template Name</h4>

<div class="grid_9 alpha">
	<div class="grid_3 alpha">
		<h5>Left Navigation</h5>
		
		<div class="dragarea">
			<div class="position position-pos1">
				<ul class="sortable">
					<cfloop from="1" to="#randRange(0, 20)#" index="i">
						<li>
							<cfoutput>
								<div class="float-right">
									<a href="/some/edit/link" class="edit"><span class="ui-icon ui-icon-pencil"></span></a>
								</div>
								<div class="float-left">
									<span class="ui-icon ui-icon-arrowthick-2-n-s"></span>
								</div>
								<div><strong id="pathTitle-#i#" contenteditable="true">Page Title #i# Goes Here</strong></div>
								<div>.../to/page#i#/goes/here</div>
							</cfoutput>
						</li>
					</cfloop>
				</ul>
			</div>
		</div>
	</div>
	
	<div class="grid_3">
		<h5>Top Navigation</h5>
		
		<div class="dragarea">
			<div class="position position-pos2">
				<ul class="sortable">
					<cfloop from="1" to="#randRange(0, 20)#" index="i">
						<li>
							<cfoutput>
								<div class="float-right">
									<a href="/some/edit/link" class="edit"><span class="ui-icon ui-icon-pencil"></span></a>
								</div>
								<div class="float-left">
									<span class="ui-icon ui-icon-arrowthick-2-n-s"></span>
								</div>
								<div><strong id="pathTitle-#i#" contenteditable="true">Page Title #i# Goes Here</strong></div>
								<div>.../to/page#i#/goes/here</div>
							</cfoutput>
						</li>
					</cfloop>
				</ul>
			</div>
		</div>
	</div>
	
	<div class="grid_3 omega">
		<h5>Right Navigation</h5>
		
		<div class="dragarea">
			<div class="position position-pos3">
				<ul class="sortable">
					<cfloop from="1" to="#randRange(0, 20)#" index="i">
						<li class="allowEdit">
							<cfoutput>
								<div class="float-right">
									<a href="/some/edit/link" class="edit"><span class="ui-icon ui-icon-pencil"></span></a>
								</div>
								<div class="float-left">
									<span class="ui-icon ui-icon-arrowthick-2-n-s"></span>
								</div>
								<div><strong id="pathTitle-#i#" contenteditable="true">Page Title #i# Goes Here</strong></div>
								<div>.../to/page#i#/goes/here</div>
							</cfoutput>
						</li>
					</cfloop>
				</ul>
			</div>
		</div>
	</div>
</div>

<div class="grid_3 omega">
	<h5>Hidden</h5>
	
	<div class="dragarea">
		<div class="position position-hidden">
			<ul class="sortable">
				<cfloop from="1" to="20" index="i">
					<li>
						<cfoutput>
							<div class="float-right">
								<a href="/some/edit/link" class="edit"><span class="ui-icon ui-icon-pencil"></span></a>
							</div>
							<div class="float-left">
								<span class="ui-icon ui-icon-arrowthick-2-n-s"></span>
							</div>
							<div><strong id="pathTitle-#i#" contenteditable="true">Page Title #i# Goes Here</strong></div>
							<div>.../to/page#i#/goes/here</div>
						</cfoutput>
					</li>
				</cfloop>
			</ul>
		</div>
	</div>
</div>
