Preprocessor =
  process: (fft_data) ->
    sum = 0
    for elem in fft_data
      sum += elem
    avg = sum / fft_data.length

    data = []
    for elem in fft_data
      data.push elem - avg
      data.push 0
    data


if window?
  window.Preprocessor = Preprocessor
else
  module.exports = Preprocessor
