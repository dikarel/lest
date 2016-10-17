mockFs = require './fs.mock.coffee'
mock = require 'mock-require'
lest = require '../lib/lest'
expect = require 'expect'

describe 'lest', () ->
  beforeEach () -> mock '../lib/faulty-fs', require 'fs'
  afterEach () -> mock.stopAll()

  it 'returns a stream of named entries for each dir/file under it', (done) ->
    lest('.').toArray (entries) ->
      names = entries.map (e) -> e.name
      expect(names).toInclude 'lib'
      expect(names).toInclude 'faulty-fs.coffee'
      expect(names).toInclude 'package.json'
      expect(names).toInclude 'index.coffee'
      expect(names).toInclude 'spec'
      done()

  describe 'each entry is assigned the appropriate level', () ->

    it 'has a level and name property', (done) ->
      lest('.').toArray (entries) ->
        specEntry = entries.filter((e) -> e.name == 'spec')[0]
        expect(specEntry.level).toBe 1
        lestSpecEntry = entries.filter((e) -> e.name == 'lest.spec.coffee')[0]
        expect(lestSpecEntry.level).toBe 2
        done()

    describe 'whenever there is an error during inspection', () ->
      beforeEach () ->
        mock.stopAll()
        mock '../lib/faulty-fs', mockFs failOn: 'spec'

      afterEach () -> mock.stopAll()

      it 'has an error property', (done) ->
        lest('.').toArray (entries) ->
          erroneousEntries = entries.filter((e) -> e.error)
          expect(erroneousEntries.length).toBe 1
          done()

    describe 'whenever there is a timeout event', () ->
      beforeEach () ->
        mock.stopAll()
        mock '../lib/faulty-fs', mockFs timeoutOn: 'lib'

      afterEach () -> mock.stopAll()

      it 'has an error property', (done) ->
        lest('.').toArray (entries) ->
          erroneousEntries = entries.filter((e) -> e.error)
          expect(erroneousEntries.length).toBe 1
          done()
