---
format:
  pdf:
    documentclass: llncs
    classoption: runningheads
    pdf-engine: pdflatex
    cite-method: natbib
    biblio-style: splncs04
    natbiboptions: "numbers,sort,compress,sectionbib"
    number-sections: true
    number-depth: 3
bibliography: bibliography.bib
---

\title{Lab 9: Fast Fourier Transform (FFT)}
\titlerunning{Lab 9: FFT Analysis}

\author{Vladyslav Humeniuk}
\authorrunning{Vladyslav Humeniuk}
\institute{}
\maketitle

## Introduction {#sec-intro}

The objective of this laboratory was to explore the basic data processing capabilities of Fourier transforms, particularly in the context of signal and sound processing. Using the GNU Scientific Library (GSL), we empirically verified the Fast Fourier Transform (FFT) for both signal analysis and noise reduction. The Discrete Fourier Transform (DFT) allows us to decompose time-domain signals into constituent frequencies, which is a fundamental technique for tasks like audio filtering that are difficult to perform directly in the time domain. This report details the process of signal generation, spectral analysis, and noise remediation through forward and inverse transforms.

## Methodology

The computational tasks followed the six stages outlined in the laboratory requirements:

1. **Signal Generation**: Synthesis of a 256-element array representing a sum of four cosines with varying periods and amplitudes.
2. **Spectral Analysis**: Extraction of the frequency spectrum using the `gsl_fft_real_radix2_transform` function.
3. **Noisy Signal Simulation**: Corruption of a simple cosine wave with random white noise.
4. **Noise Spectrum Visualization**: Use of FFT to analyze the frequency distribution of the stochastic interference.
5. **Frequency Filtering**: Implementation of a threshold filter to zero out spectral components with a magnitude below 50.
6. **Inverse Transform**: Signal reconstruction using `gsl_fft_halfcomplex_radix2_inverse`.

\newpage

## Results

### Task 1: Generated Signal
As shown in Fig. \ref{fig-signal}, the initial composite signal consists of four cosine components. It exhibits a complex periodic structure where high-frequency ripples are superimposed on the main wave.

![Generated multi-component cosine signal.](1_signal.pdf){#fig-signal width=100% fig-pos='H'}

\newpage

### Task 2: Frequency Spectrum
The FFT results in Fig. \ref{fig-spectrum} reveal four distinct peaks in the frequency domain. These peaks correspond exactly to the coefficients 4, 16, 32, and 128 used during signal generation.

![Frequency spectrum showing distinct peaks for each signal component.](2_spectrum.pdf){#fig-spectrum width=100% fig-pos='H'}

\newpage

### Task 3: Noisy Signal
The addition of random noise, visualized in Fig. \ref{fig-noisy-sig}, results in a jagged time-domain function. The primary oscillation is obscured by rapid, unpredictable fluctuations.

![Signal obscured by random white noise.](3_noisy_signal.pdf){#fig-noisy-sig width=100% fig-pos='H'}

\newpage

### Task 4: Spectrum of Noisy Signal
In the frequency domain, the noise manifests as a broad "floor" of low-magnitude components surrounding the main signal peak, as seen in Fig. \ref{fig-noisy-spec}.

![Frequency spectrum of the noisy signal showing wide-band interference.](4_noisy_spectrum.pdf){#fig-noisy-spec width=100% fig-pos='H'}

\newpage

### Task 5: Threshold Filtering
By zeroing all components with a magnitude less than 50 (Fig. \ref{fig-filtered-spec}), the random noise floor is eliminated. This process preserves only the high-magnitude signal peak.

![Filtered spectrum with noise floor removed.](5_filtered_spectrum.pdf){#fig-filtered-spec width=100% fig-pos='H'}

\newpage

### Task 6: Reconstructed Signal
The inverse transform produces the smoothed wave shown in Fig. \ref{fig-inversion}. This reconstructed signal successfully recovers the original periodicity and lacks the high-frequency spikes of the noisy input.

![Smoothed signal reconstructed after noise removal and inverse FFT.](6_inverse_signal.pdf){#fig-inversion width=100% fig-pos='H'}

## Conclusion

The laboratory successfully demonstrated the utility of the Fast Fourier Transform in digital signal and sound processing [@gsl_fft_doc]. We used forward transforms to identify specific frequencies within a complex signal and implemented a threshold filter in the frequency domain as an effective method for noise reduction. The final reconstructed signal confirms that spectral filtering can remove significant random interference while preserving the essential characteristics of the underlying data [@fft_theory].
