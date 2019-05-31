//
//  L_PopAlertView1.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/8.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_PopAlertView1.h"

@interface L_PopAlertView1 ()

@property (weak, nonatomic) IBOutlet UILabel *message_Label;

@property (weak, nonatomic) IBOutlet UIButton *top_Button;

@property (weak, nonatomic) IBOutlet UIButton *bottom_Button;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBtnHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aspectLayout;

@end

@implementation L_PopAlertView1

- (IBAction)allButtonsDidClick:(UIButton *)sender {
    //1.上面按钮 2.下面按钮
    NSLog(@"%ld",(long)sender.tag);
    [self dismissVC];
    if (self.selectButtonCallBack) {
        self.selectButtonCallBack(nil, nil, sender.tag);
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];

    _bottom_Button.layer.borderWidth = 1.f;
    _bottom_Button.layer.borderColor = kNewRedColor.CGColor;
    
    if (_type == 1) {
        
        _bottom_Button.hidden = YES;
        _bottomBtnHeightLayout.constant = 0;
        _bottomLayout.constant = 0;
    }
    
}

/**
 *  返回实例
 */
+ (L_PopAlertView1 *)getInstance {
    L_PopAlertView1 * givenPopVC = [[L_PopAlertView1 alloc] initWithNibName:@"L_PopAlertView1" bundle:nil];
    return givenPopVC;
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
