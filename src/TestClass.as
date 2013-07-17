package
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class TestClass
	{
		/*---------------------------------------------+
		| CONSTRUCTOR								   |
		+---------------------------------------------*/
		public function TestClass()
		{
			var something:Object = new Object();
			var somethingElse:* = new Object();
			
			for (var i:int = 0; i<10; i++) {
				var someString:String = "";
			}
			
			switch ("sdf") {
				case "something":
					var param2:Object = {};
					break;
			}
			
		}
		
		// COMMENT
		
		
		/*---------------------------------------------+
		| NORMAL METHODS							   |
		+---------------------------------------------*/
		private function privateFunction(param1:MouseEvent, param2:Event = null, param3:* = 4):void
		{
			var something:Object = new Object();
			var somethingElse:* = new Object();
			
			for (var i:int = 0; i<10; i++) {
				var someString:String = "";
			}
			
			switch ("sdf") {
				case "something":
					var param23:Object = {};
					break;
			}
		}
		
		// SECOND FUNCTION
		
		protected function protectedFunction():void
		{
			var something:Object = new Object();
			var somethingElse:* = new Object();
			
			for (var i:int = 0; i<10; i++) {
				var someString:String = "";
			}
			
			switch ("sdf") {
				case "something":
					var param2:Object = {};
					break;
			}
		}
		
		public function publicFunction():void
		{
			
		}
		
		static private function staticPrivateFunction():void
		{
			
		}
		
		static protected function staticProtectedStaticFunction(param1:MouseEvent, param2:Event = null, param3:* = 4):void
		{
			
		}
		
		static public function staticPublicStaticFunction(param1:MouseEvent, param2:Event = null, param3:* = 4):void
		{
			
		}
		
		internal function internalFunction():void
		{
			
		}
		
		internal static function staticInternalFunction():void
		{
			
		}
		
		
		/*---------------------------------------------+
		| NORMAL PROPERTIES							   |
		+---------------------------------------------*/
		public var publicVar:Object							= new Object();
		public const publicConst:String						= "something";
		
		public var publicVar2:String;
		public const publicConst2:String						= "something2";
		
		protected var protectedVar:Object					= new Object()
		protected const protectedConst:String				= "CONST1";
		
		private var privateVar:String;
		private const privateConst:String					= "CONST2";
		
		internal var internalVar:String;
		internal const internalConst:String					= "CONST3";
		
		static public var staticPublicVar:String;
		static public const staticPublicConst:String				= "CONST4";
		
		static protected var staticProtectedVar:String;
		static protected const staticProtectedConst:String		= "CONST5";
		
		static private var staticPrivateVar:String;
		static private const staticConst:String			= "CONST6";
		
		/*---------------------------------------------+
		| FINAL METHODS								   |
		+---------------------------------------------*/
		final private function privateFunctionF(only1Param:Object):void
		{
			var something:Object = new Object();
			var somethingElse:* = new Object();
			
			for (var i:int = 0; i<10; i++) {
				var someString:String = "";
			}
			
			switch ("sdf") {
				case "something":
					var param2:Object = {};
					break;
			}
		}
		
		final protected function protectedFunctionF():void
		{
			
		}
		
		final public function publicFunctionF():void
		{
			
		}
		
		final internal function internalFunctionF():void
		{
			var something:Object = new Object();
			var somethingElse:* = new Object();
			
			for (var i:int = 0; i<10; i++) {
				var someString:String = "";
			}
			
			switch ("sdf") {
				case "something":
					var param2:Object = {};
					break;
			}
		}
		
		/*---------------------------------------------+
		| GETTERS AND SETTERS						   |
		+---------------------------------------------*/
		public function get something():Boolean { return true; }
		public function set something(value:Boolean):void { var temp:Boolean = value; }
		
		public function get somethingElse():Boolean 
		{ 
			return true; 
		}
		public function set somethingElse(value:Boolean):void 
		{ 
			var temp:Boolean = value;
		}

		
		private function get somethingPrivate():Boolean { return true; }
		private function set somethingPrivate(value:Boolean):void { var temp:Boolean = value; }
		
		
	}
}