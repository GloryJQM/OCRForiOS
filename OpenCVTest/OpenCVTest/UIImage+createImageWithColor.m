//
//  UIImage+createImageWithColor.m
//  OpenCVTest
//
//  Created by appled on 2017/11/24.
//  Copyright © 2017年 appled. All rights reserved.
//

#import "UIImage+createImageWithColor.h"

@implementation UIImage (createImageWithColor)

#pragma mark - 生成纯色图片
+ (UIImage*)createImageWithColor:(UIColor*)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - 裁剪图片
//返回裁剪区域图片,返回还是原图大小,除图片以外区域清空

+ (UIImage *)clipWithImageRect:(CGRect)imageRect clipRect:(CGRect)clipRect clipImage:(UIImage *)clipImage {
    
    // 开启位图上下文
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, 0);
    
    // 设置裁剪区域
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:clipRect];
    
    [path addClip];
    
    // 绘制图片
    
    [clipImage drawInRect:clipRect];
    
    // 获取当前图片
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

//返回裁剪区域图片,返回裁剪区域大小图片

+ (UIImage *)clipWithImageRect:(CGRect)clipRect clipImage:(UIImage *)clipImage {
    
    UIGraphicsBeginImageContext(clipRect.size);
    
    [clipImage drawInRect:CGRectMake(0,0,clipRect.size.width,clipRect.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


- (UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end
