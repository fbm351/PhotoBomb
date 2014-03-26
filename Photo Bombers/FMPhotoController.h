//
//  FMPhotoController.h
//  Photo Bombers
//
//  Created by Fredrick Myers on 3/26/14.
//  Copyright (c) 2014 Fredrick Myers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMPhotoController : NSObject

+ (void)imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion;

@end
