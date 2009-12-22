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
			<cfset temp = arguments.theApplication.factories.transient.getProfiler(arguments.theApplication.managers.singleton.getApplication().getEnvironment() neq 'production') />
			
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
			SeqUENCES
		--->
		
		<!--- Attribute Option Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SeqUENCE "#variables.datasource.prefix#content"."attributeOption_attributeOptionID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#content"."attributeOption_attributeOptionID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Attribute Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SeqUENCE "#variables.datasource.prefix#content"."attribute_attributeID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#content"."attribute_attributeID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Content Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SeqUENCE "#variables.datasource.prefix#content"."content_contentID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#content"."content_contentID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Domain Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SeqUENCE "#variables.datasource.prefix#content"."domain_domainID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#content"."domain_domainID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Meta Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SeqUENCE "#variables.datasource.prefix#content"."meta_metaID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#content"."meta_metaID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Navigation Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SeqUENCE "#variables.datasource.prefix#content"."navigation_navigationID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#content"."navigation_navigationID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Path Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SeqUENCE "#variables.datasource.prefix#content"."path_pathID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#content"."path_pathID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Permalink Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SeqUENCE "#variables.datasource.prefix#content"."permalink_permalinkID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#content"."permalink_permalinkID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Resource Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SeqUENCE "#variables.datasource.prefix#content"."resource_resourceID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#content"."resource_resourceID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Theme Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SeqUENCE "#variables.datasource.prefix#content"."theme_themeID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#content"."theme_themeID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Type Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SeqUENCE "#variables.datasource.prefix#content"."type_typeID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#content"."type_typeID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!---
			TABLES
		--->
		
		<!--- Domain Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."domain"
			(
				"domainID" integer not NULL DEFAUlt nextval('#variables.datasource.prefix#content."domain_domainID_seq"'::regclass),
				"domain" character varying(150) not NULL,
				"createdOn" timestamp without time zone not NULL DEFAUlt now(),
				"archivedOn" timestamp without time zone,
				CONSTRAINT "domain_domainID_PK" PRIMARY KEY ("domainID"),
				CONSTRAINT "domain_domain_U" UNIQUE (domain)
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#content"."domain" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."domain" IS 'Domains being administered by the content plugin.';
		</cfquery>
		
		<!--- Theme Table --->
		<!--- Required for Attribute Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".theme
			(
				"themeID" integer not NULL DEFAUlt nextval('#variables.datasource.prefix#content."theme_themeID_seq"'::regclass),
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
			AlteR TABLE "#variables.datasource.prefix#content".theme OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".theme IS 'Themes in use with the content plugin.';
		</cfquery>
		
		<!--- Type Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."type"
			(
				"typeID" integer not NULL DEFAUlt nextval('#variables.datasource.prefix#content."type_typeID_seq"'::regclass),
				"type" character varying(50) not NULL,
				CONSTRAINT "type_PK" PRIMARY KEY ("typeID")
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#content"."type" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."type" IS 'Type of content available in the content plugin.';
		</cfquery>
		
		<!--- Attribute Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".attribute
			(
				"attributeID" integer not NULL DEFAUlt nextval('#variables.datasource.prefix#content."attribute_attributeID_seq"'::regclass),
				"themeID" integer not NULL,
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
			AlteR TABLE "#variables.datasource.prefix#content".attribute OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".attribute IS 'Theme attributes for manipulating the display of the content.';
		</cfquery>
		
		<!--- Attribute Option Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."attributeOption"
			(
				"attributeOptionID" integer not NULL DEFAUlt nextval('#variables.datasource.prefix#content."attributeOption_attributeOptionID_seq"'::regclass),
				"attributeID" integer not NULL,
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
			AlteR TABLE "#variables.datasource.prefix#content"."attributeOption" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."attributeOption" IS 'Theme attribute options to allow the user to choose a predefined attribute value.';
		</cfquery>
		
		<!--- Content Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."content"
			(
				"contentID" integer not NULL DEFAUlt nextval('#variables.datasource.prefix#content."content_contentID_seq"'::regclass),
				"domainID" integer not NULL,
				"typeID" integer not NULL,
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
			AlteR TABLE "#variables.datasource.prefix#content"."content" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."content" IS 'Content for the content plugin.';
		</cfquery>
		
		<!--- Draft Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".draft
			(
				"contentID" integer not NULL,
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
			AlteR TABLE "#variables.datasource.prefix#content".draft OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".draft IS 'Content drafts information for unpublished content.';
		</cfquery>
		
		<!--- Meta Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".meta
			(
				"metaID" integer not NULL DEFAUlt nextval('#variables.datasource.prefix#content."meta_metaID_seq"'::regclass),
				"contentID" integer not NULL,
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
			AlteR TABLE "#variables.datasource.prefix#content".meta OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".meta IS 'Meta information associated with the content.';
		</cfquery>
		
		<!--- Navigation Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".navigation
			(
				"navigationID" integer not NULL DEFAUlt nextval('#variables.datasource.prefix#content."navigation_navigationID_seq"'::regclass),
				"level" smallint not NULL,
				navigation character varying(50) not NULL,
				"themeID" integer not NULL,
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
			AlteR TABLE "#variables.datasource.prefix#content".navigation OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".navigation IS 'Theme Navigation availablility';
		</cfquery>
		
		<!--- Path Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".path
			(
				"pathID" integer not NULL DEFAUlt nextval('#variables.datasource.prefix#content."path_pathID_seq"'::regclass),
				"contentID" integer not NULL,
				path character varying(300) not NULL DEFAUlt '/'::character varying,
				title character varying(255) not NULL,
				"groupBy" character varying(100),
				"orderBy" integer not NULL DEFAUlt 0,
				"isActive" bit(1) not NULL,
				"navigationID" integer,
				"themeID" integer,
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
			AlteR TABLE "#variables.datasource.prefix#content".path OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".path IS 'Paths for locating content.';
		</cfquery>
		
		<!--- Permalink Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".permalink
			(
				"permalinkID" integer not NULL DEFAUlt nextval('#variables.datasource.prefix#content."permalink_permalinkID_seq"'::regclass),
				"contentID" integer not NULL,
				permalink character varying(100) not NULL,
				CONSTRAINT "permalink_permalinkID_PK" PRIMARY KEY ("permalinkID"),
				CONSTRAINT "permalink_contentID_FK" ForEIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#content".permalink OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".permalink IS 'Permalink information for content.';
		</cfquery>
		
		<!--- Resource Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content".resource
			(
				"resourceID" integer not NULL DEFAUlt nextval('#variables.datasource.prefix#content."resource_resourceID_seq"'::regclass),
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
			AlteR TABLE "#variables.datasource.prefix#content".resource OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content".resource IS 'Resources administered by the content plugin.';
		</cfquery>
		
		<!--- Bridge: Content to Attribute Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bContent2Attribute"
			(
				"contentID" integer not NULL,
				"attributeID" integer not NULL,
				"attributeOptionID" integer,
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
			AlteR TABLE "#variables.datasource.prefix#content"."bContent2Attribute" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bContent2Attribute" IS 'Bridge for the content attributes.';
		</cfquery>
		
		<!--- Bridge: Content to Tag Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bContent2Tag"
			(
				"contentID" integer not NULL,
				"tagID" integer not NULL,
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
			AlteR TABLE "#variables.datasource.prefix#content"."bContent2Tag" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bContent2Tag" IS 'Bridge for attaching tags to content.';
		</cfquery>
		
		<!--- Bridge: Domain to Attribute Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bDomain2Attribute"
			(
				"domainID" integer not NULL,
				"attributeID" integer not NULL,
				"attributeOptionID" integer,
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
			AlteR TABLE "#variables.datasource.prefix#content"."bDomain2Attribute" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bDomain2Attribute" IS 'Bridge for domain attributes.';
		</cfquery>
		
		<!--- Bridge: Domain to Tag to User Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bDomain2Tag2User"
			(
				"domainID" integer not NULL,
				"tagID" integer not NULL,
				"userID" integer not NULL,
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
			AlteR TABLE "#variables.datasource.prefix#content"."bDomain2Tag2User" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bDomain2Tag2User" IS 'Bridge for tying the domain to tag for a user.';
		</cfquery>
		
		<!--- Bridge: Path to Attribute Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bPath2Attribute"
			(
				"pathID" integer not NULL,
				"attributeID" integer not NULL,
				"attributeOptionID" integer,
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
			AlteR TABLE "#variables.datasource.prefix#content"."bPath2Attribute" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bPath2Attribute" IS 'Bridge for the path attributes.';
		</cfquery>
		
		<!--- Bridge: Path to Tag Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bPath2Tag"
			(
				"pathID" integer not NULL,
				"tagID" integer not NULL,
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
			AlteR TABLE "#variables.datasource.prefix#content"."bPath2Tag" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bPath2Tag" IS 'Bridge for attaching tags to paths.';
		</cfquery>
		
		<!--- Bridge: Resource to Content Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bResource2Content"
			(
				"resourceID" integer not NULL,
				"contentID" integer not NULL,
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
			AlteR TABLE "#variables.datasource.prefix#content"."bResource2Content" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bResource2Content" IS 'Bridge for attaching resources to content.';
		</cfquery>
		
		<!--- Bridge: Resource to Domain Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bResource2Domain"
			(
				"domainID" integer not NULL,
				"resourceID" integer not NULL,
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
			AlteR TABLE "#variables.datasource.prefix#content"."bResource2Domain" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bResource2Domain" IS 'Bridge for attaching resources to domains.';
		</cfquery>
		
		<!--- Bridge: Resource to Theme Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bResource2Theme"
			(
				"resourceID" integer not NULL,
				"themeID" integer not NULL,
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
			AlteR TABLE "#variables.datasource.prefix#content"."bResource2Theme" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bResource2Theme" IS 'Bridge for attaching resources to themes.';
		</cfquery>
		
		<!--- Bridge: Theme to Domain Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bTheme2Domain"
			(
				"themeID" integer not NULL,
				"domainID" integer not NULL,
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
			AlteR TABLE "#variables.datasource.prefix#content"."bTheme2Domain" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."bTheme2Domain" IS 'Bridge for typing the theme to domains.';
		</cfquery>
	</cffunction>
	
	<!---
		Configures the database for v0.1.1
	--->
	<cffunction name="postgreSQL0_1_1" access="public" returntype="void" output="false">
		<!---
			SeqUENCES
		--->
		
		<!--- Attribute Option Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SeqUENCE "#variables.datasource.prefix#content"."host_hostID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#content"."host_hostID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!---
			TABLES
		--->
		
		<!--- Host Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."host"
			(
				"hostID" integer not NULL DEFAUlt nextval('#variables.datasource.prefix#content."host_hostID_seq"'::regclass),
				"domainID" integer not NULL,
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
			AlteR TABLE "#variables.datasource.prefix#content"."host" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#content"."host" IS 'Hosts assigned to a domain.';
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
		
		<!--- => 0.1.0 --->
		<cfif versions.compareVersions(arguments.installedVersion, '0.1.1') lt 0>
			<!--- Setup the Database --->
			<cfswitch expression="#variables.datasource.type#">
				<cfcase value="PostgreSQL">
					<cfset postgreSQL0_1_1() />
				</cfcase>
				<cfdefaultcase>
					<!--- TODO Remove this thow when a later version supports more database types  --->
					<cfthrow message="Database Type Not Supported" detail="The #variables.datasource.type# database type is not currently supported" />
				</cfdefaultcase>
			</cfswitch>
		</cfif>
	</cffunction>
</cfcomponent>