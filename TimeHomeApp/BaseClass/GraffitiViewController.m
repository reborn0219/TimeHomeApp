//
//  GraffitiViewController.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/9.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "GraffitiViewController.h"
#import "UIImage+ImageRotate.h"
#import "L_SuggestionViewController.h"
@interface GraffitiViewController ()

@end

@implementation GraffitiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"反馈问题";
    [self initViews];
}

//UI设置
- (void)initViews {

    ///背景色
    [[UINavigationBar appearance]setBarTintColor:NABAR_COLOR];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage createImageWithColor:NABAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    ///左右item字体颜色
    [UINavigationBar appearance].tintColor = TITLE_TEXT_COLOR;
    
    //    ///标题字体颜色
    //    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TITLE_TEXT_COLOR}];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : TITLE_TEXT_COLOR}];
    
    self.view.backgroundColor = BLACKGROUND_COLOR;
    
    //添加边框 切角
    _drawView.layer.cornerRadius = 5.0f;
    _drawView.layer.masksToBounds = YES;
    _drawView.layer.borderColor = [UIColor colorWithRed:((float)((0x151759 & 0xFF0000) >> 16))/255.0 green:((float)((0x151759 & 0xFF00) >> 8))/255.0 blue:((float)(0x151759 & 0xFF))/255.0 alpha:0.8].CGColor;
    _drawView.layer.borderWidth = 2.0f;
    [_drawView setImage:_image];
    _drawView.lineWidth = 5.0f;
    
    _redBtn.layer.cornerRadius = (SCREEN_WIDTH - (20 * 5 + 60))/6/2;
    _orangeBtn.layer.cornerRadius = (SCREEN_WIDTH - (20 * 5 + 60))/6/2;
    _yellowBtn.layer.cornerRadius = (SCREEN_WIDTH - (20 * 5 + 60))/6/2;
    _pinkBtn.layer.cornerRadius = (SCREEN_WIDTH - (20 * 5 + 60))/6/2;
    _blueBtn.layer.cornerRadius = (SCREEN_WIDTH - (20 * 5 + 60))/6/2;
    
    
     //导航按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 15, 15);
    
    UIImage *image = [UIImage imageNamed:@"截图关闭"];
    [button setBackgroundImage:[image imageWithColor:TITLE_TEXT_COLOR] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 15, 15);
    
    UIImage *image1 = [UIImage imageNamed:@"截图返回"];
    [button1 setBackgroundImage:[image1 imageWithColor:TITLE_TEXT_COLOR] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(goClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *goBtn = [[UIBarButtonItem alloc]initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = goBtn;
    
}


/**
 导航按钮点击事件
 */
- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)goClick {
    
    NSMutableArray*arrController =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    UIViewController *lastVC = arrController[arrController.count - 2];
    
    if ([lastVC isKindOfClass:[L_SuggestionViewController class]]) {
        [arrController removeObjectAtIndex:arrController.count - 2];
        self.navigationController.viewControllers = arrController;
    }
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MyTab" bundle:nil];
    L_SuggestionViewController *suggestVC = [storyBoard instantiateViewControllerWithIdentifier:@"L_SuggestionViewController"];
    UIImage *image = [self saveThePic];
    suggestVC.drawImage = image;
    [self.navigationController pushViewController:suggestVC animated:YES];
}

- (UIImage *)saveThePic {
    // 截屏
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(_drawView.bounds.size, NO, 0);
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 渲染图层
    [_drawView.layer renderInContext:ctx];
    
    // 获取上下文中的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    return image;
}

- (IBAction)btnClick:(id)sender {
    UIButton *btn = sender;
    _drawView.pathColor = btn.backgroundColor;
    switch (btn.tag - 10) {
        case 1:
        {
            
            [_redBtn setImage:[UIImage imageNamed:@"截图选中"] forState:UIControlStateNormal];
            [_yellowBtn setImage:nil forState:UIControlStateNormal];
            [_orangeBtn setImage:nil forState:UIControlStateNormal];
            [_pinkBtn setImage:nil forState:UIControlStateNormal];
            [_blueBtn setImage:nil forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            
            [_yellowBtn setImage:[UIImage imageNamed:@"截图选中"] forState:UIControlStateNormal];
            [_redBtn setImage:nil forState:UIControlStateNormal];
            [_orangeBtn setImage:nil forState:UIControlStateNormal];
            [_pinkBtn setImage:nil forState:UIControlStateNormal];
            [_blueBtn setImage:nil forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [_orangeBtn setImage:[UIImage imageNamed:@"截图选中"] forState:UIControlStateNormal];
            [_yellowBtn setImage:nil forState:UIControlStateNormal];
            [_redBtn setImage:nil forState:UIControlStateNormal];
            [_pinkBtn setImage:nil forState:UIControlStateNormal];
            [_blueBtn setImage:nil forState:UIControlStateNormal];
        }
            break;
        case 4:
        {
            [_pinkBtn setImage:[UIImage imageNamed:@"截图选中"] forState:UIControlStateNormal];
            [_orangeBtn setImage:nil forState:UIControlStateNormal];
            [_yellowBtn setImage:nil forState:UIControlStateNormal];
            [_redBtn setImage:nil forState:UIControlStateNormal];
            [_blueBtn setImage:nil forState:UIControlStateNormal];
        }
            break;
        case 5:
        {
            [_blueBtn setImage:[UIImage imageNamed:@"截图选中"] forState:UIControlStateNormal];
            [_pinkBtn setImage:nil forState:UIControlStateNormal];
            [_orangeBtn setImage:nil forState:UIControlStateNormal];
            [_yellowBtn setImage:nil forState:UIControlStateNormal];
            [_redBtn setImage:nil forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}


/**
 橡皮擦
 */
- (IBAction)clearClick:(id)sender {
    [_drawView clear];
}
@end
