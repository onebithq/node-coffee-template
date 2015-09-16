# Modules
console.time 'requireLib'
express         = require 'express'
_               = require 'lodash'
_.str           = require 'underscore.string'
bodyParser      = require 'body-parser'
random          = require 'randomstring'
postal          = require 'postal'
fs              = require 'fs-extra'
methodOverride  = require 'method-override'
winston         = require 'winston'
path            = require 'path'
http            = require 'http'
Settings        = require 'settings'
crypto          = require 'crypto'
config          = new Settings(require './config/config')
system          = new Settings(require './config/system')
redis           = require('redis').createClient(config.redis.port, config.redis.server)
promise         = require 'bluebird'
crypto          = require 'crypto'
moment          = require 'moment'
debug           = require 'debug'
clone           = require 'clone'
jwt             = require 'jsonwebtoken'
expressJwt      = require 'express-jwt'
ignoreFiles     = []
console.timeEnd 'requireLib'

# Logging
console.time 'ConfigLogging'
log = new (winston.Logger)(
  transports: [
    new (winston.transports.Console)(
      colorize: true 
      level: config.log.logLevel
    ), 
    new (winston.transports.File)(
      filename: config.log.defaultFile
      handleExceptions: true
      colorize: true
      level: config.log.logLevel
  )]

  exceptionHandlers: [
    new (winston.transports.Console)(
      colorize: true
      level: config.log.exceptionsLevel
    ), 
    new winston.transports.File(
      filename: config.log.exceptionsFile
      colorize: true
      level: config.log.exceptionsLevel
  )]
  exitOnError: false
)
console.timeEnd 'ConfigLogging'

# Initialize Server
console.time 'InitializeServer'
app = express()
console.timeEnd 'InitializeServer'


console.time 'InitializeMiddleware'
app.use bodyParser.urlencoded
  extended: false
app.use system.apiPath, expressJwt({ secret: config.jwtSecret })
app.use bodyParser.json()
app.use methodOverride()
app.disable 'x-powered-by'
console.timeEnd 'InitializeMiddleware'


param = { app, fs, log, config, system, _, promise, crypto, debug, path, clone, random,
  redis, postal, jwt, crypto, moment }


#Logic
console.time "LoadLogic"
logic = require("./logic")(param)
param.logic = logic
console.timeEnd "LoadLogic"


#Routing-backend
["routing"].forEach (folder) ->
  files = fs.readdirSync(path.join(__dirname, folder))
  files.forEach (file) ->
    return  if not file.match(/.coffee$/) or _.include(ignoreFiles, file)
    require(path.join(__dirname, folder, file.replace(/.coffee$/, ""))) param

app.use (req,res,next) ->
  res.sendStatus 404

process.on 'uncaughtException', (err) ->
  log.error "Caught exception: #{err}"

app.listen config.port.api
log.debug 'Server started at port: ', config.port.api
