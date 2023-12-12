# avgrmsx
Maximum likelihood estimator of the mean and intrinsic rms of a time-series dataset (based on Keith Horne's avgrmsx). For a detail description of the method, see Keith Horne's lecture on the subject at http://star-www.st-and.ac.uk/~kdh1/ada/ada12.pdf


## Requirements & Installation
You can compile the cython code inside the folder by using the following command:
```
python setup.py build_ext --inplace
```
This will make the routine available as a standard python package.

## Section 1: The method
avgrmsx measures the optimally weighted average $`\langle D \rangle`$ of a data set $`D`$ with $`N`$ measurements and associated uncertainties, where:
```math
{\rm avg}=\langle D \rangle = \frac{\sum\limits_{i} D_i \cdot w_i}{\sum\limits_{i} w_i},
```
where the weights, $`w_i`$, are the inverse of the variance of each datapoint,
```math
w_i = \frac{1}{\sigma_i^2},
```
where $`\sigma_i`$ is the uncertainty of each datapoint.

The routine calculates this optimal average as well as an additional dispersion $`rms`$ not quantified by the uncertainty in the data. The routine maximises the following likelihood:
```math
-2\ln L = \sum\limits_{i}^{N}\left[\frac{\left(D_i - \langle D \rangle\right)^2}{\sigma_t^2}\right] +\sum\limits_{i}^{N}\ln(\sigma_t^2)
```
where the total variance for the model $`\sigma_t`$:
```math
\sigma_t^2 ={\sigma_i^2 + {rms}^2}
```

## Section 2: Usage
```python
import avgrmsx
avg,avg_err,rms, rms_err = avgrmsx(data,errors)
```
