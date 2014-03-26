//
//  FMPhotoCell.m
//  Photo Bombers
//
//  Created by Fredrick Myers on 3/25/14.
//  Copyright (c) 2014 Fredrick Myers. All rights reserved.
//

#import "FMPhotoCell.h"

@implementation FMPhotoCell

-(void)setPhoto:(NSDictionary *)photo
{
    _photo = photo;
    
    NSURL *url = [[NSURL alloc] initWithString:_photo[@"images"][@"standard_resolution"][@"url"]];
    [self downloadPhotoWithURL:url];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}

- (void)downloadPhotoWithURL:(NSURL *)url
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        UIImage *image = [[UIImage alloc] initWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    }];
    
    [task resume];
}

@end
