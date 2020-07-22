component extends="coldbox.system.testing.BaseTestCase" {

	variables.targetEngine = getUtil().getSystemSetting( "ENGINE", "localhost" );
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
						src         : "+12013503434",
						dst         : "+919099023644",
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
