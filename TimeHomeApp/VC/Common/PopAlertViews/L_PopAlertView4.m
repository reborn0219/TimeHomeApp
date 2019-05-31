//
//  L_PopAlertView4.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/9/6.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_PopAlertView4.h"

@interface L_PopAlertView4 ()

@end

@implementation L_PopAlertView4

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];

    _bgView.layer.cornerRadius = 10.;
    _bgView.layer.masksToBounds = YES;
    
    _left_Btn.layer.cornerRadius = 18.f;
    _left_Btn.layer.masksToBounds = YES;
    
    _right_Btn.layer.cornerRadius = 18.f;
    _right_Btn.layer.masksToBounds = YES;
    _right_Btn.layer.borderColor = kNewRedColor.CGColor;
    _right_Btn.layer.borderWidth = 1.;
    
    
//    您已经添加二轮车，但是尚未添加感应条码，现在保存吗？
//    _title_Label.text = [XYString IsNotNull:_content];
    
}

#pragma mark - 返回实例

+ (L_PopAlertView4 *)getInstance {
    L_PopAlertView4 * givenPopVC = [[L_PopAlertView4 alloc] initWithNibName:@"L_PopAlertView4" bundle:nil];
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
    
    //1.左 2.右
    NSLog(@"%ld",(long)sender.tag);
    [self dismissVC];
    if (self.selectButtonCallBack) {
        self.selectButtonCallBack(nil, nil, sender.tag);
    }
    
}


@end
