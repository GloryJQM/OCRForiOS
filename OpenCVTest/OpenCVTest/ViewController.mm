//
//  ViewController.m
//  OpenCVTest
//
//  Created by appled on 2017/11/22.
//  Copyright © 2017年 appled. All rights reserved.
//

#import "Imageprocess.h"
#import "ViewController.h"
#import "CustomeCameraViewController.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UIImagePickerController *imgagePickController;
}

@property (nonatomic, strong) UIImageView *imagview;

@property (nonatomic, strong) UIImageView *ocrImagview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.imagview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 375, 300)];
    self.imagview.backgroundColor = [UIColor lightGrayColor];
    self.imagview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSelect)];
    self.imagview.contentMode = UIViewContentModeScaleAspectFit;
    [self.imagview addGestureRecognizer:tap];
    [self.view addSubview:self.imagview];
    
    self.ocrImagview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 354, 375, 300)];
    self.ocrImagview.backgroundColor = [UIColor lightGrayColor];
    self.ocrImagview.userInteractionEnabled = YES;
    self.ocrImagview.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.ocrImagview];
    
    
    imgagePickController = [[UIImagePickerController alloc] init];
    imgagePickController.delegate = self;
    imgagePickController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    imgagePickController.allowsEditing = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void)imageSelect {
    CustomeCameraViewController *vc = [[CustomeCameraViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
    vc.returnphotoBlock = ^(UIImage *photoimage) {
        self.imagview.image = photoimage;
    };
    __weak typeof(self) weakself = self;
    vc.returnOCRImageBlock = ^(UIImage *OCRimage) {
        //图像合成之后的图片
        //转交给opencv进行处理
        self.ocrImagview.image = [[Imageprocess recognizeCardManager] getProcessedImage:OCRimage];
        //转交OCR识别
        [[Imageprocess recognizeCardManager] recognizeCardWithImage:self.ocrImagview.image compleate:^(NSString *text) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"解析结果" message:[NSString stringWithFormat:@"%@",text] preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleCancel) handler:nil];
                [alter addAction:sure];
                [weakself presentViewController:alter animated:YES completion:nil];
            });
        }];
    };
    
//    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
//    UIAlertAction *phone = [UIAlertAction actionWithTitle:@"照相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//        //判断是否可以打开照相机
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            imgagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
//            //设置摄像头模式（拍照，录制视频）为拍照
//            imgagePickController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
//            [self presentViewController:imgagePickController animated:YES completion:nil];
//        } else {
//            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备不能打开相机" preferredStyle:(UIAlertControllerStyleAlert)];
//            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:nil];
//            [alter addAction:sure];
//            [self presentViewController:alter animated:YES completion:nil];
//        }
//    }];
//    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//        imgagePickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentViewController:imgagePickController animated:YES completion:nil];
//    }];
//    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
//    [alter addAction:phone];
//    [alter addAction:photo];
//    [alter addAction:cancle];
//    [self presentViewController:alter animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    UIImage *srcImage = nil;
    //判断资源类型
    if ([mediaType isEqualToString:@"public.image"]){
        srcImage = [[Imageprocess recognizeCardManager] getProcessedImage:info[UIImagePickerControllerEditedImage]];
        srcImage = info[UIImagePickerControllerEditedImage];
        self.imagview.image = srcImage;
        [[Imageprocess recognizeCardManager] recognizeCardWithImage:srcImage compleate:^(NSString *text) {
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"解析结果" message:[NSString stringWithFormat:@"%@",text] preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleCancel) handler:nil];
            [alter addAction:sure];
            [self presentViewController:alter animated:YES completion:nil];
            NSLog(@"%@",text);
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
