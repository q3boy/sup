http     = require 'http'
connect  = require 'connect'
index    = require 'connect-index'
compiler = require 'connect-compiler'

fs       = require 'fs'
path     = require 'path'
exec     = require('child_process').exec
Parser   = require('argparse').ArgumentParser

parser = new Parser
  version: require('../package.json').version,
  addHelp: true, description: 'Node Simple Static Server'
parser.addArgument [ '-p', '--port' ], help: 'listen port'
  , nargs: '?', type:'int', defaultValue : 8080
parser.addArgument [ '-l', '--list' ], help: 'enables directories listing'
  , nargs: '?', action: 'count'
parser.addArgument [ '-o', '--open' ], help: 'file to open', nargs: '?'
parser.addArgument ['dir'], help: "server dir", nargs: '?'
  , defaultValue: process.cwd()

args = parser.parseArgs()
args.dest = path.join args.dir, '.sup_tmp_dir'
try
  unless fs.statSync(args.dir).isDirectory()
    console.error "ERROR: #{args.dir} is not a directory."
catch e
  console.error "ERROR: can't access #{args.dir}"

app = connect()
http = http.createServer app
app.use connect.logger format: 'dev'
app.use connect.favicon path.join __dirname, '../res/favicon.ico'

app.use compiler
  enabled : [ 'coffee', 'yaml', 'jade', 'stylus']
  src     : args.dir
  dest    : args.dest
  # expires : true
  # cascade : true
  # external_timeout : 1
  # resolve_index : true
  options :
    coffee : bare : true
app.use connect.static args.dir, maxAge: 0
app.use connect.static args.dest, maxAge: 0

app.use index args.dir if args.list?
app.use connect.errorHandler()

http.listen args.port, ->
  console.log "Server #{args.dir} on #{args.port}"
  url = "http://localhost:#{args.port}/"
  url = path.join url, args.open
  exec "open '#{url}'"

process.on 'exit', ->
