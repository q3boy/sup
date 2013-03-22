version = require('../package.json').version
Parser = require('argparse').ArgumentParser

module.exports = (args) ->
  parser = new Parser version: version, addHelp: true, description: 'Node Simple Static Server'
  parser.addArgument [ '-p', '--port' ], help: 'listen port', nargs: '?', type:'int', defaultValue : 8080
  parser.addArgument [ '-l', '--list' ], help: 'enables directories listing', nargs: '?', action: 'count'
  parser.addArgument ['dir'], help: "server dir", nargs: '?', defaultValue: process.cwd()
  options.list = if options.list? then true else false
  options


