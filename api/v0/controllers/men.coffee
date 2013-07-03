MenController =
	options: {}
	routes:
		createMan:
			method: "POST"
			pieces: ["create"]
		likeMan:
			method: "PUT"
			pieces: ["like", ":id"]

	actions:
		createMan: (req, res, params) ->
			data = ""

			req.on "data", (chunk) ->
				data += chunk

			req.on "end", (chunk) ->
				man = JSON.parse data

				Men = mongoose.model "Men"

				Men.createMan man.css, (err, man) ->
					if(err)
						res.statusCode = 500
						res.end()
					else
						res.end JSON.stringify(man)

		likeMan: (req, res, params) ->

			Men = mongoose.model "Men"

			Men.likeMan params.id, (status) ->
				if typeof(status) != "boolean"
					res.statusCode = status
					res.end()
				else
					res.end()


	helpers: {}

module.exports = exports = MenController