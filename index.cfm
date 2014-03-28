<cfsetting enablecfoutputonly="true">

<cfscript>

if (StructKeyExists(URL, 'path')) {
	// resource
	if ( StructKeyExists(APPLICATION.stRestPath, URL.path) ) {
		stResource = getComponentMetadata(APPLICATION.stRestPath[URL.path]['cfcPath']);
		swagger = {};
		swagger['apiVersion'] = '0.1.0';
		swagger['swaggerVersion'] = '1.2';
		swagger['basePath'] = 'http://localhost/rest/api';

		swagger['resourcePath'] = stResource.restpath;

		swagger['produces'] = [];
		swagger['apis'] = [];

		stAPI = {};
		stAPI['path'] = '';
		stAPI['operations'] = [];
		for(stFunction in stResource.functions){
			if (stFunction.access == 'remote') {

				if (stAPI['path'] != stFunction.restpath) {
					if ( stAPI['path'] != '') {
						swagger['apis'].append(Duplicate(stAPI));
					}
					stAPI = {};
					stAPI['path'] = stResource.restpath & stFunction.restpath;
					stAPI['authorizations'] = {"basicAuth":{"type":"basicAuth"}};
					stAPI['operations'] = [];
				}
					stOperation = {};
					stOperation['method'] = stFunction.httpmethod;
					stOperation['summary'] = stFunction.description;
					if (StructKeyExists(stFunction, 'hint'))
						stOperation['notes'] = stFunction.hint;
					stOperation['type'] = stFunction.returntype;
					stOperation['nickname'] = stFunction.name;
					stOperation['consumes'] = [];
					stOperation['authorizations'] = {"basicAuth":{"type":"basicAuth"}};

					stOperation['parameters'] = [];
					for(stParameter in stFunction.parameters){
						stOperationParam = {};
						stOperationParam['name'] = stParameter.name;
						if (StructKeyExists(stParameter, 'hint'))
							stOperationParam['description'] = stParameter.hint;
						stOperationParam['required'] = stParameter.required;
						stOperationParam['type'] = stParameter.type;
						//stOperationParam['format'] = '';
						stOperationParam['paramType'] = LCase(stParameter.restargsource);
						stOperationParam['allowMultiple'] = false;
						//stOperationParam['minimum'] = '';
						//stOperationParam['maximum'] = '';

						if (StructKeyExists(stParameter, 'enum'))
							stOperationParam['enum'] = ListToArray(stParameter.enum);

						stOperation['parameters'].append(Duplicate(stOperationParam));
						//dump(stParameter);
					}

					stOperation['responseMessages'] = [];

					stAPI['operations'].append(Duplicate(stOperation));

				//dump(stFunction);
			}
		}
		swagger['apis'].append(Duplicate(stAPI));

		swagger['models'] = {};
	} else {
		abort;
	}
} else {

swagger = {};
	swagger["apiVersion"] = "0.1.0";
	swagger["swaggerVersion"] = "1.2";


	swagger["apis"] = [];

	for (restPath in APPLICATION.stRestPath) {
		swagger["apis"].append({"path":"#restPath#","description":"#APPLICATION.stRestPath[restPath].description#"});
	}


	swagger["info"] = {};
	swagger["info"]["title"]             = "API title";
	swagger["info"]["description"]       = "API descriptions";
	swagger["info"]["termsOfServiceUrl"] = "http://localhost";
	swagger["info"]["contact"]           = "you@email.com";
	swagger["info"]["license"]           = "license";
	swagger["info"]["licenseUrl"]        = "http://localhost";

	swagger['headers'] = GetHTTPRequestData().Headers;

}
</cfscript>


<cfcontent type="application/json" >
<cfheader name="Access-Control-Allow-Origin" value="*">
<cfheader name="access-control-origin"       value="*">
<cfheader name="Access-Control-Allow-Headers" value="Content-Type, api_key, Authorization,accept,origin,token,ETag,X-Requested-With">
<cfheader name="Access-Control-Allow-Methods" value="GET, POST, DELETE, PUT, PATCH, OPTIONS">
<cfoutput>#serializeJSON(swagger)#</cfoutput>
