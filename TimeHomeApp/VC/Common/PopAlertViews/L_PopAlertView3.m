//
//  L_PopAlertView3.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/9/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_PopAlertView3.h"

@interface L_PopAlertView3 ()


@end

@implementation L_PopAlertView3


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];

    _second_Btn.layer.borderWidth = 1.f;
    _second_Btn.layer.borderColor = kNewRedColor.CGColor;
    
    _third_Btn.layer.borderWidth = 1.f;
    _third_Btn.layer.borderColor = kNewRedColor.CGColor;
    
    _bgView.layer.cornerRadius = 10.;
    _bgView.layer.masksToBounds = YES;
    
    _first_Btn.layer.cornerRadius = 17.;
    _second_Btn.layer.cornerRadius = 17.;
    _third_Btn.layer.cornerRadius = 17.;

    _first_Btn.layer.masksToBounds = YES;
    _second_Btn.layer.masksToBounds = YES;
    _third_Btn.layer.masksToBounds = YES;

}

#pragma mark - 返回实例

+ (L_PopAlertView3 *)getInstance {
    L_PopAlertView3 * givenPopVC = [[L_PopAlertView3 alloc] initWithNibName:@"L_PopAlertView3" bundle:nil];
    return givenPopVC;
}

#pragma mark - 显示

- (void)showVC:(UIViewController *)parent cellEvent:(ViewsEventBlock)eventCallBack; {
    
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

#pragma mark - 按钮点击

- (IBAction)allBtnsDidClick:(UIButton *)sender {
    
    //1.2.3.从上到下
    NSLog(@"%ld",(long)sender.tag);
    [self dismissVC];
    if (self.selectButtonCallBack) {
        self.selectButtonCallBack(nil, nil, sender.tag);
    }
    
}


@end
