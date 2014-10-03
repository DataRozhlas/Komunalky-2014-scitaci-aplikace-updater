require! {
  expect: 'expect.js'
  redis
  './config.ls'
  '../src/UpdateEmitter.ls'
}

describe "UpdateEmitter" (_) ->
  redisClient = null
  redisSubscriber = null
  updateEmitter = null

  before (done) ->
    redisClient := redis.createClient config.redis.port, config.redis.host
    <~ redisClient.auth config.redis.key
    <~ redisClient.select config.redis.db
    <~ redisClient.flushdb!
    redisSubscriber := redis.createClient config.redis.port, config.redis.host
    <~ redisSubscriber.auth config.redis.key
    <~ redisSubscriber.select config.redis.db
    done!
  it 'should costruct' ->
    updateEmitter := new UpdateEmitter {interval: 30}, redisSubscriber

  it 'should emit batches of updates' (done) ->
    redisClient.publish "update" "5125"
    redisClient.publish "update" "5126"
    redisClient.publish "update" "5127"
    redisClient.publish "update" "senat"
    updateEmitter.once \updates (messages) ->
      expect messages .to.have.length 4
      expect messages .to.contain "5125"
      expect messages .to.contain "5126"
      expect messages .to.contain "5127"
      expect messages .to.contain "senat"
      done!
