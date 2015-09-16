module.exports = (params) ->
  { app, logic, system, _, log, } = params

  app.all "/ping", (req, res, next) ->
  	res.status(200).json
        error: false
        result: "PONG"
