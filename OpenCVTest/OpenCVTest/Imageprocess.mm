//
//  Imageprocess.m
//  OpenCVTest
//
//  Created by appled on 2017/11/22.
//  Copyright © 2017年 appled. All rights reserved.
//



#import "Imageprocess.h"
#import <TesseractOCR/TesseractOCR.h>

@implementation Imageprocess

+ (instancetype)recognizeCardManager {
    static Imageprocess *recognizeCardManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        recognizeCardManager = [[Imageprocess alloc] init];
    });
    return recognizeCardManager;
}

- (UIImage *)getProcessedImage:(UIImage *)image {
    //将UIImage转换成Mat
    cv::Mat resultImage;
    UIImageToMat(image, resultImage);
    //转为灰度图
    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
//    利用阈值二值化
    cv::threshold(resultImage, resultImage, 50, 255, CV_THRESH_BINARY);
    //腐蚀，填充（腐蚀是让黑色点变大）
    cv::Mat erodeElement = getStructuringElement(cv::MORPH_RECT, cv::Size(1,1));
    cv::erode(resultImage, resultImage, erodeElement);
//    轮廊检测
//    std::vector<std::vector<cv::Point>> contours;//定义一个容器来存储所有检测到的轮廊
//    cv::findContours(resultImage, contours, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cvPoint(0, 0));
//    //取出计数器号码区域
//    std::vector<cv::Rect> rects;
//    cv::Rect numberRect = cv::Rect(0,0,0,0);
//    std::vector<std::vector<cv::Point>>::const_iterator itContours = contours.begin();
//    for ( ; itContours != contours.end(); ++itContours) {
//        cv::Rect rect = cv::boundingRect(*itContours);
//        rects.push_back(rect);
//        //算法原理
//        if (rect.width > numberRect.width  && rect.width > 155) {
//            numberRect = rect;
//            break;
//        }
//    }
//    //计数器号码定位失败
//    if (numberRect.width == 0 || numberRect.height == 0) {
//        return nil;
//    }
//    //定位成功成功，去原图截取身份证号码区域，并转换成灰度图、进行二值化处理
//    cv::Mat matImage;
//    UIImageToMat(image, matImage);
//    resultImage = matImage(numberRect);
//    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
//    cv::threshold(resultImage, resultImage, 80, 255, CV_THRESH_BINARY);
    
    // 第三步 ：克隆一个数据用于美白
    cv::Mat mat_image_clone = resultImage.clone();
    
    // 第四步：开始美白
    for (int i = 1; i < 31; i += 2) {
        // 磨皮效果
        // 参数一：原始图片
        // 参数二：模版图片
        // 参数三：下标
        bilateralFilter(resultImage, mat_image_clone, i, i * 2, i / 2);
    }
    
    
    UIImage *numberImage = MatToUIImage(mat_image_clone);
    return numberImage;
}


- (void)recognizeCardWithImage:(UIImage *)cardImage compleate:(CompleateBlock)compleate {
    //+chi_sim eng
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"num" engineMode:(G8OCREngineModeTesseractOnly)];
        tesseract.image = [cardImage g8_blackAndWhite];
        tesseract.image = cardImage;
        // Start the recognition
        [tesseract recognize];
        //执行回调
        compleate(tesseract.recognizedText);
    });
    
}


- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {//可以根据这个决定使用哪种
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

@end
