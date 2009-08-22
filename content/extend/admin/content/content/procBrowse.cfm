<cfset i18n = application.managers.singleton.getI18N() />

<cfset servContent = createObject('component', 'plugins.content.inc.service.servContent').init(application.settings.datasources.update, i18n, SESSION.locale) />