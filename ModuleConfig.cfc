/**
 * Copyright iSummation technologies Pvt. Ltd.
 * www.isummation.com
 * ---
 * This module connects your application to Plivo
 **/
component {

	// Module Properties
	this.title              = "Plivo API Wrapper";
	this.author             = "iSummation Technologies Pvt. Ltd";
	this.webURL             = "https://www.isummation.com";
	this.description        = "This SDK will provide you with Plivo connectivity for any ColdFusion (CFML) application.";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup   = true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	this.autoMapModels      = false;
	this.modelNamespace     = "plivosdk";
	// CF Mapping
	this.cfmapping          = "plivosdk";
	/**
	 * Configure
	 */
	function configure(){
		// Settings
		variables.settings = { authid : "", authToken : "" };
	}

	/**
	 * Fired when the module is registered and activated.
	 */
	function onLoad(){
		binder
			.map( "plivo@plivosdk" )
			.to( "#moduleMapping#.models.Plivo" )
			.initArg( name = "authid", value = variables.settings.authid )
			.initArg( name = "authToken", value = variables.settings.authToken );
	}

	/**
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload(){
	}

}
