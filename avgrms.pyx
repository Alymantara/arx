#cython: boundscheck=False, wraparound=False, nonecheck=False
import numpy as np
cimport numpy as np
from libc.math cimport exp,pow, abs,log, cos, ceil


def avgrmsx(double[:] dat, double[:] sig,
            int nloop=1000):
    """
    avgrmsx(data, sig, nloop=100)

    Routine to calculate the average and additional 
    scatter on a dataset

    Parameters
    ----------
    data  :  float array
        Data array
    sig  : float
        1-sigma uncertainties on the data array
    nloop : int, optional
        Number of maximum iterations

    Returns
    ----------
    avg  : float
        Average of the data
    avg_err: float
        1-sigma errorbar on the average
    sig0  : float
        Additional scatter
    sig0: float
        1-sigma errorbar on the scatter

    References
    ----------
    .. [1] Based on avgrmsx.for written by Keith Horne

    Examples
    --------
    Calculate the average of a dataset

    >>>
    >>> avgo = 0, 0.1 # mean and standard deviation
    """
    ###################
    cdef int extra_ind, i, j,ng
    cdef double avg,rms,e1,w,sigavg,tiny,rmin
    cdef double chiavg, chirms, test, oldavg,oldrms,sigrms
    cdef double sum1, sumg, sumo, sum2, sum3,siga,sigr
    cdef double a,r, rr, gg, safe, d, e,g,x, xx

    ############ 
    ng = len(dat)




    avg = 0.
    rms = 0.

    # mean of positive error bars
    for i in range(ng):
        e1 = e1 + sig[i]
    e1 = e1/ng

    #initial estimate
    for i in range(ng):
        w = (e1 / sig[i])**2
        sum1 = sum1 + dat[i] * w
        sum2 = sum2 + w

    # optimal average and its variance
    avg = sum1 / sum2
    sigavg = e1 / pow( sum2,0.5 )
    # scale factor ( makes <1/sig^2>=1 )
    w = ng / sum2
    e1 = e1 * pow( w ,0.5)
    # estimate for rms
    rms = e1

    # convergence threshold
    tiny = 2.0e-5
    #* lower limit for extra rms
    rmin = tiny * e1

    ## KDH : NO LONGER NEEDED ?
    #if rmin < 0.:
    #    print('** WARNING in AVGRMSX : rmin not positive :(')
    #    print(' sum1', sum1, ' sum2', sum2, ' ng', ng)
    #    print(' avg', avg, ' sigavg', sigavg)
    #    print('  e1', e1, ' rmin', rmin)

    for loop in range(nloop):
        oldavg = avg
        oldrms = rms
        #* scaled avg and rms
        a = avg / e1
        r = rms / e1
        rr = r * r
        for i in range(ng):
            #* scale data and error bar
            d = dat[i] / e1
            e = sig[i] / e1

            #* "goodness" of this data point
            g = rr / ( rr + e * e )
            x = g * ( d - a )
            xx = x * x

            #* increment sums

            sum1 = sum1 + g * d
            sumg = sumg + g
            sumo = sumo + g * g
            sum2 = sum2 + xx
            sum3 = sum3 + g * xx

        #* "good" data points ( e.g. with sig < rms )
        good = sumg

        if sumg <= 0.0: 
            print('ERROR in AVGRMSX. NON-POSITIVE SUM(G)=', sumg)
            break

        #* revise avg and rms
        a = sum1 / sumg
        r = pow( sum2, 0.5 ) / pow( sumg, 0.5 )
        r = np.max( [rmin, r] )

        #* error bars on scaled avg and rms
        siga = r / pow( sumg,0.5 )
        gg = 2.0 * ( 2.0 * sum3 / sum2 * sumg - sumo )
        sigr = r
        if gg > 0.0: sigr = r / pow( gg ,0.5)

        #* restore scaling
        avg = a * e1
        rms = r * e1
        sigavg = siga * e1
        sigrms = sigr * e1

        #* KDH: CATCH SUM2=0 (NO VARIANCE)
        if sum2 <= 0.0:
            rms = 0.0
            sigrms = -1
            print("NO VARIANCE")
            break

        #* converge when test < 1
        if loop > 1:
            #step
            safe = 0.9
            avg = oldavg * (1.0 - safe) + safe * avg
            rms = oldrms * ( 1. - safe ) + safe * rms
            # chi
            chiavg = ( avg - oldavg ) / sigavg
            chirms = ( rms - oldrms ) / sigrms
            test = np.max( [abs( chiavg ), abs( chirms ) ]) / tiny


            #if loop > nloop - 4:
            #    print('Loop', loop, ' of', nloop, ' in AVGRMSX')
            #    print('Ndat', n, ' Ngood', good, ' Neff', g)
            #    print(' avg', avg, ' rms', rms)
            #    print(' +/-', sigavg, ' +/-', sigrms)
            #    print(' chiavg', chiavg, ' chirms', chirms, ' test', test)
            #    if test < 1.: print('** CONVERGED ** :))')
            # Converged
            if test < 1.0: 
                print('** CONVERGED ** :))', loop)
                break

        # quit if rms vanishes
        if rms <= 0.0: break

    return avg,sigavg,rms,sigrms

