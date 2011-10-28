class Fft
  constructor: (@sample_rate) ->

  # Public
  reset: ->
    @data = null

  # Public
  magnitude: ->
    mags = []
    for i in [0...@data.length / 2] by 2
      mags.push Math.sqrt(Math.pow(@data[i], 2) + Math.pow(@data[i+1], 2))
    mags

  # Public
  frequency: (band) ->
    width = @sample_rate / (@data.length / 2)
    width * band

  # Public
  forward: (fft_data, processor) ->
    if processor
      data = processor(fft_data)
    else
      data = fft_data.slice(0)

    isign = 1
    this.pad(data)
    this.fourier_transform(data, data.length / 2, isign)
    @data = data

  # Private
  fourier_transform: (data, n, isign) ->
    self = @
    nn = n << 1
    j = 1

    for i in [1...nn] by 2
      if (j > i)
        self.swap(data, j-1, i-1)
        self.swap(data, j, i)
      m = n

      while(m >= 2 && j > m)
        j -= m
        m >>= 1
      j += m

    mmax = 2
    while nn > mmax
      istep = mmax << 1
      theta = isign*(Math.PI*2/mmax)
      wtemp = Math.sin(0.5 * theta)
      wpr = -2.0 * wtemp * wtemp
      wpi = Math.sin(theta)
      wr = 1.0
      wi = 0.0
      for m in [1...mmax] by 2
        for i in [m..nn] by istep
          j = i + mmax
          tempr = wr * data[j-1] - wi * data[j]
          tempi = wr * data[j] + wi * data[j-1]
          data[j-1] = data[i-1] - tempr
          data[j] = data[i] - tempi
          data[i-1] += tempr
          data[i] += tempi
        wr = (wtemp = wr) * wpr - wi * wpi + wr
        wi = wi * wpr + wtemp * wpi + wi
      mmax = istep

  # Private
  pad: (data) ->
    next_power = Math.ceil(Math.log(data.length) / Math.log(2))
    extended_length = Math.pow(2, next_power)
    while data.length < extended_length
      data.push 0

  # Private
  swap: (data, i, j) ->
    temp = data[i]
    data[i] = data[j]
    data[j] = temp


module.exports = Fft
