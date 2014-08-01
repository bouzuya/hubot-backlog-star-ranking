# hubot-backlog-star-ranking

A Hubot script that display the ranking of backlog star count.

## Installation

    $ npm install git://github.com/bouzuya/hubot-backlog-star-ranking.git

or

    $ # TAG is the package version you need.
    $ npm install 'git://github.com/bouzuya/hubot-backlog-star-ranking.git#TAG'

## Usage

    bouzuya> hubot help backlog-star-ranking
    hubot> hubot backlog-star-ranking - display the ranking of backlog star count

    bouzuya> hubot backlog-star-ranking
    hubot>   1 : 6 stars ...... bouzuya
             2 : 2 stars ...... emanon001

See [`src/scripts/backlog-star-ranking.coffee`](src/scripts/backlog-star-ranking.coffee) for full documentation.

## License

MIT

## Development

### Run test

    $ npm test

### Run robot

    $ npm run robot

## Badges

[![Build Status][travis-status]][travis]

[travis]: https://travis-ci.org/bouzuya/hubot-backlog-star-ranking
[travis-status]: https://travis-ci.org/bouzuya/hubot-backlog-star-ranking.svg?branch=master
