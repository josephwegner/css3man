MenController =
	options: {}
	routes:
		createMan:
			method: "POST"
			pieces: ["create"]
		likeMan:
			method: "PUT"
			pieces: ["like", "*id"]
		getPopulation:
			method: "GET"
			pieces: []

	actions:
		getPopulation: (req, res, params) ->
			Men = mongoose.model "Men"

			Men.getPopulation (err, people) ->
				if err
					console.log err
					res.statusCode = 500
					res.end()
				else
					res.end JSON.stringify people
		createMan: (req, res, params) ->
			data = ""

			req.on "data", (chunk) ->
				data += chunk

			req.on "end", (chunk) =>
				man = JSON.parse data

				for index, data of man.css
					if index is "animations"
						valid = @helpers.validateAnimationCSS data
					else
						valid = @helpers.validateCSS data

					if not valid
						res.statusCode = 400
						res.end JSON.stringify
							error: "Invalid CSS"

				Men = mongoose.model "Men"

				Men.createMan man.css, (err, man) ->
					if(err)
						res.statusCode = 500
						res.end()
					else
						res.end JSON.stringify(man)

		likeMan: (req, res, params) ->
			console.log "like man", params

			Men = mongoose.model "Men"

			Men.likeMan params.id, (status) ->
				if typeof(status) != "boolean"
					res.statusCode = status
					res.end()
				else
					res.end()


	helpers: 
		validateCSS: (css) ->
			console.log css
			if css.indexOf("{") != -1 || css.indexOf("}") != -1
				return false

			if css.indexOf(">") != -1 || css.indexOf("<") != -1
				return false

			if css.indexOf("\"") != -1
				return false

			return true

		validateAnimationCSS: (css) ->
			justOpens = css.replace /[^{]+/g, ""
			justCloses = css.replace /[^}]+/g, ""

			if justOpens.length != justCloses.length
				return false;
			

			if css.indexOf(">") != -1 || css.indexOf("<") != -1
				return false;

			if css.indexOf("\"") != -1
				return false
			
			return true


module.exports = exports = MenController