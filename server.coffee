#
# 	Start the Engines
#------------------------->

# Module dependencies.
global.configs = require "./configs.coffee"
global.http = require "http"
global.https = require "https"
global.path = require "path"
global.url = require 'url'
global.fs = require 'fs'
global.mongoose = require 'mongoose'
coffee = require 'coffee-script'
api = require "simple-api"
global.querystring = require 'querystring'

#Mock simple-api model format
require "#{__dirname}/api/v0/models/men.coffee"
serveStatic = require "#{__dirname}/lib/staticFiles.coffee"

console.log "All Modules Loaded"
console.log "Building CSS3 Man Server in #{process.env.application_env} environment"

mongoose.connect configs.mongoURL, (err) ->
	
	console.log err if err
	return false if err
	
	fs.readFile path.join(__dirname, "views", "index.html"), (err, layoutHTML) ->
		if err
			console.log "Error reading layout HTML"
			return false
	
		console.log "starting simple with host #{configs.host} and port #{configs.port}"
		v0 = new api
			prefix: ["api", "v0"]
			port: configs.port
			host: configs.host
			logLevel: 4
			fallback: (req, res) ->
	
				urlParts = url.parse req.url, yes
	
				#depends on Joe Wegner's node-session
				#req.$session = session.start res, req
	
				if urlParts.pathname.indexOf("/assets") is 0
					#Attempting to grab static assets.  Do that
					serveStatic req, res
	
				else
					#Default, serve layout
					res.end layoutHTML, 'utf8'
	
		v0.Controller "men", require("#{__dirname}/api/v0/controllers/men.coffee")
	
		console.log "App listening on #{configs.url}"

mongoose.connection.on 'error', (err) ->
	console.log "Mongoose Error", err