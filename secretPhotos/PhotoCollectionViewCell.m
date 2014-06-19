//
//  PhotoCollectionViewCell.m
//  secretPhotos
//
//  Created by Tom Hutchinson on 17/06/2014.
//  Copyright (c) 2014 Tom Hutchinson. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (void)prepareForReuse {
    _photoImageView.image = [UIImage imageNamed:@"padlock"];
}

@end
