# If no env, set to dev
if not process.env?.application_env
	process.env.application_env = "local"

configs = {}


switch process.env.application_env
	when "local"
		configs.mongoURL = "mongodb://localhost/css3mandb"
		configs.host = "localhost"
		configs.port = "3333"
		configs.url = "http://localhost:3333"
		configs.cache = false

	when "production"
		configs.cache = true
		configs.mongoURL = process.env.MONGOLAB_URI
		configs.port = process.env.PORT or 3333
		configs.url = "http://www.css3man.com"
		configs.host = null

module.exports = exports = configs
