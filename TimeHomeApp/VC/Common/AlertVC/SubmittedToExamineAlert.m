//
//  SubmittedToExamineAlert.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/5.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SubmittedToExamineAlert.h"

@interface SubmittedToExamineAlert ()

@end

@implementation SubmittedToExamineAlert

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.layer.cornerRadius = 5.0f;
    self.bgView.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    _checkMyHouseBtn.layer.borderWidth = 1.;
    _checkMyHouseBtn.layer.borderColor = kNewRedColor.CGColor;
    
    if (_isHiddenBtn) {
        _msgLabelCenterLayout.constant = -10;
        _checkMyHouseBtn.hidden = YES;
    }else {
        _msgLabelCenterLayout.constant = -30;
        _checkMyHouseBtn.hidden = NO;
    }
}

/**
 *  返回实例
 */
+ (SubmittedToExamineAlert *)getInstance {
    SubmittedToExamineAlert * givenPopVC = [[SubmittedToExamineAlert alloc] initWithNibName:@"SubmittedToExamineAlert" bundle:nil];
    return givenPopVC;
}

+(instancetype)shareNewAlert {
    SubmittedToExamineAlert * newRegisterAlert= [[SubmittedToExamineAlert alloc] initWithNibName:@"SubmittedToExamineAlert" bundle:nil];
    return newRegisterAlert;
}

-(void)showInVC:(UIViewController *)VC {
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
    
    [VC presentViewController:self animated:YES completion:^{
        
    }];
}

/**
 进入平安社区
 */
- (IBAction)enterBtnClick:(id)sender {
    if (self.block) {
        self.block(nil, nil, 0);
    }
    [self dismiss];
}

/**
 查看我的房产
 */
- (IBAction)checkMyHouseClick:(id)sender {
    if (self.block) {
        self.block(nil, nil, 1);
    }
    [self dismiss];
}
-(void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
