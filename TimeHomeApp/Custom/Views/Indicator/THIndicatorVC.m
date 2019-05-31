//
//  THIndicatorVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THIndicatorVC.h"
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>

@interface THIndicatorVC ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actIndicatorView;

@end

@implementation THIndicatorVC

-(void)initView {
//     self.img_Gif.gifPath=[[NSBundle mainBundle] pathForResource:@"加载动画_底色透明.gif" ofType:nil];
    self.isStarting=NO;
}

/**
 *  返回实例
 *
 *  @return return value description
 */
+(THIndicatorVC *)getInstance {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"THIndicatorVC" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

/**
 *  单例方法
 *
 *  @return return value  返回类实例
 */
+ (THIndicatorVC *)sharedTHIndicatorVC {
    static THIndicatorVC * sharedTHIndicatorVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"THIndicatorVC" owner:nil options:nil];
        sharedTHIndicatorVC= [nibView objectAtIndex:0];
    });
    return sharedTHIndicatorVC;
}

#pragma mark ------------显示隐藏------------

/**
 *  动画停止
 */
-(void)stopAnimating;
{
    [self.img_Gif stopAnimating];
    
    //----旧版刷新-----
//    [self.actIndicatorView stopAnimating];
    self.isStarting=NO;
    self.alpha = 1;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

/**
 * 动画启动
 */
-(void)startAnimating:(UIViewController *) vc {
    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Preloader_8_1.gif" withExtension:nil];
//    CGImageSourceRef csf = CGImageSourceCreateWithURL((__bridge CFTypeRef) url, NULL);
//    size_t const count = CGImageSourceGetCount(csf);
//    UIImage *frames[count];
//    CGImageRef images[count];
//    for (size_t i = 0; i < count; ++i) {
//        images[i] = CGImageSourceCreateImageAtIndex(csf, i, NULL);
//        UIImage *image =[[UIImage alloc] initWithCGImage:images[i]];
//        frames[i] = image;
//        CFRelease(images[i]);
//    }
//    
//    UIImage *const animation = [UIImage animatedImageWithImages:[NSArray arrayWithObjects:frames count:count] duration:1];
//
//    [self.img_Gif setImage:animation];
//    NSLog(@"xxxx%zu",count);  
//    CFRelease(csf);
//     UIViewController * currVC=[(AppDelegate *)[UIApplication sharedApplication].delegate getCurrentViewController];
    
    //-----新版加载动画------
    
    self.backgroundColor=[UIColor clearColor];
    
    //创建一个可变数组
    NSMutableArray *ary=[NSMutableArray new];
    for(int I=1;I<=2;I++){
        //通过for 循环,把我所有的 图片存到数组里面
        NSString *imageName=[NSString stringWithFormat:@"新版中间加载动画%d",I];
        UIImage *image=[UIImage imageNamed:imageName];
        [ary addObject:image];
    }
    
    // 设置图片的序列帧 图片数组
    _img_Gif.animationImages=ary;
    //动画重复次数
    _img_Gif.animationRepeatCount=MAXFLOAT;
    //动画执行时间,多长时间执行完动画
    _img_Gif.animationDuration=0.4;
    //开始动画
    [_img_Gif startAnimating];
    
    //----旧版刷新-----
//    self.view_BgView.backgroundColor = RGBAFrom0X(0x000000, 0.6);
//
//    self.isStarting=YES;
////    _actIndicatorView.hidden = YES;
//    _img_Gif.hidden = YES;
//    _msg_Label.hidden = YES;
//    [self.actIndicatorView startAnimating];
//    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
//
    self.frame=window.frame;
//
//    self.backgroundColor=RGBAFrom0X(0x000000, 0.6);
    
    self.backgroundColor=RGBAFrom0X(0x000000, 0);

    [window addSubview:self];
    
     self.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
}


@end
