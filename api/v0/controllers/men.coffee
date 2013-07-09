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
		getMan:
			method: "GET"
			pieces: ["*id"]
		getShort:
			method: "GET"
			pieces:["short", "*id"]

	actions:
		getShort: (req, res, params) ->
			Men = mongoose.model "Men"

			if params.id?
				Men.getById params.id, (err, man) ->
					if err
						console.log err
						res.statusCode = 500
						res.end()
					else if !man.length
						res.statusCode = 404
						res.end()
					else
						url = "http://www.css3man.com/##{man[0]['_id']}"
						console.log url
						https.get "https://api-ssl.bitly.com/v3/shorten?login=josephwegner&apiKey=R_6c8d9f5aea7ac4784e83ef5eafeb229f&longURL=#{encodeURIComponent(url)}", (resp) ->
							data = ""

							resp.on 'data', (chunk) ->
								data += chunk

							resp.on 'end', () ->
								bitly = JSON.parse data
								console.log bitly

								res.end bitly.data.url
			else
				res.statusCode = 404
				res.end()

		getMan: (req, res, params) ->
			Men = mongoose.model "Men"

			if params.id?
				Men.getById params.id, (err, man) ->
					if err
						console.log err
						res.statusCode = 500
						res.end()
					else if !man.length
						res.statusCode = 404
						res.end()
					else
						res.end JSON.stringify man[0]
			else
				res.statusCode = 404
				res.end()
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

				if not man.css? or not man.key?
					res.statusCode = 400
					res.end JSON.stringify
						error: "CSS and Key fields required"

				for index, data of man.css
					if index is "animations"
						valid = @helpers.validateAnimationCSS data, man.key
					else
						valid = @helpers.validateCSS data, man.key

					if not valid
						res.statusCode = 400
						res.end JSON.stringify
							error: "Invalid CSS"

				Men = mongoose.model "Men"

				Men.createMan man.key, man.css, (err, man) ->
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
		validateCSS: (css, key) ->
			console.log css
			if css.indexOf("{") != -1 || css.indexOf("}") != -1
				return false

			if css.indexOf(">") != -1 || css.indexOf("<") != -1
				return false

			if css.indexOf("\"") != -1
				return false

			animations = css.match /keyframes[^{]*{/g
			if animations
				for animation in animations
					if animation.indexOf(key) == -1
						return false

			return true

		validateAnimationCSS: (css, key) ->
			justOpens = css.replace /[^{]+/g, ""
			justCloses = css.replace /[^}]+/g, ""

			if justOpens.length != justCloses.length
				return false;
			

			if css.indexOf(">") != -1 || css.indexOf("<") != -1
				return false;

			if css.indexOf("\"") != -1
				return false

			animations = css.match /keyframes[^{]*{/g
			if animations
				for animation in animations
					if animation.indexOf(key) == -1
						return false
			
			return true


module.exports = exports = MenController