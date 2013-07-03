staticFiles = []

mimeTypes =
  '.js': {mime: 'text/javascript', encoding: 'utf8'}
  '.json': {mime: 'application/json', encoding: 'utf8'}
  '.gif': {mime: 'image/gif', encoding: 'binary'}
  '.jpg': {mime: 'image/jpeg', encoding: 'binary'}
  '.jpeg': {mime: 'image/jpeg', encoding: 'binary'}
  '.png': {mime: 'image/png', encoding: 'binary'}
  '.css': {mime: 'text/css', encoding: 'utf8'}
  '.html': {mime: 'text/html', encoding: 'utf8'}
  '.mp4': {mime: 'video/mp4', encoding: 'utf8'}

compilerReplacements =
  facebookAppId: configs.facebookAppId
  domain: configs.domain

module.exports = exports = serveStatic = (req, res) ->
  ###
  HTTP Handler function for static files.  Grabs static files from /public,
  and builds uncompiled files from /build.

  **Note: ** On production, this will do full file in-memory caching for fast serving.
  On Dev, it reads/compiles every time.

  ##\## Params
  **req**: *http.ClientRequest* - The HTTP Client Request Object
  **res**: *http.ServerResponse]* - The HTTP Server Response Object
  ###
  urlParts = url.parse req.url, true

  assetPath = urlParts.pathname.split("/")[2...].join "/"
  ext = path.extname assetPath

  if path.basename(assetPath) is ""
    res.statusCode = 404;
    res.end();
    return false

  contentType = "text/plain"
  encoding = "utf8"

  if mimeTypes[ext]?
    contentType = mimeTypes[ext].mime
    encoding = mimeTypes[ext].encoding
    res.setHeader 'Content-Type', contentType
  else
    console.log "\u001b[31m Trouble finding mimetype for file #{path.basename(assetPath)} \u001b[0m"


  #Check if we have cached the static file.  If not, load it and cache it
  if staticFiles[assetPath]? and configs.cache

    console.log "Serving #{path.basename assetPath} from cache"
    res.end staticFiles[assetPath], encoding
  else
    #First check if the file exists in /client.  If not, try to compile it
    fs.exists path.join(__dirname + "/../public/" + assetPath), (pubExists) ->
      if pubExists

        fileStream = fs.createReadStream __dirname + "/../public/" + assetPath, {encoding: encoding}

        file = ""

        fileStream.on 'data', (chunk) ->
          file += chunk

        fileStream.on 'end', () ->
          staticFiles[assetPath] = file #Cache the file for later use
          res.end(file, encoding)

      else
        #File doesn't exist, so check to see if we can Compile it
        ext = path.extname(assetPath)
        if ext != ".js"
          res.statusCode = 404;
          res.end();
        else
          coffeeName = "#{path.dirname(assetPath)}/#{path.basename(assetPath, '.js')}.coffee"
          fs.exists __dirname + '/../build/' + coffeeName, (coffeeExists) ->
            if coffeeExists
              console.log "Building Coffeescript: #{coffeeName}"
              fs.readFile __dirname + '/../build/' + coffeeName, 'utf8', (err, coffeeFile) ->
                if err
                  console.log "Trouble reading coffeescript file"
                  res.statusCode = 404;
                  res.end();
                  return false
                #Compile it!

                coffeeFile = coffeeFile.replace /<%(\w*)%>/g, (m, key) ->
                  if compilerReplacements.hasOwnProperty key
                    return compilerReplacements[key]
                  else
                    return key

                compiledCoffee = coffee.compile coffeeFile

                res.end(compiledCoffee)
                staticFiles[assetPath] = compiledCoffee
            else
                res.statusCode = 404;
                res.end();