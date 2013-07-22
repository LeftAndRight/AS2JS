var Converter = RootClass.extend({}, {

	convert : function (input)
	{
		var output			= input;

		// Replace comments with placeholders
		var found				= true;
		var comments			= [];
		var commentMultiPat		= new RegExp("/\\*([^*]|[\\r\\n]|(\\*+([^*/]|[\\r\\n])))*\\*+/");
		var commentSinglePat	= new RegExp("//.+");
		// Multi line first
		while (found){
			var match		= output.match(commentMultiPat);
			found			= false;

			// If something is found create a place holder and store with the original
			if (match && match.length > 0){
				found		= true;
				var obj		= {original:match[0], placeholder:"___" + _.uniqueId() + "___"};
				output		= output.replace(commentMultiPat, obj.placeholder);
				comments.push(obj);
			}
		}
		// Now single line
		found				= true;
		while (found){
			var match		= output.match(commentSinglePat);
			found			= false;

			// If something is found create a place holder and store with the original
			if (match && match.length > 0){
				found		= true;
				var obj		= {original:match[0], placeholder:"___" + _.uniqueId() + "___"};
				output		= output.replace(commentSinglePat, obj.placeholder);
				comments.push(obj);
			}
		}



		/*
		Format Class Variables
		----------------------
		from:
			public var publicVar:Object = new Object();
		to:
			publicVar : new Object(), // Object
		*/
		try {
			var reg	= "public var.*";
			reg		+= "|public const.*";
			reg		+= "|protected var.*";
			reg		+= "|protected const.*";
			reg		+= "|private var.*";
			reg		+= "|private const.*";
			reg		+= "|internal var.*";
			reg		+= "|internal const.*";
			reg		+= "|private static const.*";
			reg		+= "|public static const.*";
			reg		+= "|protected static const.*";
			reg		+= "|internal static const.*";

			output	= output.replace(new RegExp(reg, "g"), $.proxy(this.formatClassVariable, this));
		}catch(e){ console.error("Failed on class variables replace"); }

		output = output.replace(/public var |public const |public static const /g, "");
		output = output.replace(/protected var |protected const |private var |private const |internal var |internal const |protected static const |internal static const /g, "_");
		output = output.replace(/final /g, "");

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
		output = output.replace(/internal static function |public static function |private static function |protected static function /g, "static function _");
		output = output.replace(/public function/g, "function");

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
		output = output.replace(/.*function [a-zA-Z0-9_:() ,=*]*/g, $.proxy(this.formatClassFunctionVariables, this));
		/*try{
			output = output.replace(/.*function [a-zA-Z0-9_:() ,=*]*//*g, this.formatClassFunctionVariables);
		}catch(e){ console.error("Failed on Format Class Function Variables"); }*/



		/*
		Format Class function contents
		------------------------------
		Just removing DataTypes
		*/
		// Number of functions
		var functionsArr = output.match(/function /g);
		if (functionsArr) {
			for (var i = 0; i<functionsArr.length; i++) {
				// Find the first function and replace it
				output = output.replace(/function /, "FIRST_ThisIsACompletelyRandomPlaceHolderForFunctionDataTypeFormatting ");

				// Step through the code to find the entire function
				var startIndex 		= output.indexOf("FIRST_ThisIsACompletelyRandomPlaceHolderForFunctionDataTypeFormatting ");
				var endIndex;
				var splitString 	= output.split("");
				var openCounter		= 0;
				var closeCounter	= 0;
				var firstFound		= false;
				for (var c = startIndex; c<splitString.length; c++) {
					var character = splitString[c];
					if (character == "{") {
						firstFound = true;
						openCounter++;
					}
					if (character == "}") {
						closeCounter++;
					}
					if (firstFound && openCounter == closeCounter) {
						endIndex = c;
						break;
					}
				}
				var foundFunction = output.slice(startIndex, endIndex+1);
				// Send the function to be formatted
				output = output.replace(foundFunction, this.formatFunctionContents(foundFunction) + ",");

				output = output.replace(/FIRST_ThisIsACompletelyRandomPlaceHolderForFunctionDataTypeFormatting /, "SECOND_ThisIsACompletelyRandomPlaceHolderForFunctionDataTypeFormatting ");
			}

			output = output.replace(/SECOND_ThisIsACompletelyRandomPlaceHolderForFunctionDataTypeFormatting /g, "function ");
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
		try {
			output = output.replace(/function [A-Za-z0-9 _(),]*/g, $.proxy(this.formatFunctionDeclaration, this));
		}catch(e){ console.error("Failed on Format function declaration"); }


		// put back all the comments
		_.each(comments, function(item, i){
			output = output.replace(item.placeholder, item.original);
		}, this);

		return output;
	},

	formatClassVariable : function (match, lineNumber, fullString)
	{
		var retStr		= match;
		// Store datatype
		var dataType	= retStr.match(/:[A-Za-z0-9*_]*/)[0].slice(1);
		// Replace ":DataType =" with " : "
		retStr 			= retStr.replace(/:[A-Za-z0-9*_\s]*=/, 		"			:");
		// Replace ":DataType" with " : "
		retStr 			= retStr.replace(/:[A-Za-z0-9*_]{1,999}/, 	"			: null");

		retStr 			= retStr.replace(/;/, "");
		retStr			+= ",";
		retStr			+= " // " + dataType;
		return retStr;
	},

	formatClassFunctionVariables : function (match, lineNumber, fullString)
	{
		// function privateFunction(param1:DataType, param2:DataType = null, param3:* = 4):DataType
		var retStr 	= match;

		// Process All Internal DataTypes for JSDocs
		// -----------------------------------------
		var returnComments;
		// (param1:DataType, param2:DataType = null, param3:* = 4)
		var params 	= retStr.match(/\(.*\)/);
		if (params){
			// Individual params
			// param1:DataType
			params 				= params[0].match(/[a-zA-Z0-9*]*:[a-zA-Z0-9*]*/g);
			if (params && params.length > 1) {
				returnComments = "/**\n";
				for (var i = 0; i<params.length; i++) {
					var param = params[i];
					returnComments += this.formatParam(param, false);
					returnComments += "\n";
				}
				returnComments += " */\n";
			} else if (params && params.length == 1) {
				returnComments = "/** " + this.formatParam(params[0], true) + "*/\n";
			}

			// Remove all data types
			// & Assigned params eg. param1:String = x
			retStr = retStr.replace(/:[a-zA-Z0-9* =]*/g, "");

			// Prepend Comments
			if (returnComments != null) {
				retStr = returnComments + retStr;
			}
		}
		return retStr;
	},

	formatParam : function (param, single)
	{
		var retStr		 	= "";
		retStr 				+= (single) ? "" : " * ";
		retStr 				+= "@param {";
		retStr 				+= param.split(":")[1]; // Data Type
		retStr 				+= "} ";
		retStr 				+= param.split(":")[0]; // Param Name
		retStr 				+= " ";
		return retStr;
	},

	formatFunctionContents : function (foundFunction)
	{
		var retStr = foundFunction;
		// Replace all DataType Declarations
		retStr = retStr.replace(/:[a-zA-Z0-9*]{1,9999}/g, "");
		return retStr;
	},


	formatFunctionDeclaration : function (match, lineNumber, fullString)
	{
		var retStr = match;

		// Format a get or set
		if ((retStr.indexOf("get") != -1)) retStr 	= retStr.replace(/function [_]*get ./, this.capitalizeLastChar);
		if ((retStr.indexOf("set") != -1)) retStr 	= retStr.replace(/function [_]*set ./, this.capitalizeLastChar);

		retStr = retStr.replace(/function /, "");

		retStr = retStr.replace(/[(]/, " : function(");
		return retStr;
	},

	capitalizeLastChar : function (match, lineNumber, fullString)
	{
		return match.slice(0, match.length-2) + match.slice(match.length-2).slice(1).toUpperCase();
	}
});



