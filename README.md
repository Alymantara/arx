# avgrmsx
Maximum likelihood estimator of the mean and intrinsic rms of a time-series dataset (based on Keith Horne's avgrmsx).


## Requirements & Installation
You can compile the cython code inside the folder by using the following command:
```
python setup.py build_ext --inplace
```
This will make the routine available as a standard python package.

## Section 1: The method

## Section 2: Usage
```python
import avgrmsx
avg,avg_err,rms, rms_err = avgrmsx(data,errors)
```
