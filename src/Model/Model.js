/*
 * Dependencies
 */
var CouchbaseModel = require('./CouchbaseModel');
var MockModel = require('./MockModel');

var exceptions = require('./../exceptions');

function Model(name, configurations) {
	if (name === 'Couchbase') {
		this.dataSource = new CouchbaseModel(configurations);
	} else if (name === 'Mock') {
		this.dataSource = new MockModel(configurations);
	} else {
		throw new exceptions.IllegalArgument('Invalid Model name: ' + name);
	}
}

Model.prototype.connect = function(onSuccess, onError) { 
	return this.dataSource.connect(onSuccess, onError);
};

Model.prototype.disconnect = function() {
	return this.dataSource.disconnect();
};

Model.prototype.findByKey = function(keyValue, keyName, callback) {
	return this.dataSource.findByKey(keyValue, keyName, callback);
};

Model.prototype.findById = function(id, callback) {
	return this.dataSource.findById(id, callback);
};

Model.prototype.save = function(id, data, callback, prefix, options) {
	return this.dataSource.save(id, data, callback, prefix, options);
};

Model.prototype.removeById = function(id, callback, options) {
	return this.dataSource.removeById(id, callback, options);
};

module.exports = Model;
