http    = require 'http'
connect = require 'connect'
index   = require 'connect-index'
fs      = require 'fs'
path    = require 'path'
exec    = require('child_process').exec
Parser  = require('argparse').ArgumentParser

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

try
  unless fs.statSync(args.dir).isDirectory()
    console.error "ERROR: #{args.dir} is not a directory."
catch e
  console.error "ERROR: can't access #{args.dir}"

app = connect()
http = http.createServer app
app.use connect.logger format: 'dev'
app.use connect.favicon path.join __dirname, '../res/favicon.ico'

app.use index args.dir if args.list?

app.use connect.static args.dir, maxAge: 0
app.use connect.errorHandler()

http.listen args.port, ->
  console.log "Server #{args.dir} on #{args.port}"
  url = "http://localhost:#{args.port}/#{args.file || ''}"
  exec "open '#{url}'"


