
/**
 * Created by Terenteva.Mariia on 08.12.2016.
 */

var noflo;

noflo = require('noflo');

exports.getComponent = function() {
    var c;
    c = new noflo.Component;
    c.icon = 'cog';
    c.description = 'Calls remote Json-RPC service to get option price';
    c.outPorts = new noflo.OutPorts({
        price: {
            datatype: 'number'
        },
        error: {
            datatype: 'string',
            required: false
        }
    });
    c.inPorts = new noflo.InPorts({
        option_params: {
            datatype: 'object',
            required: true,
            description: 'Expects for object = {K:number, T:number, S:number, Type:string}, where type can be "Put" or "Call"'
        }
    });
    c.inPorts.option_params.on('data', function(data) {
        console.log(data);
        c.outPorts.price.send(0.03);
        return c.outPorts.price.disconnect();
    });
    return c;
};
