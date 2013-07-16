package
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class TestClass
	{
		// COMMENT
		public var publicVar:String;
		public const publicConst:String						= "something";
		
		protected var protectedVar:Object					= new Object()
		protected const protectedConst:String				= "CONST1";
		
		private var privateVar:String;
		private const privateConst:String					= "CONST2";
		
		static public var publicVar:String;
		static public const publicConst:String				= "CONST3";
		
		static protected var protectedVar:String;
		static protected const protectedConst:String		= "CONST4";
		
		static private var privateVar:String;
		static private const privateConst:String			= "CONST5";
		
		
		/*---------------------------------------------+
		| CONSTRUCTOR								   |
		+---------------------------------------------*/
		public function TestClass()
		{
			var something:Object = new Object();
			var somethingElse:* = new Object();
		}
		
		/*---------------------------------------------+
		| NORMAL METHODS							   |
		+---------------------------------------------*/
		private function privateFunction(param1:MouseEvent, param2:Event = null, param3:* = 4):void
		{
			
		}
		
		protected function protectedFunction():void
		{
			
		}
		
		public function publicFunction():void
		{
			
		}
		
		static private function privateFunction():void
		{
			
		}
		
		static protected function protectedStaticFunction():void
		{
			
		}
		
		static public function publicStaticFunction():void
		{
			
		}
		
		internal function internalFunction():void
		{
			
		}
		
		internal static function internalFunction():void
		{
			
		}
		
		/*---------------------------------------------+
		| FINAL METHODS								   |
		+---------------------------------------------*/
		final private function privateFunctionF():void
		{
			
		}
		
		final protected function protectedFunctionF():void
		{
			
		}
		
		final public function publicFunctionF():void
		{
			
		}
		
		final internal function internalFunctionF():void
		{
			
		}
		
		
		
	}
}