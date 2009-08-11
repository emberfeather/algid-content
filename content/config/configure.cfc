<cfcomponent extends="cf-compendium.inc.resource.application.configure" output="false">
	<cffunction name="update" access="public" returntype="void" output="false">
		<cfargument name="plugin" type="struct" required="true" />
		<cfargument name="installedVersion" type="string" default="" />
		
		<!--- fresh => 0.1.000 --->
		<cfif arguments.installedVersion EQ ''>
			<!--- Setup the Database --->
			<cfswitch expression="#variables.datasource.type#">
				<cfcase value="PostgreSQL">
					<cfset postgreSQL0_1_000() />
				</cfcase>
				<cfdefaultcase>
					<!--- TODO Remove this thow when a later version supports more database types  --->
					<cfthrow message="Database Type Not Supported" detail="The #variables.datasource.type# database type is not currently supported" />
				</cfdefaultcase>
			</cfswitch>
		</cfif>
	</cffunction>
	
	<!---
		Configures the database for v0.1.000
	--->
	<cffunction name="postgreSQL0_1_000" access="public" returntype="void" output="false">
		<!---
			SCHEMA
		--->
		
		<!--- Content Schema --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SCHEMA "#variables.datasource.prefix#content"
				AUTHORIZATION #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON SCHEMA "#variables.datasource.prefix#content" IS 'Content Plugin Schema';
		</cfquery>
		
		<!---
			SEQUENCES
		--->
		
		<!--- Attribute Option Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SEQUENCE "#variables.datasource.prefix#content"."attributeOption_attributeOptionID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."attributeOption_attributeOptionID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Attribute Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SEQUENCE "#variables.datasource.prefix#content"."attribute_attributeID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."attribute_attributeID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Content Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SEQUENCE "#variables.datasource.prefix#content"."content_contentID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."content_contentID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Domain Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SEQUENCE "#variables.datasource.prefix#content"."domain_domainID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."domain_domainID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Meta Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SEQUENCE "#variables.datasource.prefix#content"."meta_metaID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."meta_metaID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Navigation Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SEQUENCE "#variables.datasource.prefix#content"."navigation_navigationID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."navigation_navigationID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Path Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SEQUENCE "#variables.datasource.prefix#content"."path_pathID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."path_pathID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Permalink Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SEQUENCE "#variables.datasource.prefix#content"."permalink_permalinkID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."permalink_permalinkID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Resource Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SEQUENCE "#variables.datasource.prefix#content"."resource_resourceID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."resource_resourceID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Theme Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SEQUENCE "#variables.datasource.prefix#content"."theme_themeID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."theme_themeID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!--- Type Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SEQUENCE "#variables.datasource.prefix#content"."type_typeID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#content"."type_typeID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!---
			TABLES
		--->
		
		<!--- Domain Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."domain"
			(
				"domainID" integer NOT NULL DEFAULT nextval('#variables.datasource.prefix#content."domain_domainID_seq"'::regclass),
				"domain" character varying(150) NOT NULL,
				"createdOn" timestamp without time zone NOT NULL DEFAULT now(),
				CONSTRAINT "domain_domainID_PK" PRIMARY KEY ("domainID")
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
				"themeID" integer NOT NULL DEFAULT nextval('#variables.datasource.prefix#content."theme_themeID_seq"'::regclass),
				theme character varying(50) NOT NULL,
				directory character varying(50) NOT NULL,
				levels smallint NOT NULL DEFAULT 1,
				"isPublic" bit(1) NOT NULL DEFAULT B'1'::"bit",
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
				"typeID" integer NOT NULL DEFAULT nextval('#variables.datasource.prefix#content."type_typeID_seq"'::regclass),
				"type" character varying(50) NOT NULL,
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
				"attributeID" integer NOT NULL DEFAULT nextval('#variables.datasource.prefix#content."attribute_attributeID_seq"'::regclass),
				"themeID" integer NOT NULL,
				attribute character varying(100) NOT NULL,
				"key" character varying(25) NOT NULL,
				"hasCustom" bit(1) NOT NULL DEFAULT B'1'::"bit",
				CONSTRAINT "attribute_PK" PRIMARY KEY ("attributeID"),
				CONSTRAINT "attribute_themeID_FK" FOREIGN KEY ("themeID")
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
				"attributeOptionID" integer NOT NULL DEFAULT nextval('#variables.datasource.prefix#content."attributeOption_attributeOptionID_seq"'::regclass),
				"attributeID" integer NOT NULL,
				label character varying(100) NOT NULL,
				"value" character varying(50) NOT NULL,
				CONSTRAINT "attributeOption_PK" PRIMARY KEY ("attributeOptionID"),
				CONSTRAINT "attributeOption_optionID_FK" FOREIGN KEY ("attributeID")
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
				"contentID" integer NOT NULL DEFAULT nextval('#variables.datasource.prefix#content."content_contentID_seq"'::regclass),
				"domainID" integer NOT NULL,
				"typeID" integer NOT NULL,
				title character varying(255) NOT NULL,
				"content" text NOT NULL,
				"createdOn" timestamp without time zone NOT NULL DEFAULT now(),
				"updatedBy" integer NOT NULL,
				"updatedOn" timestamp without time zone NOT NULL DEFAULT now(),
				"archivedOn" timestamp without time zone,
				CONSTRAINT "content_content_PK" PRIMARY KEY ("contentID"),
				CONSTRAINT "content_domainID_FK" FOREIGN KEY ("domainID")
					REFERENCES "#variables.datasource.prefix#content"."domain" ("domainID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "content_typeID_FK" FOREIGN KEY ("typeID")
					REFERENCES "#variables.datasource.prefix#content"."type" ("typeID") MATCH SIMPLE
					ON UPDATE NO ACTION ON DELETE NO ACTION,
				CONSTRAINT "content_updatedBy_FK" FOREIGN KEY ("updatedBy")
					REFERENCES "#variables.datasource.prefix#user"."user" ("userID") MATCH SIMPLE
					ON UPDATE RESTRICT ON DELETE RESTRICT
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
				"contentID" integer NOT NULL,
				"createdOn" timestamp without time zone NOT NULL DEFAULT now(),
				draft text NOT NULL,
				"publishOn" timestamp without time zone,
				"updatedBy" integer NOT NULL,
				"updatedOn" timestamp without time zone NOT NULL DEFAULT now(),
				CONSTRAINT "draft_PK" PRIMARY KEY ("contentID", "createdOn"),
				CONSTRAINT "draft_contentID_FK" FOREIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "draft_updatedBy_FJ" FOREIGN KEY ("updatedBy")
					REFERENCES "#variables.datasource.prefix#user"."user" ("userID") MATCH SIMPLE
					ON UPDATE RESTRICT ON DELETE RESTRICT
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
				"metaID" integer NOT NULL DEFAULT nextval('#variables.datasource.prefix#content."meta_metaID_seq"'::regclass),
				"contentID" integer NOT NULL,
				"name" character varying(35) NOT NULL,
				"value" text NOT NULL,
				CONSTRAINT "meta_PK" PRIMARY KEY ("metaID"),
				CONSTRAINT "meta_contentID_FK" FOREIGN KEY ("contentID")
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
				"navigationID" integer NOT NULL DEFAULT nextval('#variables.datasource.prefix#content."navigation_navigationID_seq"'::regclass),
				"level" smallint NOT NULL,
				navigation character varying(50) NOT NULL,
				"themeID" integer NOT NULL,
				"allowGroups" bit(1) NOT NULL DEFAULT B'1'::"bit",
				CONSTRAINT "navigation_PK" PRIMARY KEY ("navigationID"),
				CONSTRAINT "navigation_themeID_FK" FOREIGN KEY ("themeID")
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
				"pathID" integer NOT NULL DEFAULT nextval('#variables.datasource.prefix#content."path_pathID_seq"'::regclass),
				"contentID" integer NOT NULL,
				path character varying(300) NOT NULL DEFAULT '/'::character varying,
				title character varying(255) NOT NULL,
				"groupBy" character varying(100),
				"orderBy" integer NOT NULL DEFAULT 0,
				"isActive" bit(1) NOT NULL,
				"navigationID" integer,
				"themeID" integer,
				CONSTRAINT "path_pathID_PK" PRIMARY KEY ("pathID"),
				CONSTRAINT "path_contentID_FK" FOREIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "path_navigationID_FK" FOREIGN KEY ("navigationID")
					REFERENCES "#variables.datasource.prefix#content".navigation ("navigationID") MATCH SIMPLE
					ON UPDATE RESTRICT ON DELETE RESTRICT,
				CONSTRAINT "path_themeID_FK" FOREIGN KEY ("themeID")
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
				"permalinkID" integer NOT NULL DEFAULT nextval('#variables.datasource.prefix#content."permalink_permalinkID_seq"'::regclass),
				"contentID" integer NOT NULL,
				permalink character varying(100) NOT NULL,
				CONSTRAINT "permalink_permalinkID_PK" PRIMARY KEY ("permalinkID"),
				CONSTRAINT "permalink_contentID_FK" FOREIGN KEY ("contentID")
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
				"resourceID" integer NOT NULL DEFAULT nextval('#variables.datasource.prefix#content."resource_resourceID_seq"'::regclass),
				resource character varying(155) NOT NULL,
				file character varying(255) NOT NULL,
				"createdOn" timestamp without time zone NOT NULL DEFAULT now(),
				"isDeprecated" bit(1) NOT NULL DEFAULT B'0'::"bit",
				"isPublic" bit(1) NOT NULL DEFAULT B'0'::"bit",
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
		
		<!--- Bridge: Content to Attribute Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#content"."bContent2Attribute"
			(
				"contentID" integer NOT NULL,
				"attributeID" integer NOT NULL,
				"attributeOptionID" integer,
				"value" character varying(50),
				CONSTRAINT "bContent2Attribute_PK" PRIMARY KEY ("contentID", "attributeID"),
				CONSTRAINT "bContent2Attribute_attributeID_FK" FOREIGN KEY ("attributeID")
					REFERENCES "#variables.datasource.prefix#content".attribute ("attributeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bContent2Attribute_attributeOptionID_FK" FOREIGN KEY ("attributeOptionID")
					REFERENCES "#variables.datasource.prefix#content"."attributeOption" ("attributeOptionID") MATCH SIMPLE
					ON UPDATE SET NULL ON DELETE SET NULL,
				CONSTRAINT "bContent2Attribute_contentID_FK" FOREIGN KEY ("contentID")
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
				"contentID" integer NOT NULL,
				"tagID" integer NOT NULL,
				"createdOn" timestamp without time zone NOT NULL DEFAULT now(),
				CONSTRAINT "bContent2Tag_PK" PRIMARY KEY ("contentID", "tagID"),
				CONSTRAINT "bContent2Tag_contentID_FK" FOREIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bContent2Tag_tagID_FK" FOREIGN KEY ("tagID")
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
				"domainID" integer NOT NULL,
				"attributeID" integer NOT NULL,
				"attributeOptionID" integer,
				"value" character varying(50),
				CONSTRAINT "bDomain2Attribute_PK" PRIMARY KEY ("domainID", "attributeID"),
				CONSTRAINT "bDomain2Attribute_attributeID_FK" FOREIGN KEY ("attributeID")
					REFERENCES "#variables.datasource.prefix#content".attribute ("attributeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bDomain2Attribute_attributeOptionID_FK" FOREIGN KEY ("attributeOptionID")
					REFERENCES "#variables.datasource.prefix#content"."attributeOption" ("attributeOptionID") MATCH SIMPLE
					ON UPDATE SET NULL ON DELETE SET NULL,
				CONSTRAINT "bDomain2Attribute_domainID_FK" FOREIGN KEY ("domainID")
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
				"domainID" integer NOT NULL,
				"tagID" integer NOT NULL,
				"userID" integer NOT NULL,
				"createdOn" timestamp without time zone NOT NULL DEFAULT now(),
				CONSTRAINT "bDomain2Tag2User_PK" PRIMARY KEY ("domainID", "tagID", "userID"),
				CONSTRAINT "bDomain2Tag2User_domainID_FK" FOREIGN KEY ("domainID")
					REFERENCES "#variables.datasource.prefix#content"."domain" ("domainID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bDomain2Tag2User_tagID_FK" FOREIGN KEY ("tagID")
					REFERENCES "#variables.datasource.prefix#tagger".tag ("tagID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bDomain2Tag2User_userID_FK" FOREIGN KEY ("userID")
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
				"pathID" integer NOT NULL,
				"attributeID" integer NOT NULL,
				"attributeOptionID" integer,
				"value" character varying(50),
				CONSTRAINT "bPath2Attribute_PK" PRIMARY KEY ("pathID", "attributeID"),
				CONSTRAINT "bPath2Attribute_attributeID_FK" FOREIGN KEY ("attributeID")
					REFERENCES "#variables.datasource.prefix#content".attribute ("attributeID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bPath2Attribute_attributeOption_FK" FOREIGN KEY ("attributeOptionID")
					REFERENCES "#variables.datasource.prefix#content"."attributeOption" ("attributeOptionID") MATCH SIMPLE
					ON UPDATE SET NULL ON DELETE SET NULL,
				CONSTRAINT "bPath2Attribute_pathID_FK" FOREIGN KEY ("pathID")
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
				"pathID" integer NOT NULL,
				"tagID" integer NOT NULL,
				"createdOn" timestamp without time zone NOT NULL DEFAULT now(),
				CONSTRAINT "bPath2Tag_PK" PRIMARY KEY ("pathID", "tagID"),
				CONSTRAINT "bPath2Tag_pathID_FK" FOREIGN KEY ("pathID")
					REFERENCES "#variables.datasource.prefix#content".path ("pathID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bPath2Tag_tagID_FK" FOREIGN KEY ("tagID")
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
				"resourceID" integer NOT NULL,
				"contentID" integer NOT NULL,
				CONSTRAINT "bResource2Content_PK" PRIMARY KEY ("resourceID", "contentID"),
				CONSTRAINT "bResource2Content_contentID_FK" FOREIGN KEY ("contentID")
					REFERENCES "#variables.datasource.prefix#content"."content" ("contentID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bResource2Content_resourceID_FK" FOREIGN KEY ("resourceID")
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
				"domainID" integer NOT NULL,
				"resourceID" integer NOT NULL,
				CONSTRAINT "bResource2Domain_PK" PRIMARY KEY ("resourceID", "domainID"),
				CONSTRAINT "bResource2Domain_domainID_FK" FOREIGN KEY ("domainID")
					REFERENCES "#variables.datasource.prefix#content"."domain" ("domainID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bResource2Domain_resourceID_FK" FOREIGN KEY ("resourceID")
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
				"resourceID" integer NOT NULL,
				"themeID" integer NOT NULL,
				CONSTRAINT "bResource2Theme_PK" PRIMARY KEY ("resourceID", "themeID"),
				CONSTRAINT "bResource2Theme_resourceID_FK" FOREIGN KEY ("resourceID")
					REFERENCES "#variables.datasource.prefix#content".resource ("resourceID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bResource2Theme_themeID_FK" FOREIGN KEY ("themeID")
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
				"themeID" integer NOT NULL,
				"domainID" integer NOT NULL,
				CONSTRAINT "bTheme2Domain_PK" PRIMARY KEY ("themeID", "domainID"),
				CONSTRAINT "bTheme2Domain_domainID_FK" FOREIGN KEY ("domainID")
					REFERENCES "#variables.datasource.prefix#content"."domain" ("domainID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE,
				CONSTRAINT "bTheme2Domain_themeID_FK" FOREIGN KEY ("themeID")
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
</cfcomponent>