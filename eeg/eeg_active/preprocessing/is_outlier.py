def is_outlier(points, thresh=3.5):

    if len(points.shape) == 1:
        points = points[:,None]

    import numpy as np
    
    median = np.median(points, axis=0)
    diff = np.sqrt(np.sum((points - median)**2, axis=-1))
    med_abs_deviation = np.median(diff)

    modified_z_score = 0.6745 * diff / med_abs_deviation

    return modified_z_score > thresh
