menSchema = mongoose.Schema
	created: {type: Number, default: Date.now}
	likes: {type: Number, default: 0}
	key: String
	css:
		head: String
		head_before: String
		head_after: String
		body: String
		body_before: String
		body_after: String
		legs: String
		legs_before: String
		legs_after: String
		animations: String

menSchema.static "getById", (id, cb) ->
	this.find { '_id': id }, (err, doc) ->
		if err
			console.log "Error getting man by id"
			cb?(err)
			return true
		else
			cb?(null, doc)
			return false

	return true

menSchema.static "getPopulation", (cb) ->
	send = false
	pop = []

	this.find().limit(10).sort({ created: "desc"}).exec (err, docs) ->
		if err
			console.log "Error getting population"
			cb?(err)
			return false
		
		pop = pop.concat docs

		console.log docs

		if send
			console.log pop
			cb?(null, pop)
			return false

		send = true

	this.find().limit(10).sort({ likes: "desc"}).exec (err, docs) ->
		if err
			console.log "Error getting population"
			cb?(err)
			return false
		
		pop = pop.concat docs

		console.log docs

		if send
			console.log pop
			cb?(null, pop)
			return false

		send = true


menSchema.static 'createMan', (key, css, cb) ->
	console.log key, css
	newMan = new Men
		key: key
		css: css

	newMan.save cb

menSchema.static 'likeMan', (id, cb) ->

	this.find {'_id': id}, (err, docs) ->
		if err
			console.log "Error finding man with id #{id}", err
			cb?(500);
			return false
		else if docs.length <= 0
			console.log "Couldn't find a man with id #{id}"
			cb?(404);
			return false
		else
			console.log "like man"
			docs[0].likes++
			docs[0].save()
			cb?(true)

###
blockSchema.static 'isBlocked', (service, type, id, cb) ->
	this.find { entity_type: type, service: service, block_id: id }, (err, docs) ->
		if err
			console.log "Error Checking for entity blocks", err
			cb?(true) #Return true if there was an error, because we don't know that this entity should pass.  It's safer to hide it
			return false

		cb?(docs.length > 0)
###

Men = mongoose.model 'Men', menSchema

module.exports = exports = Men
