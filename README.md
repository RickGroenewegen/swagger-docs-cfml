swagger-docs-cfml
=================

create swagger docs from CFML (Railo) ReST components

this is a *Work in Progress - updating to Swagger 2.0*

This app will scan for ReST CFCs in given path and will dynamically create a swagger doc for each resource found

Get Swagger UI
--------------
[https://github.com/wordnik/swagger-ui](https://github.com/wordnik/swagger-ui)

Instructions
------------
* I put swagger-docs-cfm in subdirectory called 'docs' (within the swagger directory)
* Create Rewrite rule - ^/swagger/docs/(.+)$ /swagger/docs/index.cfm?path=/$1
* Set path to your ReST components in Application.cfc setupApp()
* Set swagger['basePath'] in index.cfm. and other swagger["info"] properties
* Launch Swagger UI, eg http://localhost/swagger
* Enter docs URL eg http://localhost/swagger/docs
* Hopefully you can browser and try for ReST API

Suggestions
-----------
I have just started messing around with swagger and knocked this a quickly. Please let me know if you have any suggestions

To do
-----
* Add Basic Authentication
* config for baseURL and info properties
