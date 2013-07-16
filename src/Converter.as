package
{
	public class Converter
	{
		public static function convert(input:String):String
		{
			var output:String = input;
			
			// Format Class Variables
			output = output.replace(/public var.*|public const.*|protected var.*|protected const.*|private var.*|private const.*|internal var.*|internal const.*/g, formatClassVariable);
			output = output.replace(/public var |public const /g, "");
			output = output.replace(/protected var |protected const |private var |private const |internal var |internal const /g, "_");
			output = output.replace(/static |static /g, "/*STATIC*/ ");
			
			
			
			/*
			Replace the below
			-------------------------------
			const
			*/
			
			/*
			Comma separate everything
			-------------------------------
			*/
			
			/*
			Format functions
			param : function(value)
			-------------------------------
			*/
			
			return output;
		}
		
		private static function formatClassVariable(match:String, lineNumber:Number, fullString:String):String
		{
			var retStr:String 	= match;
			// Store datatype
			var dataType:String	= retStr.match(/:[A-Za-z0-9*_]*/)[0].slice(1);
			
			// Replace DataType with =
			retStr 				= retStr.replace(/:[A-Za-z0-9*_\s]*=/, 		"			:");
			retStr 				= retStr.replace(/:[A-Za-z0-9*_]{1,999}/, 	"			: null");
			retStr 				= retStr.replace(/;/, "");
			retStr				+= ",";
			retStr				+= " // " + dataType;
			return retStr;
		}
	}
}