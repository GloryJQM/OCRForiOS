//
//  UIImage+createImageWithColor.h
//  OpenCVTest
//
//  Created by appled on 2017/11/24.
//  Copyright © 2017年 appled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (createImageWithColor)

+ (UIImage*)createImageWithColor:(UIColor*)color;

+ (UIImage *)clipWithImageRect:(CGRect)imageRect clipRect:(CGRect)clipRect clipImage:(UIImage *)clipImage;

+ (UIImage *)clipWithImageRect:(CGRect)clipRect clipImage:(UIImage *)clipImage;

- (UIImage*)getSubImage:(CGRect)rect;

@end
