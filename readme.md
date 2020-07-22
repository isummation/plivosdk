# Welcome to the Plivo SDK

This SDK allows you to SMS using Plivo to your ColdFusion (CFML) applications. It is also a ColdBox Module, so if you are using ColdBox, you get auto-registration and much more.

## Installation

Download source and place it into your modules folder of Coldbox or Standalone Project.

### Standalone

This SDK will be installed into a directory called `plivosdk` and then the SDK can be instantiated via `new plivosdk.models.Plivo()` with the following constructor arguments:

```js
/**
 * Create a new Plivo Instance
 *
 * @authid The Plivo Auth ID.
 * @authToken The Plivo Auth Token.
 *
 * @return An Plivo instance.
 */
Plivo function init(
	required string authid,
	required string authToken
){
	variables.authid          = arguments.authid;
	variables.authToken       = arguments.authToken;

	return this;
}
```

### ColdBox Module

This package also is a ColdBox module as well. The module can be configured by creating an `plivosdk` configuration structure in your `moduleSettings` struct in the application configuration file: `config/Coldbox.cfc` with the following settings:

```js
moduleSettings = {
	plivosdk = {
		// Your plivo authId
		authid = "",
		// Your plivo authToken
		authToken = "",
	}
};
```

Then you can leverage the SDK CFC via the injection DSL: `Plivo@plivosdk`
