menSchema = mongoose.Schema
	created: {type: Number, default: Date.now}
	likes: {type: Number, default: 0}
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

menSchema.static 'createMan', (css, cb) ->

	newMan = new Men
		css: css

	newMan.save cb

menSchema.static 'likeMan', (id, cb) ->

	this.find {id: id}, (err, docs) ->
		if err
			console.log "Error looking for a man to look", err
			return 500
		else if docs.length <= 0
			console.log "Coudldn't find a man with id #{id}"
			return 404
		else
			docs[0].likes++
			docs[0].save()
			return true

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
