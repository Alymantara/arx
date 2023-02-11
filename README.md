# avgrmsx
Maximum likelihood estimator of the mean and intrinsic rms of a time-series dataset (based on Keith Horne's avgrmsx).


## Requirements & Installation
You can compile the cython code inside the folder by using the following command:
```
python setup.py build_ext --inplace
```
This will make the routine available as a standard python package.

## Section 1: The method
<img src="https://render.githubusercontent.com/render/math?math=\ln L = -\frac{1}{2}\sum_i^N\left[\frac{D_i - \langle avg \rangle}{\sigma_t}\right] + 2\ln(\sigma_t)">
where
<img src="https://render.githubusercontent.com/render/math?math=\sigma_t^2 ={\sigma_i^2+{rms}^2}">

## Section 2: Usage
```python
import avgrmsx
avg,avg_err,rms, rms_err = avgrmsx(data,errors)
```
