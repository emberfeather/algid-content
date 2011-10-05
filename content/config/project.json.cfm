{
	"applicationSingletons": {
		"pathForContent": "plugins.content.inc.resource.utility.path"
	},
	"applicationTransients": {
		"cacheContentForContent": "cf-compendium.inc.resource.storage.cache",
		"cacheNavigationForContent": "cf-compendium.inc.resource.storage.cache",
		"formElementForContent": "plugins.content.inc.resource.structure.form.content",
		"navigationForContent": "plugins.content.inc.resource.structure.navigation",
		"sitemapForContent": "cf-compendium.inc.resource.utility.sitemap",
		"pathValidatorForContent": "plugins.content.inc.resource.validation.path",
		"templateForContent": "plugins.content.inc.resource.structure.template"
	},
	"caches": {
		"content": "",
		"navigation": ""
	},
	"defaultTheme": "content/extend/content/theme/content",
	"domains": {
		"staticRoot": "/static"
	},
	"i18n": {
		"locales": [
			"en_PI",
			"en_US"
		]
	},
	"key": "content",
	"path": "",
	"plugin": "Content",
	"prerequisites": {
		"api": "0.1.1",
		"algid": "0.1.3",
		"parser": "0.1.0",
		"tagger": "0.1.1",
		"user": "0.1.1"
	},
	"requestSingletons": {
	},
	"requestTransients": {
	},
	"rewrite": {
		"isEnabled": false,
		"base": "_base"
	},
	"sessionSingletons": {
	},
	"sessionTransients": {
	},
	"version": "0.1.14"
}