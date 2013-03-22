http = require 'http'

class Server
  constructor : (@options) ->
    @http = require 'http'
    @app = require('connect')()
    @app.


