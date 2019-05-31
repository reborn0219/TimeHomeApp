//
//  RaiN_TheQrCodeAlert.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/11/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_TheQrCodeAlert.h"

@interface RaiN_TheQrCodeAlert ()

@end

@implementation RaiN_TheQrCodeAlert

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)initViewWithData:(id)data {
    [self.view layoutIfNeeded];
    NSArray *filters = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    NSLog(@"%@",filters);

    //二维码过滤器
    CIFilter *qrImageFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];

    //设置过滤器默认属性
    [qrImageFilter setDefaults];
    NSDictionary *dic = (NSDictionary *)data;
    NSData *qrImageData = [[NSString stringWithFormat:@"%@",dic[@"qrUrl"]] dataUsingEncoding:NSUTF8StringEncoding];

    //我们可以打印,看过滤器的 输入属性
    NSLog(@"%@",qrImageFilter.inputKeys);
    /*
     inputMessage,        //二维码输入信息
     inputCorrectionLevel //二维码错误的等级,就是容错率
     */


    //设置过滤器的 输入值  ,KVC赋值
    [qrImageFilter setValue:qrImageData forKey:@"inputMessage"];

    //取出图片
    CIImage *qrImage = [qrImageFilter outputImage];

    //放大
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];

    //转成UI的类型
    UIImage *qrUIImage = [UIImage imageWithCIImage:qrImage];
    
    //----------------给 二维码 中间增加一个 自定义图片----------------
    //开启绘图,获取图形上下文
    UIGraphicsBeginImageContext(qrUIImage.size);
    
    //把二维码图片画上去
    [qrUIImage drawInRect:CGRectMake(0, 0, qrUIImage.size.width, qrUIImage.size.height)];

    UIImageView *imageView = [[UIImageView alloc] init];

    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"logo"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [self QR_codeWithImage:qrUIImage andLogPic:nil];
}


- (void)QR_codeWithImage:(UIImage *)qrUIImage andLogPic:(UIImage *)logo {
    UIImage *sImage;

    sImage = logo;
    //再把小图片画上去
    
    CGFloat sImageW = qrUIImage.size.height/4;
    CGFloat sImageH= sImageW;
    CGFloat sImageX = (qrUIImage.size.width - sImageW) * 0.5;
    CGFloat sImgaeY = (qrUIImage.size.height - sImageH) * 0.5;
    [sImage drawInRect:CGRectMake(sImageX, sImgaeY, sImageW, sImageH)];
    
    //获取当前画得的这张图片
    UIImage *finalyImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    //设置图片
    _codeImageView.image = finalyImage;
}


+(instancetype)shareRaiN_TheQrCodeAlert {
    RaiN_TheQrCodeAlert * newRegisterAlert= [[RaiN_TheQrCodeAlert alloc] initWithNibName:@"RaiN_TheQrCodeAlert" bundle:nil];
    return newRegisterAlert;
}

-(void)showInVC:(UIViewController *)VC WithData:(id)data {
    
    [self initViewWithData:data];
    
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [VC presentViewController:self animated:YES completion:^{
        
    }];
}

- (IBAction)closeClick:(id)sender {
    [self dismiss];
}

-(void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
