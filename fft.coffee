class FFT
  forward: (data, has_imaginary) ->
    fft_data = []
    if !has_imaginary?
      for elem in data
        fft_data.push elem
        fft_data.push 0
    else
      fft_data = data.slice(0)

    next_power = Math.ceil(Math.log(fft_data.length) / Math.log(2))
    extended_length = Math.pow(2, next_power)
    while fft_data.length < extended_length
      fft_data.push 0

    data_size = fft_data.length / 2
    isign = 1
    this.fourier_transform(fft_data, data_size, isign)
    fft_data

  fourier_transform: (data, n, isign) ->
    self = @
    nn = n << 1
    j = 1

    for i in [1...nn] by 2
      if (j > i)
        self._swap(data, j-1, i-1)
        self._swap(data, j, i)
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

  _swap: (data, i, j) ->
    temp = data[i]
    data[i] = data[j]
    data[j] = temp


module.exports = FFT
