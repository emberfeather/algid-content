<cfcomponent extends="algid.inc.resource.plugin.configure" output="false">
	<cffunction name="inContent" access="public" returntype="boolean" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="targetPage" type="string" required="true" />
		
		<cfset var path = '' />
		
		<!--- Get the path to the base --->
		<cfset path = arguments.theApplication.managers.singleton.getApplication().getPath()
			& arguments.theApplication.managers.plugin.getContent().getPath() />
		
		<!--- Only pages in the root of path qualify --->
		<cfreturn reFind('^' & path & '[a-zA-Z0-9-\.]*.cfm$', arguments.targetPage) GT 0 />
	</cffunction>
	
	<cffunction name="onApplicationStart" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		
		<cfset var bundleName = '' />
		<cfset var contentDirectory = '' />
		<cfset var files = '' />
		<cfset var i = '' />
		<cfset var i18n = '' />
		<cfset var i18nDirectory = '' />
		<cfset var navDirectory = '' />
		<cfset var navigation = '' />
		<cfset var plugin = '' />
		<cfset var search = '' />
		
		<!--- Create the admin navigation singleton --->
		<cfset navigation = arguments.theApplication.factories.transient.getNavigationForContent(arguments.theApplication.managers.singleton.getI18N()) />
		
		<cfset arguments.theApplication.managers.singleton.setContentNavigation(navigation) />
	</cffunction>
	
	<cffunction name="onRequestStart" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		<cfargument name="theRequest" type="struct" required="true" />
		<cfargument name="targetPage" type="string" required="true" />
		
		<cfset var temp = '' />
		
		<!--- Only do the following if in the admin area --->
		<cfif inContent( arguments.theApplication, arguments.targetPage )>
			<!--- Create a profiler object --->
			<cfset temp = arguments.theApplication.factories.transient.getProfiler(not arguments.theApplication.managers.singleton.getApplication().isProduction()) />
			
			<cfset arguments.theRequest.managers.singleton.setProfiler( temp ) />
			
			<!--- Create the URL object for all the admin requests --->
			<cfset temp = arguments.theApplication.factories.transient.getUrlForContent(URL) />
			
			<cfset arguments.theRequest.managers.singleton.setUrl( temp ) />
		</cfif>
	</cffunction>
	
	<!---
		Configures the database for v0.1.0
	--->
	<cffunction name="postgreSQL0_1_0" access="public" returntype="void" output="false">
		<!---
			SCHEMA
		--->
		
		<!--- Content Schema --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SCHEMA "#variables.datasource.prefix#content"
				AUTHorIZATION #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON SCHEMA "#variables.datasource.prefix#content" IS 'Content Plugin Schema';
		</cfquery>
		
		<!---
			TABLES
		--->
		
		<!--- Domain Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."domain"
			(
				"domainID" uuid NOT NULL,
				"domain" character varying(150) not NULL,
				"createdOn" timestamp without time zone not NULL DEFAUlt now(),
				"archivedOn" timestamp without time zone,
				CONSTRAINT "domain_domainID_PK" PRIMARY KEY ("domainID"),
				CONSTRAINT "domain_domain_U" UNIQUE (domain)
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."domain" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."domain" IS 'Domains being administered by the content plugin.';
		</cfquery>
		
		<!--- Theme Table --->
		<!--- Required for Attribute Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".theme
			(
				"themeID" uuid NOT NULL,
				theme character varying(50) not NULL,
				directory character varying(50) not NULL,
				levels smallint not NULL DEFAUlt 1,
				"isPublic" boolean not NULL DEFAUlt true,
				"archivedOn" timestamp without time zone,
				CONSTRAINT "theme_themeID_PK" PRIMARY KEY ("themeID")
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".theme OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".theme IS 'Themes in use with the content plugin.';
		</cfquery>
		
		<!--- Type Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."type"
			(
				"typeID" uuid NOT NULL,
				"type" character varying(50) not NULL,
				CONSTRAINT "type_PK" PRIMARY KEY ("typeID")
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."type" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."type" IS 'Type of content available in the content plugin.';
		</cfquery>
		
		<!--- Attribute Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".attribute
			(
				"attributeID" uuid NOT NULL,
				"themeID" uuid NOT NULL,
				attribute character varying(100) not NULL,
				"key" character varying(25) not NULL,
				"hasCustom" boolean not NULL DEFAUlt true,
				CONSTRAINT "attribute_PK" PRIMARY KEY ("attributeID"),
				CONSTRAINT "attribute_themeID_FK" ForEIGN KEY ("themeID")
					REFERENCES "#variables.datasource.prefix#content".theme ("themeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "attribute_themeID_key_u" UNIQUE ("themeID", key)
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".attribute OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".attribute IS 'Theme attributes for manipulating the display of the content.';
		</cfquery>
		
		<!--- Attribute Option Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."attributeOption"
			(
				"attributeOptionID" uuid NOT NULL,
				"attributeID" uuid NOT NULL,
				label character varying(100) not NULL,
				"value" character varying(50) not NULL,
				CONSTRAINT "attributeOption_PK" PRIMARY KEY ("attributeOptionID"),
				CONSTRAINT "attributeOption_optionID_FK" ForEIGN KEY ("attributeID")
					REFERENCES "#variables.datasource.prefix#content".attribute ("attributeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."attributeOption" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."attributeOption" IS 'Theme attribute options to allow the user to choose a predefined attribute value.';
		</cfquery>
		
		<!--- Content Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."content"
			(
				"contentID" uuid NOT NULL,
				"domainID" uuid NOT NULL,
				"typeID" uuid NOT NULL,
				title character varying(255) not NULL,
				"content" text not NULL,
				"createdOn" timestamp without time zone not NULL DEFAUlt now(),
				"updatedOn" timestamp without time zone not NULL DEFAUlt now(),
				"expiresOn" timestamp without time zone,
				"archivedOn" timestamp without time zone,
				CONSTRAINT "content_content_PK" PRIMARY KEY ("contentID"),
				CONSTRAINT "content_domainID_FK" ForEIGN KEY ("domainID")
					REFERENCES "#variables.datasource.prefix#content"."domain" ("domainID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "content_typeID_FK" ForEIGN KEY ("typeID")
					REFERENCES "#variables.datasource.prefix#content"."type" ("typeID") MATCH SIMPLE
					ON UPDATE NO ACTION ON DELETE NO ACTION
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."content" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."content" IS 'Content for the content plugin.';
		</cfquery>
		
		<!--- Draft Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".draft
			(
				"contentID" uuid NOT NULL,
				draft text not NULL,
				"publishOn" timestamp without time zone,
				"createdOn" timestamp without time zone not NULL DEFAUlt now(),
				"updatedOn" timestamp without time zone not NULL DEFAUlt now(),
				CONSTRAINT "draft_PK" PRIMARY KEY ("contentID", "createdOn"),
				CONSTRAINT "draft_contentID_FK" ForEIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".draft OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".draft IS 'Content drafts information for unpublished content.';
		</cfquery>
		
		<!--- Meta Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".meta
			(
				"metaID" uuid NOT NULL,
				"contentID" uuid NOT NULL,
				"name" character varying(35) not NULL,
				"value" text not NULL,
				CONSTRAINT "meta_PK" PRIMARY KEY ("metaID"),
				CONSTRAINT "meta_contentID_FK" ForEIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE NO ACTION ON DELETE NO ACTION
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".meta OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".meta IS 'Meta information associated with the content.';
		</cfquery>
		
		<!--- Navigation Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".navigation
			(
				"navigationID" uuid NOT NULL,
				"level" smallint not NULL,
				navigation character varying(50) not NULL,
				"themeID" uuid NOT NULL,
				"allowGroups" boolean not NULL DEFAUlt true,
				CONSTRAINT "navigation_PK" PRIMARY KEY ("navigationID"),
				CONSTRAINT "navigation_themeID_FK" ForEIGN KEY ("themeID")
					REFERENCES "#variables.datasource.prefix#content".theme ("themeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "navigation_themeID_level_navigation_u" UNIQUE ("themeID", navigation, level),
				CONSTRAINT navigation_max_level CHECK (level < 10),
				CONSTRAINT navigation_min_level CHECK (level > 0)
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".navigation OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".navigation IS 'Theme Navigation availablility';
		</cfquery>
		
		<!--- Path Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".path
			(
				"pathID" uuid NOT NULL,
				"contentID" uuid NOT NULL,
				path character varying(300) not NULL DEFAUlt '/'::character varying,
				title character varying(255) not NULL,
				"groupBy" character varying(100),
				"orderBy" integer not NULL DEFAUlt 0,
				"isActive" bit(1) not NULL,
				"navigationID" uuid,
				"themeID" uuid,
				CONSTRAINT "path_pathID_PK" PRIMARY KEY ("pathID"),
				CONSTRAINT "path_contentID_FK" ForEIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "path_navigationID_FK" ForEIGN KEY ("navigationID")
					REFERENCES "#variables.datasource.prefix#content".navigation ("navigationID") MATCH SIMPLE
					ON UPDATE RESTRICT ON DELETE RESTRICT,
				CONSTRAINT "path_themeID_FK" ForEIGN KEY ("themeID")
					REFERENCES "#variables.datasource.prefix#content".theme ("themeID") MATCH SIMPLE
					ON UPDATE RESTRICT ON DELETE RESTRICT
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".path OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".path IS 'Paths for locating content.';
		</cfquery>
		
		<!--- Permalink Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".permalink
			(
				"permalinkID" uuid NOT NULL,
				"contentID" uuid NOT NULL,
				permalink character varying(100) not NULL,
				CONSTRAINT "permalink_permalinkID_PK" PRIMARY KEY ("permalinkID"),
				CONSTRAINT "permalink_contentID_FK" ForEIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".permalink OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".permalink IS 'Permalink information for content.';
		</cfquery>
		
		<!--- Resource Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".resource
			(
				"resourceID" uuid NOT NULL,
				resource character varying(155) not NULL,
				file character varying(255) not NULL,
				"archivedOn" timestamp without time zone NULL,
				"createdOn" timestamp without time zone not NULL DEFAUlt now(),
				"deprecatedOn" timestamp without time zone NULL,
				"isPublic" boolean not NULL DEFAUlt false,
				CONSTRAINT "resource_resourceID_PK" PRIMARY KEY ("resourceID")
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content".resource OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".resource IS 'Resources administered by the content plugin.';
		</cfquery>
		
		<!--- Host Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."host"
			(
				"hostID" uuid NOT NULL,
				"domainID" uuid NOT NULL,
				hostname character varying(255) not NULL,
				"hasSSL" boolean not NULL DEFAUlt false,
				CONSTRAINT "host_PK" PRIMARY KEY ("hostID"),
				CONSTRAINT "host_domainID_FK" ForEIGN KEY ("domainID")
					REFERENCES "#variables.datasource.prefix#content"."domain" ("domainID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "host_hostname_U" UNIQUE (hostname)
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."host" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."host" IS 'Hosts assigned to a domain.';
		</cfquery>
		
		<!--- Bridge: Content to Attribute Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bContent2Attribute"
			(
				"contentID" uuid NOT NULL,
				"attributeID" uuid NOT NULL,
				"attributeOptionID" uuid,
				"value" character varying(50),
				CONSTRAINT "bContent2Attribute_PK" PRIMARY KEY ("contentID", "attributeID"),
				CONSTRAINT "bContent2Attribute_attributeID_FK" ForEIGN KEY ("attributeID")
					REFERENCES "#variables.datasource.prefix#content".attribute ("attributeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bContent2Attribute_attributeOptionID_FK" ForEIGN KEY ("attributeOptionID")
					REFERENCES "#variables.datasource.prefix#content"."attributeOption" ("attributeOptionID") MATCH SIMPLE
					ON UPDATE SET NULL ON DELETE SET NULL,
				CONSTRAINT "bContent2Attribute_contentID_FK" ForEIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bContent2Attribute" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bContent2Attribute" IS 'Bridge for the content attributes.';
		</cfquery>
		
		<!--- Bridge: Content to Tag Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bContent2Tag"
			(
				"contentID" uuid NOT NULL,
				"tagID" uuid NOT NULL,
				"createdOn" timestamp without time zone not NULL DEFAUlt now(),
				CONSTRAINT "bContent2Tag_PK" PRIMARY KEY ("contentID", "tagID"),
				CONSTRAINT "bContent2Tag_contentID_FK" ForEIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bContent2Tag_tagID_FK" ForEIGN KEY ("tagID")
					REFERENCES "#variables.datasource.prefix#tagger".tag ("tagID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bContent2Tag" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bContent2Tag" IS 'Bridge for attaching tags to content.';
		</cfquery>
		
		<!--- Bridge: Domain to Attribute Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bDomain2Attribute"
			(
				"domainID" uuid NOT NULL,
				"attributeID" uuid NOT NULL,
				"attributeOptionID" uuid,
				"value" character varying(50),
				CONSTRAINT "bDomain2Attribute_PK" PRIMARY KEY ("domainID", "attributeID"),
				CONSTRAINT "bDomain2Attribute_attributeID_FK" ForEIGN KEY ("attributeID")
					REFERENCES "#variables.datasource.prefix#content".attribute ("attributeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bDomain2Attribute_attributeOptionID_FK" ForEIGN KEY ("attributeOptionID")
					REFERENCES "#variables.datasource.prefix#content"."attributeOption" ("attributeOptionID") MATCH SIMPLE
					ON UPDATE SET NULL ON DELETE SET NULL,
				CONSTRAINT "bDomain2Attribute_domainID_FK" ForEIGN KEY ("domainID")
					REFERENCES "#variables.datasource.prefix#content"."domain" ("domainID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bDomain2Attribute" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bDomain2Attribute" IS 'Bridge for domain attributes.';
		</cfquery>
		
		<!--- Bridge: Domain to Tag to User Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bDomain2Tag2User"
			(
				"domainID" uuid NOT NULL,
				"tagID" uuid NOT NULL,
				"userID" uuid NOT NULL,
				"createdOn" timestamp without time zone not NULL DEFAUlt now(),
				CONSTRAINT "bDomain2Tag2User_PK" PRIMARY KEY ("domainID", "tagID", "userID"),
				CONSTRAINT "bDomain2Tag2User_domainID_FK" ForEIGN KEY ("domainID")
					REFERENCES "#variables.datasource.prefix#content"."domain" ("domainID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bDomain2Tag2User_tagID_FK" ForEIGN KEY ("tagID")
					REFERENCES "#variables.datasource.prefix#tagger".tag ("tagID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bDomain2Tag2User_userID_FK" ForEIGN KEY ("userID")
					REFERENCES "#variables.datasource.prefix#user"."user" ("userID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bDomain2Tag2User" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bDomain2Tag2User" IS 'Bridge for tying the domain to tag for a user.';
		</cfquery>
		
		<!--- Bridge: Path to Attribute Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bPath2Attribute"
			(
				"pathID" uuid NOT NULL,
				"attributeID" uuid NOT NULL,
				"attributeOptionID" uuid,
				"value" character varying(50),
				CONSTRAINT "bPath2Attribute_PK" PRIMARY KEY ("pathID", "attributeID"),
				CONSTRAINT "bPath2Attribute_attributeID_FK" ForEIGN KEY ("attributeID")
					REFERENCES "#variables.datasource.prefix#content".attribute ("attributeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bPath2Attribute_attributeOption_FK" ForEIGN KEY ("attributeOptionID")
					REFERENCES "#variables.datasource.prefix#content"."attributeOption" ("attributeOptionID") MATCH SIMPLE
					ON UPDATE SET NULL ON DELETE SET NULL,
				CONSTRAINT "bPath2Attribute_pathID_FK" ForEIGN KEY ("pathID")
					REFERENCES "#variables.datasource.prefix#content".path ("pathID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bPath2Attribute" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bPath2Attribute" IS 'Bridge for the path attributes.';
		</cfquery>
		
		<!--- Bridge: Path to Tag Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bPath2Tag"
			(
				"pathID" uuid NOT NULL,
				"tagID" uuid NOT NULL,
				"isRecursive" boolean not NULL DEFAUlt false,
				"createdOn" timestamp without time zone not NULL DEFAUlt now(),
				CONSTRAINT "bPath2Tag_PK" PRIMARY KEY ("pathID", "tagID"),
				CONSTRAINT "bPath2Tag_pathID_FK" ForEIGN KEY ("pathID")
					REFERENCES "#variables.datasource.prefix#content".path ("pathID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bPath2Tag_tagID_FK" ForEIGN KEY ("tagID")
					REFERENCES "#variables.datasource.prefix#tagger".tag ("tagID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bPath2Tag" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bPath2Tag" IS 'Bridge for attaching tags to paths.';
		</cfquery>
		
		<!--- Bridge: Resource to Content Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bResource2Content"
			(
				"resourceID" uuid NOT NULL,
				"contentID" uuid NOT NULL,
				CONSTRAINT "bResource2Content_PK" PRIMARY KEY ("resourceID", "contentID"),
				CONSTRAINT "bResource2Content_contentID_FK" ForEIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bResource2Content_resourceID_FK" ForEIGN KEY ("resourceID")
					REFERENCES "#variables.datasource.prefix#content".resource ("resourceID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bResource2Content" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bResource2Content" IS 'Bridge for attaching resources to content.';
		</cfquery>
		
		<!--- Bridge: Resource to Domain Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bResource2Domain"
			(
				"domainID" uuid NOT NULL,
				"resourceID" uuid NOT NULL,
				CONSTRAINT "bResource2Domain_PK" PRIMARY KEY ("resourceID", "domainID"),
				CONSTRAINT "bResource2Domain_domainID_FK" ForEIGN KEY ("domainID")
					REFERENCES "#variables.datasource.prefix#content"."domain" ("domainID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bResource2Domain_resourceID_FK" ForEIGN KEY ("resourceID")
					REFERENCES "#variables.datasource.prefix#content".resource ("resourceID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bResource2Domain" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bResource2Domain" IS 'Bridge for attaching resources to domains.';
		</cfquery>
		
		<!--- Bridge: Resource to Theme Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bResource2Theme"
			(
				"resourceID" uuid NOT NULL,
				"themeID" uuid NOT NULL,
				CONSTRAINT "bResource2Theme_PK" PRIMARY KEY ("resourceID", "themeID"),
				CONSTRAINT "bResource2Theme_resourceID_FK" ForEIGN KEY ("resourceID")
					REFERENCES "#variables.datasource.prefix#content".resource ("resourceID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bResource2Theme_themeID_FK" ForEIGN KEY ("themeID")
					REFERENCES "#variables.datasource.prefix#content".theme ("themeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bResource2Theme" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bResource2Theme" IS 'Bridge for attaching resources to themes.';
		</cfquery>
		
		<!--- Bridge: Theme to Domain Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bTheme2Domain"
			(
				"themeID" uuid NOT NULL,
				"domainID" uuid NOT NULL,
				CONSTRAINT "bTheme2Domain_PK" PRIMARY KEY ("themeID", "domainID"),
				CONSTRAINT "bTheme2Domain_domainID_FK" ForEIGN KEY ("domainID")
					REFERENCES "#variables.datasource.prefix#content"."domain" ("domainID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bTheme2Domain_themeID_FK" ForEIGN KEY ("themeID")
					REFERENCES "#variables.datasource.prefix#content".theme ("themeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."bTheme2Domain" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bTheme2Domain" IS 'Bridge for typing the theme to domains.';
		</cfquery>
	</cffunction>
	
	<cffunction name="update" access="public" returntype="void" output="false">
		<cfargument name="plugin" type="struct" required="true" />
		<cfargument name="installedVersion" type="string" default="" />
		
		<cfset var versions = createObject('component', 'algid.inc.resource.utility.version').init() />
		
		<!--- fresh => 0.1.0 --->
		<cfif versions.compareVersions(arguments.installedVersion, '0.1.0') lt 0>
			<!--- Setup the Database --->
			<cfswitch expression="#variables.datasource.type#">
				<cfcase value="PostgreSQL">
					<cfset postgreSQL0_1_0() />
				</cfcase>
				<cfdefaultcase>
					<!--- TODO Remove this thow when a later version supports more database types  --->
					<cfthrow message="Database Type Not Supported" detail="The #variables.datasource.type# database type is not currently supported" />
				</cfdefaultcase>
			</cfswitch>
		</cfif>
	</cffunction>
</cfcomponent>