vows         = require 'vows'
assert       = require 'assert'
Fft          = require './fft'
Preprocessor = require './preprocessor'

test = vows.describe('fft').addBatch
  'when processing a pure sin wave':

    # Choose 256 points per period to ensure high enough resolution, then set
    # the sampling frequency to be 256 to get a frequency of 1.
    topic: () ->
      (Math.sin(x) for x in [0...(16 * 2 *Math.PI)] by Math.PI / 128.0)

    'basic sin wave': (topic) ->
      sample_rate = 256
      fft = new Fft(sample_rate)
      fft.forward(topic, Preprocessor.process)
      assert.equal fft.primary_frequency(), 1

  'when processing a high frequency pure sin wave':
    topic: () ->
      (Math.sin(8 * x) for x in [0...(16 * 2 *Math.PI)] by Math.PI / 128.0)

    'higher frequency sin wave': (topic) ->
      sample_rate = 256
      fft = new Fft(sample_rate)
      fft.forward(topic, Preprocessor.process)
      assert.equal fft.primary_frequency(), 8

  'multi frequency sin wave':
    topic: () ->
      (Math.sin(x) + Math.sin(16*x) for x in [0...(16 * 2 *Math.PI)] by Math.PI / 128.0)

    'multi frequency sin wave': (topic) ->
      sample_rate = 256
      fft = new Fft(sample_rate)
      fft.forward(topic, Preprocessor.process)
      assert.isTrue fft.amplitude(1) > 1000
      assert.isTrue fft.amplitude(16) > 1000
      assert.isFalse fft.amplitude(2) > 1
      assert.isFalse fft.amplitude(4) > 1
      assert.isFalse fft.amplitude(8) > 1
      assert.isFalse fft.amplitude(32) > 1

  'forward and reverse':
    topic: () ->
      (Math.sin(x) for x in [0...(16 * 2 *Math.PI)] by Math.PI / 128.0)

    'reverse and forward are inverse operations': (topic) ->
      sample_rate = 256
      fft = new Fft(sample_rate)
      result = fft.reverse(fft.forward(topic))
      for i in [0...topic.length]
        assert.isTrue(Math.abs(result[i] - topic[i]) < 1e-12)

test.run()
