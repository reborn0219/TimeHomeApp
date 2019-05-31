//
//  L_AppNotificationPopVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/7/26.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_AppNotificationPopVC.h"

@interface L_AppNotificationPopVC ()

@end

@implementation L_AppNotificationPopVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];

    _bgView.clipsToBounds = YES;
    _bgView.layer.cornerRadius = 8;
    
    if (SCREEN_WIDTH == 320) {
        _msg_Label.font = DEFAULT_FONT(14);
    }else {
        _msg_Label.font = DEFAULT_FONT(16);
    }
    
    
}

- (IBAction)allBtnsDidTouch:(UIButton *)sender {
    
    //sender.tag 1.我知道了 2.开启
    if (sender.tag == 2) {
        if (self.selectButtonCallBack) {
            self.selectButtonCallBack(nil, nil, 2);
        }
    }
    
    [self dismissVC];
    
}

/**
 *  返回实例
 */
+ (L_AppNotificationPopVC *)getInstance {
    L_AppNotificationPopVC * popVC = [[L_AppNotificationPopVC alloc] initWithNibName:@"L_AppNotificationPopVC" bundle:nil];
    return popVC;
}
/**
 显示
 */
- (void)showVC:(UIViewController *)parent cellEvent:(ViewsEventBlock)eventCallBack {
    
    self.selectButtonCallBack = eventCallBack;
    
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
    [parent presentViewController:self animated:NO completion:^{
        
    }];
    
}
#pragma mark - 隐藏显示
-(void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
