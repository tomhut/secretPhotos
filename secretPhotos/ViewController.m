//
//  ViewController.m
//  secretPhotos
//
//  Created by Tom Hutchinson on 17/06/2014.
//  Copyright (c) 2014 Tom Hutchinson. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCollectionViewCell.h"

@import LocalAuthentication;

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
            
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

static NSString * const cellReuseIdentifier = @"secretPhotoCell";

+ (NSArray *)secretImageNamesArray {
    return @[@"jony", @"tim", @"craig", @"scott"];
}
            
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[ViewController secretImageNamesArray] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self authenticateImageForIndexPath:indexPath];
}

#pragma mark - Local Authentication
- (void)authenticateImageForIndexPath:(NSIndexPath *)indexPath {
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError;
    NSString *myLocalizedReasonString = @"Super Secret Photo, Please Authenticate.";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                //Ensure on main queue before doing any UI
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (success) {
                                        [self revealImageAtIndexPath:indexPath];
                                    } else {
                                        [self handleLocalAuthenticationError:error];
                                    }
                                });
                            }];
    } else {
        //Could not evaluate policy
        [self handleLocalAuthenticationError:authError];
    }
}

- (void)handleLocalAuthenticationError:(NSError *)error {
    switch (error.code) {
        case LAErrorAuthenticationFailed:
            NSLog(@"Could not Authenticate");
            break;
        case LAErrorUserCancel:
            NSLog(@"User tapped cancel");
            break;
        case LAErrorUserFallback:
            NSLog(@"User tapped password fallback button");
            break;
        case LAErrorSystemCancel:
            NSLog(@"System canceled local authentication");
            break;
        case LAErrorPasscodeNotSet:
            NSLog(@"User has not set a passcode");
            break;
        case LAErrorTouchIDNotAvailable:
            NSLog(@"Touch ID not avaliable");
            break;
        case LAErrorTouchIDNotEnrolled:
            NSLog(@"No fingers enrolled in Touch ID");
            break;
        default:
            NSLog(@"Unknown local authentication error: %@", error.localizedDescription);
            break;
    }
}

#pragma mark - Reveal Photo
- (void)revealImageAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    cell.photoImageView.image = [UIImage imageNamed:[[ViewController secretImageNamesArray] objectAtIndex:indexPath.row]];
}

@end
