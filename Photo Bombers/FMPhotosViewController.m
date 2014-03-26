//
//  FMPhotosViewController.m
//  Photo Bombers
//
//  Created by Fredrick Myers on 3/25/14.
//  Copyright (c) 2014 Fredrick Myers. All rights reserved.
//

#import "FMPhotosViewController.h"
#import "FMPhotoCell.h"
#import <SimpleAuth/SimpleAuth.h>

@interface FMPhotosViewController ()

@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSArray *photos;

@end

@implementation FMPhotosViewController

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(106.0, 106.0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    return (self = [super initWithCollectionViewLayout:layout]);
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[FMPhotoCell class] forCellWithReuseIdentifier:@"photo"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.title = @"Photo Bombers";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    
    if (self.accessToken == nil) {
        [SimpleAuth authorize:@"instagram" completion:^(NSDictionary *responseObject, NSError *error) {
            NSString *accessToken = responseObject[@"credentials"][@"token"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:accessToken forKey:@"accessToken"];
            [userDefaults synchronize];
        }];
    }
    else
    {
        [self refresh];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.photo = self.photos[indexPath.row];
    return cell;
}

#pragma mark - Helper Methods

- (void)refresh
{
    //NSLog(@"Signed in!");
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/photobomb/media/recent?access_token=%@", self.accessToken];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        self.photos = [responseDictionary valueForKeyPath:@"data"];
        //NSLog(@"Photos: %@", self.photos);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    [task resume];
    
}

@end
