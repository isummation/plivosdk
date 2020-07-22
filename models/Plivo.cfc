/**
 *
 * Plivo Rest Wrapper for Messaging
 *
 * Written by Pritesh Patel (pritesh@isummation.com)
 * You will have to create some settings in your ColdBox configuration file:
 * Plivo_authId : Plivo Auth Id
 * Plivo_authToken : Plivo Auth Token
 */
component accessors="true" singleton {

	// Properties
	property name="authid";
	property name="authToken";

	/**
	 * Create a new Plivo Instance
	 *
	 * @authid The Plivo Auth ID.
	 * @authToken The Plivo Auth Token.
	 *
	 * @return An Plivo instance.
	 */
	Plivo function init( required string authid, required string authToken ){
		variables.authid    = arguments.authid;
		variables.authToken = arguments.authToken;

		return this;
	}
	/**
	 * Send SMS
	 *
	 * @src Sender Id, can be short code, mobile number.
	 * @dst Se this parameter to the phone number to which the message is to be delivered.
	 * @message Text message to be send
	 * @callbackURL Fully qualified url to which status update callbacks for message should sent.
	 * @method callbackURL http method, Prefer POST
	 * @log set to true if want to log message on plivo
	 * @trackable Set this message to true if messages that have trackable user action.
	 */
	function sendSMS(
		required string src,
		required string dst,
		required string message,
		string callbackURL,
		string method     = "GET",
		boolean log       = false,
		boolean trackable = false
	){
		var plivoBody = {
			"src"       : arguments.src,
			"dst"       : arguments.dst,
			"text"      : arguments.message,
			"type"      : "sms",
			"log"       : arguments.log,
			"trackable" : arguments.trackable
		};
		if ( structKeyExists( arguments, "callbackURL" ) ) {
			plivoBody[ "url" ]    = arguments.callbackURL;
			plivoBody[ "method" ] = arguments.method;
		}

		return plivoRequest(
			method   = "POST",
			resource = "Message",
			body     = serializeJSON( plivoBody )
		);
	}


	/**
	 * Make a request to Plivo.
	 *
	 * @method     The HTTP method for the request.
	 * @resource   Plivo API resource.
	 * @body       The body content of the request, if passed.
	 * @headers    A struct of HTTP headers to send.
	 * @parameters A struct of HTTP URL parameters to send.
	 * @timeout    The default CFHTTP timeout.
	 * @throwOnError Flag to throw exceptions on any error or not, default is true
	 *
	 * @return     The response information.
	 */
	private struct function plivoRequest(
		string method        = "GET",
		string resource      = "Message",
		any body             = "",
		struct headers       = {},
		struct parameters    = {},
		numeric timeout      = 20,
		boolean throwOnError = true
	){
		var results = {
			"error"          : false,
			"response"       : {},
			"message"        : "",
			"responseheader" : {}
		};
		var httpResults = "";

		// Default Content Type
		if ( NOT structKeyExists( arguments.headers, "content-type" ) ) {
			arguments.headers[ "Content-Type" ] = "application/json";
		}
		arguments.headers[ "Authorization" ] = "Basic #toBase64( variables.authid & ":" & variables.authToken )#";

		cfhttp(
			method    = arguments.method,
			url       = "https://api.plivo.com/v1/Account/#variables.authid#/#arguments.resource#/",
			charset   = "utf-8",
			result    = "httpResults",
			redirect  = true,
			timeout   = arguments.timeout,
			useragent = "ColdFusion-Plivo"
		) {
			for ( var headerName in arguments.headers ) {
				cfhttpparam(
					type  = "header",
					name  = headerName,
					value = arguments.headers[ headerName ]
				);
			}

			for ( var paramName in arguments.parameters ) {
				cfhttpparam(
					type  = "URL",
					name  = paramName,
					value = arguments.parameters[ headerName ]
				);
			}

			if ( len( arguments.body ) ) {
				cfhttpparam( type = "body", value = arguments.body );
			}
		}

		results.response       = deserializeJSON( HTTPResults.fileContent );
		results.responseHeader = HTTPResults.responseHeader;

		results.message = HTTPResults.errorDetail;
		if ( len( HTTPResults.errorDetail ) && HTTPResults.errorDetail neq "302 Found" ) {
			results.error = true;
		}
		if ( results.error && arguments.throwOnError ) {
			throw(
				type    = "PlivoError",
				message = "Error making Plivo API: #results.message#",
				detail  = serializeJSON( results.response )
			);
		}

		return results;
	}

}
