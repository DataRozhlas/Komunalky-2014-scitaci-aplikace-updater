require! {
  events.EventEmitter
}
module.exports = class UpdateEmitter extends EventEmitter
  (config, @redisSubscriber) ->
    @queue = []
    @redisSubscriber
      ..subscribe "update"
      ..on \message @~onUpdate
    setInterval @~dispense, config.interval

  onUpdate: (channel, message) ->
    @queue.push message

  dispense: ->
    return unless @queue.length
    @emit "updates" @queue.slice!
    @queue.length = 0
