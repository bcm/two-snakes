"use strict"

class Die
  @roll: (num, scale, options = {}) =>
    results = (Math.floor(Math.random() * scale+1) for n in [1..num])
    if options.dropLowest?
      results.sort (a, b) => a - b
      results = _.tail(results)
    _.reduce(results, ((m, v) => m + v), 0)

window.Die = Die
