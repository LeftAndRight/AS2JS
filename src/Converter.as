package
{
	public class Converter
	{
		public static function convert(input:String):String
		{
			var output:String = input;
			// test
			
			/*
			Format Class Variables
			----------------------
			from:
				public var publicVar:Object = new Object();
			to:
				publicVar : new Object(), // Object
			*/ 
			output = output.replace(/public var.*|public const.*|protected var.*|protected const.*|private var.*|private const.*|internal var.*|internal const.*/g, formatClassVariable);
			output = output.replace(/public var |public const /g, "");
			output = output.replace(/protected var |protected const |private var |private const |internal var |internal const /g, "_");
			
			/*
			Format Class Functions
			----------------------
			from:
			protected function protectedFunction():void
			to:
			function _protectedFunction():void
			*/ 
			output = output.replace(/public function/g, "function");
			output = output.replace(/private function |protected function |internal function /g, "function _");
			output = output.replace(/internal static function /g, "static function _");
			output = output.replace(/final function/g, "function");
			
			/*
			Annotate Statics
			----------------
			from:
				static function staticPublicStaticFunction():void
			to:
				/*STATIC*\/ 
				function _staticProtectedStaticFunction():void
			*/
			output = output.replace(/static /g, "/*STATIC*/ \n");
			
			
			/*
			Format Class Function Variables
			-------------------------------
			from:
				function privateFunction(param1:MouseEvent, param2:Event = null, param3:* = 4):void
			to:
				/**
				* @param {MouseEvent} param1 
				* @param {Event} param2 
				* @param {*} param3 
				*\/
				function _privateFunction(param1, param2, param3)
			*/
			output = output.replace(/.*function [a-zA-Z0-9_:() ,=*]*/g, formatClassFunctionVariables);
			
			
			
			/*
			Format Class function contents
			------------------------------
			Just removing DataTypes
			*/
			// Number of functions
			var numberOfFunctions:Number = output.match(/function /g).length;
			
			for (var i:int = 0; i<numberOfFunctions; i++) {
				// Find the first function and replace it
				output = output.replace(/function /, "FIRSTChange__thisIsATempHolder__1122__ ");
				
				// Step through the code to find the entire function
				var startIndex:int 		= output.indexOf("FIRSTChange__thisIsATempHolder__1122__ ");
				var endIndex:int;
				var splitString:Array 	= output.split("");
				var openCounter:Number	= 0;
				var closeCounter:Number	= 0;
				var firstFound:Boolean	= false;
				for (var c:int = startIndex; c<splitString.length; c++) {
					var char:String = splitString[c];
					if (char == "{") {
						firstFound = true;
						openCounter++;
					}
					if (char == "}") {
						closeCounter++;
					}
					if (firstFound && openCounter == closeCounter) {
						endIndex = c;
						break;
					}
				}
				var foundFunction:String = output.slice(startIndex, endIndex+1);
				// Send the function to be formatted
				output = output.replace(foundFunction, formatFunctionContents(foundFunction) + ",");
				
				output = output.replace(/FIRSTChange__thisIsATempHolder__1122__ /, "SECONDChange__thisIsSomethingCompletelyDifferent ");
			}
			output = output.replace(/SECONDChange__thisIsSomethingCompletelyDifferent /g, "function ");
			
			
			/*
			Format function declaration
			---------------------------
			from: 
				function _privateFunction(param1, param2, param3){ return param1; }
			to:
				_privateFunction : function(param1, param2, param3)
				{
			*/
			output = output.replace(/function [A-Za-z0-9 _(),]*/g, formatFunctionDeclaration);
			
			return output;
		}
		
		private static function formatClassVariable(match:String, lineNumber:Number, fullString:String):String
		{
			var retStr:String 	= match;
			// Store datatype
			var dataType:String	= retStr.match(/:[A-Za-z0-9*_]*/)[0].slice(1);
			// Replace ":DataType =" with " : "
			retStr 				= retStr.replace(/:[A-Za-z0-9*_\s]*=/, 		"			:");
			// Replace ":DataType" with " : "
			retStr 				= retStr.replace(/:[A-Za-z0-9*_]{1,999}/, 	"			: null");
			
			retStr 				= retStr.replace(/;/, "");
			retStr				+= ",";
			retStr				+= " // " + dataType;
			return retStr;
		}
		
		/**
		 * @param 
		 */
		private static function formatClassFunctionVariables(match:String, lineNumber:Number, fullString:String):String
		{
			// function privateFunction(param1:DataType, param2:DataType = null, param3:* = 4):DataType
			var retStr:String 	= match;
			
			// Process All Internal DataTypes for JSDocs
			// -----------------------------------------
			var returnComments:String;
			// (param1:DataType, param2:DataType = null, param3:* = 4)
			var params:Array 	= retStr.match(/\(.*\)/);
			// Individual params
			// param1:DataType
			params 				= params[0].match(/[a-zA-Z0-9*]*:[a-zA-Z0-9*]*/g);
			if (params && params.length > 1) {
				returnComments = "/**\n";
				for each (var param:String in params) {
					returnComments += formatParam(param, false);
					returnComments += "\n";
				}
				returnComments += " */\n";
			} else if (params && params.length == 1) {
				returnComments = "/** " + formatParam(params[0], true) + "*/\n";
			}
			
			// Remove all data types 
			// & Assigned params eg. param1:String = x
			retStr = retStr.replace(/:[a-zA-Z0-9* =]*/g, "");
			
			// Prepend Comments
			if (returnComments != null) {
				retStr = returnComments + retStr;
			}
			return retStr;
		}
			private static function formatParam(param:String, single:Boolean):String
			{
				var retStr:String 	= "";
				retStr 				+= (single) ? "" : " * ";
				retStr 				+= "@param {";
				retStr 				+= param.split(":")[1]; // Data Type
				retStr 				+= "} ";
				retStr 				+= param.split(":")[0]; // Param Name
				retStr 				+= " ";
				return retStr;
			}
		
			
		private static function formatFunctionContents(foundFunction:String):String
		{
			var formattedFunction:String = foundFunction;
			// Replace all DataType Declarations
			formattedFunction = formattedFunction.replace(/:[a-zA-Z0-9*]{1,9999}/g, "");
			return formattedFunction;
		}
		
		
		/*
		Format function declaration
		---------------------------
		from: 
			function _privateFunction(param1, param2, param3){ return param1; }
		to:
			_privateFunction : function(param1, param2, param3)
		{
		*/
		private static function formatFunctionDeclaration(match:String, lineNumber:Number, fullString:String):String
		{
			var retStr:String = match;
			// Format a get or set
			if ((retStr.indexOf("get") != -1)) retStr 	= retStr.replace(/function [_]*get ./, capitalizeLastChar);
			if ((retStr.indexOf("set") != -1)) retStr 	= retStr.replace(/function [_]*set ./, capitalizeLastChar);
			
			retStr = retStr.replace(/function /, "");
			
			retStr = retStr.replace(/[(]/, " : function(");
			
			return retStr;
		}
		
			private static function capitalizeLastChar(match:String, lineNumber:Number, fullString:String):String
			{
				/*var retStr:String;
				var lastChar:String 		= match.substr(match.length-1);
				var secondLastChar:String 	= match.substr(match.length-2,1);
				if (secondLastChar == "_") {
					retStr = "function _get" + lastChar.toUpperCase();
				} else {
					retStr = "function get" + secondLastChar.toUpperCase() + lastChar;
				}
				return retStr;*/
				return match.slice(0, match.length-2) + match.slice(match.length-2).slice(1).toUpperCase();
			}
		
		
		
		
		
		
		
		
		
		
	}
}