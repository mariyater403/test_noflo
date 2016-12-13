noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  OptionPricer = require '../components/OptionPricer.coffee'
else
  OptionPricer = require 'option-pricer/components/OptionPricer.js'

describe 'OptionPricer component', ->
  c = null
  ins = null
  out = null
  outMsg = []
  beforeEach ->
    c = OptionPricer.getComponent()
    ins = noflo.internalSocket.createSocket()
    out = noflo.internalSocket.createSocket()
    c.inPorts.option_params.attach ins
    c.outPorts.price.attach out

    outMsg = []
    out.on 'data', (message) ->
      outMsg.push(message)

  describe 'when instantiated', ->
    it 'should have an input port', ->
      chai.expect(c.inPorts.option_params).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(c.outPorts.price).to.be.an 'object'

  describe 'when option parameters come', ->
    it 'should be a regular JSON object', ->
      jsObj =
        K: 1
        T: 0.5
        S: 0.6
        type: "Put"
      ins.send jsObj
      chai.expect(outMsg).to.deep.equal([0.03])
