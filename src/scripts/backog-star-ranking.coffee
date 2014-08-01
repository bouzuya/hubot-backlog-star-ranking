# Description
#   A Hubot script that display the ranking of backlog star count.
#
# Dependencies:
#   "q": "^1.0.1",
#   "request": "^2.39.0"
#
# Configuration:
#   HUBOT_BACKLOG_STAR_RANKING_SPACE_ID
#   HUBOT_BACKLOG_STAR_RANKING_API_KEY
#
# Commands:
#   hubot backlog-star-ranking - display the ranking of backlog star count
#
# Author:
#   bouzuya <m@bouzuya.net>
#
{Backlog} = require '../backlog'
{Promise} = require 'q'

module.exports = (robot) ->
  lpad = (s, l) ->
    while s.length < l
      s = ' ' + s
    s

  maxLength = (strings) ->
    strings.reduce (max, s) ->
      if s.length > max then s.length else max
    , 0

  format = (stars) ->
    stars.sort (a, b) -> b.count - a.count
    maxCountLength = maxLength stars.map((star) -> star.count.toString())
    stars.filter (star) ->
      star.count > 0
    .filter (_, i) ->
      i < 10
    .map (star, i) ->
      rank = i + 1
      starCount = lpad(star.count, maxCountLength)
      "#{rank} : #{starCount} stars ...... #{star.user}"
    .join '\n'

  mapSeries = (arr, f) ->
    arr.reduce (promise, item) ->
      promise.then (results) ->
        f(item).then (result) -> results.concat [result]
    , Promise.resolve([])

  robot.respond /backlog-star-ranking$/i, (res) ->
    backlog = new Backlog
      spaceId: process.env.HUBOT_BACKLOG_STAR_RANKING_SPACE_ID
      apiKey: process.env.HUBOT_BACKLOG_STAR_RANKING_API_KEY
    backlog.getUsers()
      .then (users) ->
        mapSeries users, (user) ->
          backlog.getUserStarCount  { params: { userId: user.id } }
            .then (star) ->
              { user: user.name, count: star.count }
      .then (users) ->
        res.send format(users)
      , (e) ->
        robot.logger.error e
