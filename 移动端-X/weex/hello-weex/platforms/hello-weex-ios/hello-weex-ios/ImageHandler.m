//
//  ImageHandler.m
//  demo
//
//  Created by Neeeo on 2017/3/12.
//  Copyright © 2017年 NO. All rights reserved.
//

#import "ImageHandler.h"
#import <SDWebImage/SDWebImageManager.h>

@implementation ImageHandler

- (id<WXImageOperationProtocol>)downloadImageWithURL:(NSString *)url imageFrame:(CGRect)imageFrame userInfo:(NSDictionary *)options completed:(void (^)(UIImage *, NSError *, BOOL))completedBlock
{
    if (![self isValidString:url]) {
        return nil;
    }
    
    if ([url hasPrefix:@"//"]) {
        url = [@"http:" stringByAppendingString:url];
    }
    
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    
    id op = [mgr downloadImageWithURL:[NSURL URLWithString:url]
                              options:SDWebImageRetryFailed
                             progress:nil
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (completedBlock) {
                                    completedBlock(image, error, finished);
                                }
                            }];
    return (id<WXImageOperationProtocol>)op;
}

- (BOOL)isValidString:(NSString *)str
{
    if (str && [str isKindOfClass:[NSString class]] && [str length] > 0) {
        return YES;
    }
    
    return NO;
}

@end
