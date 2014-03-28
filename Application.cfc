component accessors=true output=false persistent=false {
	THIS.name = 'pslSwaggerDocs';

	public void function onApplicationStart() output="false"{
		setupApp();

	}
	public boolean function onRequestStart() output="false" {

		if ( StructKeyExists(URL, 'reload')) {
			setupApp();
		}

		return true;
	}

	private void function setupApp() {

		APPLICATION.stRestPath = {};
		local.path = '/api';
		local.apiPath = ExpandPath(path);

		local.apiComponents = directorylist(absolute_path=local.apiPath,recurse=true, filter='*.cfc', listInfo='path');
		local.apiPath = Replace(local.apiPath, '\', '/', 'ALL');
		local.apiPath = Replace(local.apiPath, local.path, '');

		for(local.cfcPath in local.apiComponents){
			local.cfcPath = Replace(local.cfcPath, '\', '/', 'ALL');
			local.cfcPath = Replace(local.cfcPath, apiPath, '');
			local.cfcPath = Replace(local.cfcPath, '.cfc', '');
			local.cfcPath = Replace(local.cfcPath, '/', '.', 'ALL');

			local.stResource = getComponentMetadata(local.cfcPath);
			//writedump(local.stResource);abort;
			if ( local.stResource.rest) {
				APPLICATION.stRestPath[local.stResource.restpath] = {};
				APPLICATION.stRestPath[local.stResource.restpath]['cfcPath']= local.stResource.fullname;
				if ( StructKeyExists(local.stResource, 'displayname'))
					APPLICATION.stRestPath[local.stResource.restpath]['description'] = local.stResource.displayname;
				else
					APPLICATION.stRestPath[local.stResource.restpath]['description'] = 'displayname not set';
			}
		}

	}
}

/*
	mail subject="Application.cfc - onregestStart" from="swagger@psl.com.au" to="amercer@psl.com.au"  {

		mailpart type="html" {
			writedump(request, true);
			writedump(cgi, true);
		};
	};
*/