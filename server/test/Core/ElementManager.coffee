expect = require('expect.js')
ElementManager = require('../../src/Core/ElementManager')

describe 'ElementManager.js', ->
    factory = null
    componentInstance = null
    modelInstance = null
    blankFunction = null
    logger = null
    blankFunction = ->
        return

    logger = log: blankFunction
    beforeEach ->
        factory = new ElementManager(logger,
            components:
                MyComponent: blankFunction

            models:
                MyModel: blankFunction

            configs: {}
            core: {}
            logger: logger
            constants: {}
        )
        componentInstance = factory.create('component', 'MyComponent')
        modelInstance = factory.create('model', 'MyModel')
        return

    describe 'init', ->
        it 'should call the init method if defined', (done) ->
            factory = new ElementManager(logger,
                components:
                    MyComponent: ->
                        @init = ->
                            done()
                            return

                        return

                logger: logger
                constants: {}
            )
            componentInstance = factory.create('component', 'MyComponent')
            factory.init componentInstance
            return

        it 'should call the init method if the component() method is used to retrieve AnotherComponent', (done) ->
            factory = new ElementManager(logger,
                components:
                    MyComponent: ->
                        return

                    AnotherComponent: ->
                        @init = ->
                            done()
                            return

                        return

                logger: logger
                constants: {}
            )
            componentInstance = factory.create('component', 'MyComponent')
            componentInstance.component 'AnotherComponent'
            return

        return

    describe 'create', ->
        describe 'model', ->
            it 'should not return the same instance if called twice', ->
                expect(modelInstance).not.to.be.equal factory.create('model', 'MyModel')
                return

            it 'should create the model and inject the name property', ->
                expect(modelInstance.name).to.be 'MyModel'
                return

            it 'should create the model and inject the configs property', ->
                expect(modelInstance.configs).to.an 'object'
                return

            it 'should inject the application constants', ->
                expect(modelInstance.constants).to.be.ok()
                return

            it 'should inject the method for retrieving components', ->
                expect(modelInstance.component('InvalidComponent')).to.be null
                return

            it 'should inject the method for retrieving models', ->
                myModel = modelInstance.model('MyModel')
                expect(myModel.name).to.be 'MyModel'
                expect(modelInstance.model('InvalidModel')).to.be null
                return

            it 'should inject the method for retrieving models inside the models retrieved by the model method', ->
                expect(modelInstance.model('MyModel').model('MyModel').name).to.be 'MyModel'
                return

            return

        describe 'component', ->
            it 'should pass the params to the component constructor', (done) ->
                factory = new ElementManager(logger,
                    components:
                        MyComponent: (params) ->
                            expect(params.key).to.be 'value'
                            done()
                            return

                    core: {}
                    logger: logger
                    constants: {}
                )
                componentInstance = factory.create('component', 'MyComponent',
                    key: 'value'
                )
                return

            it 'should not return the same component componentInstance if called twice', ->
                anotherInstance = factory.create('component', 'MyComponent')
                expect(componentInstance).not.to.be.equal anotherInstance
                return

            it 'should create the component and inject the name property', ->
                expect(componentInstance.name).to.be 'MyComponent'
                return

            it 'should inject the application constants', ->
                expect(componentInstance.constants).to.be.ok()
                return

            it 'should create the model and inject the application core object (configurations)', ->
                expect(componentInstance.core).to.be.an 'object'
                return

            it 'should create the model and inject the application configs object (all configuration files)', ->
                expect(componentInstance.configs).to.be.an 'object'
                return

            it 'should inject the method for retrieving components', ->
                expect(componentInstance.component('InvalidComponent')).to.be null
                return

            it 'should inject the method for retrieving components inside the components retrieved by the component method', ->
                expect(componentInstance.component('MyComponent').component('MyComponent').name).to.be 'MyComponent'
                return

            it 'should inject the method for retrieving models', ->
                expect(componentInstance.model('InvalidModel')).to.be null
                return

            it 'should always return the same componentInstance if the component is marked as singleInstance', ->
                factory = new ElementManager(logger,
                    components:
                        MyComponent: ->
                            @singleInstance = true
                            return

                    core: {}
                    logger: logger
                )
                componentInstance = factory.create('component', 'MyComponent')
                expect(factory.create('component', 'MyComponent')).to.be componentInstance
                expect(factory.getComponents()).to.have.length 1
                expect(factory.getComponents()).to.contain componentInstance
                return

            it 'should always return a different componentInstance if the component is not marked as singleInstance', ->
                factory = new ElementManager(logger,
                    components:
                        MyComponent: ->
                            return

                    core: {}
                    logger: logger
                )
                componentInstance = factory.create('component', 'MyComponent')
                componentInstance2 = factory.create('component', 'MyComponent')
                expect(componentInstance2).not.to.be componentInstance
                expect(factory.getComponents()).to.have.length 2
                expect(factory.getComponents()).to.contain componentInstance
                expect(factory.getComponents()).to.contain componentInstance2
                return

            return

        return

    return