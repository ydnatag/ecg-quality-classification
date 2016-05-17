function [ baseline ] = BaseLineEstimation ( noisyECG , SamplingFreq )

    WinSize = round(0.2*SamplingFreq);

    baseline = MedianFilt(noisyECG, WinSize );

    WinSize = round(0.6*SamplingFreq);

    baseline = MedianFilt(baseline, WinSize );

end

