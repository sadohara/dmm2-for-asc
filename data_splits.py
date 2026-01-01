import sys
import subprocess

def data_splits_from_fold(folds):
    data_splits = []
    for i in range(len(folds)):
        test_fold = folds[i]
        valid_fold = folds[(i+1)%len(folds)]
        train_folds = [f for f in folds if f not in (test_fold, valid_fold)]
        data_splits.append(
                {
                    'train': train_folds,
                    'valid': [valid_fold],
                    'test': [test_fold],
                    'outdir': test_fold
                }
        )
    return data_splits


def oneday_data_splits_from_fold(folds):
    data_splits = []
    for i in range(len(folds)):
        test_fold = folds[i]
        valid_fold = folds[(i+1)%len(folds)]
        remaining_folds = [f for f in folds if f not in (test_fold, valid_fold)]
        for train_fold in remaining_folds:
            data_splits.append(
                {
                    'train': [train_fold],
                    'valid': [valid_fold],
                    'test': [test_fold],
                    'outdir': '%s.%s' % (test_fold, train_fold)
                }
            )
    return data_splits

def data_splits_from_fold_fixeval(folds):
    data_splits = []
    for i in range(len(folds)-1):
        test_fold = folds[0]
        valid_fold = folds[i+1]
        train_folds = [f for f in folds if f not in (test_fold, valid_fold)]
        data_splits.append(
                {
                    'train': train_folds,
                    'valid': [valid_fold],
                    'test': [test_fold],
                    'outdir': '%s.%s' % (test_fold, valid_fold)
                }
        )
    return data_splits

def data_splits_from_fold_fixevalT1V1(folds):
    data_splits = []
    for i in range(len(folds)-1):
        test_fold = folds[0]
        train_fold = folds[i+1]
        remaining_folds = [f for f in folds if f not in (test_fold, train_fold)]
        for valid_fold in remaining_folds:
           data_splits.append(
                {
                    'train': [train_fold],
                    'valid': [valid_fold],
                    'test': [test_fold],
                    'outdir': '%s.%s' % (test_fold, train_fold)
                }
        )
    return data_splits

def swapped_data_splits_from_folds(folds):
    data_splits = []
    for i in range(len(folds)):
        train_fold = folds[i]
        valid_fold = folds[(i+1)%len(folds)]
        test_folds = [f for f in folds if f not in (train_fold, valid_fold)]
        data_splits.append(
                {
                    'train': [train_fold],
                    'valid': [valid_fold],
                    'test': test_folds,
                    'outdir': train_fold
                }
        )
    return data_splits


def split_data(way_of_split, folds):
    if way_of_split == 'E1V1T1':
        data_splits = oneday_data_splits_from_fold(folds)
    elif way_of_split == 'E1V1To':
        data_splits = data_splits_from_fold(folds)
    elif way_of_split == 'E1V1Tx':
        data_splits = data_splits_from_fold(folds)
    elif way_of_split == 'FixEvalV1To':
        data_splits = data_splits_from_fold_fixeval(folds)
    elif way_of_split == 'FixEvalT1V1':
        data_splits = data_splits_from_fold_fixevalT1V1(folds)
    elif way_of_split == 'T1V1Ex':
        data_splits = swapped_data_splits_from_folds(folds)
    else:
        assert False, "Not supported!"

    return data_splits


