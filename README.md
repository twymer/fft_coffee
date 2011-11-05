Fast Fourier Transforms in CoffeeScript
=======================================
What does it do?
----------------
A Fourier Transform decomposes a signal into constituent frequencies.
This is useful if you have time based data, but want information about the frequencies of the data.

A Fast Fourier Transform (FFT) is a fast algorithm for computing the Fourier transform.
It runs in `nlog(n)` time, compared to `n^2` for discrete Fourier transform algorithms.

Fourier transforms are lossless transformations: time domain data can be converted to frequency domain, and then back into the time domain.

Read more:

* [Wikipedia: Fourier Transform](http://en.wikipedia.org/wiki/Fourier_transform)
* [Wikipedia: Fast Fourier Transform](http://en.wikipedia.org/wiki/Fft)


How do I use it?
----------------
### Primary Frequency
A common use of FFT's is to determine the primary frequency (or strongest frequency) of a set of data.

```coffeescript
data = [1,2,3,..]
sample_rate = 44100
primary_freq = new Fft(data, sample_rate).forward().primary_frequency()
```

### Frequency and amplitude data
```coffeescript
data = [1,2,3,..]
sample_rate = 44100
fft = new Fft(data, sample_rate).forward()
freqs = fft.frequencies()
amps  = fft.amplitudes()
```

### Determine the amplitude of a specific frequency
```coffeescript
data = [1,2,3,..]
sample_rate = 44100
fft = new Fft(data, sample_rate).forward()
freq = 10000
amp = fft.amplitude(freq)
```


FAQ
---
#### Is this library intended to be used in the browser, or node?
I use it in both.

#### Is it fast?
It's pretty fast. My laptop can compute the FFT for a data set of size 65536 in less than 0.1 seconds.

#### Does the input data length have to be a power of 2?
No.

#### What about imaginary numbers?
By default, this library assumes the incoming data is an array of alternating real, and imaginary components.
If you have only real data, you can pass a preprocessing function as the third argument to the constructor.
Check out src/preprocessor.


I want to use this library in my project!
-----------------------------------------
Go for it!
