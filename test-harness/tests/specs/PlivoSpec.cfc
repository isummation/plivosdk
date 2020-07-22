component extends="coldbox.system.testing.BaseTestCase" {

	variables.targetEngine = getUtil().getSystemSetting( "ENGINE", "localhost" );
	variables.senderNo = getUtil().getSystemSetting( "SENDERNO" );
	variables.receiverNo = getUtil().getSystemSetting( "RECEIVERNO" );
	function beforeAll(){
		variables.plivo = new plivosdk.models.plivo(
			getUtil().getSystemSetting( "AUTHID" ),
			getUtil().getSystemSetting( "AUTHTOKEN" )
		);
		prepareMock( plivo );
		plivo.$property( propertyName = "log", mock = createLogStub() );
	}

	function afterAll(){
	}

	private function isOldACF(){
		return listFind( "11,2016", listFirst( server.coldfusion.productVersion ) );
	}

	function run(){
		describe( "Plivo SDK", function(){
			describe( "objects", function(){
				afterEach( function( currentSpec ){
				} );

				it( "Send SMS", function(){
					var args = {
						src         : "#variables.senderNo#",
						dst         : "#variables.receiverNo#",
						message     : "Hello this is test",
						callbackURL : "https://t.local.fearticket.com/"
					};
					var md = plivo.sendSMS( argumentCollection = args );
					debug( md );
					expect( md ).notToBeEmpty();
				} );
			} );
		} );
	}

	private function createLogStub(){
		return createStub()
			.$( "canDebug", false )
			.$( "debug" )
			.$( "error" );
	}

}
