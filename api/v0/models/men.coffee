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

menSchema.static "getPopulation", (cb) ->
	this.find().limit(20).sort({ created: "desc"}).exec (err, docs) ->
		if err
			console.log "Error getting population"
			cb?(err)
			return false
		else
			cb?(null, docs)
			return false

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
