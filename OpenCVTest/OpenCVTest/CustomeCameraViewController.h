//
//  CustomeCameraViewController.h
//  OpenCVTest
//
//  Created by appled on 2017/11/24.
//  Copyright © 2017年 appled. All rights reserved.
//

/*
 自定义照相机
 */

#import <UIKit/UIKit.h>

typedef void(^returnPhotoImage)(UIImage *photoimage);

typedef void(^returnOCRImage)(UIImage *OCRimage);

@interface CustomeCameraViewController : UIViewController

@property (nonatomic, copy) returnPhotoImage returnphotoBlock;

@property (nonatomic, copy) returnOCRImage returnOCRImageBlock;

@end
