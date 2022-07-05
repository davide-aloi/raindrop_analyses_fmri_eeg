
    #This checks electrodes that are outliers (using the unfiltered raw data)
    print(f'Bad channels based on z-point > 3.0, {ctime()}')
    from preprocessing.is_outlier import is_outlier
    data, times = raw[picks, :] #Done on unfiltered data
    outliers = is_outlier(data, 3.0)
    outlier_electrodes = []; #This array will contain bad electrodes (electrodes that differ a lot from all the others)
    for x in range(0, len(outliers)):
        if outliers[x] == 1:
            print ("Electrode %d should be checked." % (x+1))
            outlier_electrodes.append(x+1)
    print(f'Bad channels with z > 3.0: {outliers.sum()}')
    print('Channels: ')
    print(outlier_electrodes)
