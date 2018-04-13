//
//  Imageprocess.h
//  OpenCVTest
//
//  Created by appled on 2017/11/22.
//  Copyright © 2017年 appled. All rights reserved.
//






@class UIImage;

typedef void (^CompleateBlock)(NSString *text);

@interface Imageprocess : NSObject

+ (instancetype)recognizeCardManager;

- (UIImage *)getProcessedImage:(UIImage *)image;

- (void)recognizeCardWithImage:(UIImage *)cardImage compleate:(CompleateBlock)compleate;

@end
