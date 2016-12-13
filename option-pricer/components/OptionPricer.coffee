noflo = require 'noflo'
R = require("r-script");

rpc = require('node-json-rpc')
options =
  port: 5000
  host: '192.168.101.41'
  path: '/'
  strict: true
client = new (rpc.Client)(options)

sum = 0

exports.getComponent = ->
  c = new noflo.Component

  # Define a meaningful icon for component from http://fontawesome.io/icons/
  c.icon = 'cog'

  # Provide a description on component usage
  c.description = 'Calls remote Json-RPC service to get option price'

  # Add output ports
  c.outPorts = new noflo.OutPorts
    price:
      datatype: 'number'
    error:
      datatype: 'string'
      required: false

  # Add input ports
  c.inPorts = new noflo.InPorts
    option_params:
      datatype: 'object'
      required: true
      description: 'Expects for object = {K:number, T:number, S:number, Type:string}, where type can be "Put" or "Call"'


  c.inPorts.option_params.on 'data', (data) ->
    console.log(data)
    client.call { 'jsonrpc': '2.0', 'method': 'option_price', 'params': [data], 'id': 0}, (err, res) ->
      # Did it all work ?
      console.log('in')

      console.log(err)
      console.log(res)
      sum = res['result'][1]
      console.log(sum)

    console.log(sum)



    c.outPorts.price.send 0.03
    c.outPorts.price.disconnect()

  # Finally return the component instance
  c
