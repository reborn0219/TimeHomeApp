//
//  L_PointRuleShowViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_PointRuleShowViewController.h"

@interface L_PointRuleShowViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITextView *contextTV;

@property (nonatomic, copy) NSString *contentStr;

@end

@implementation L_PointRuleShowViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [_contextTV setContentOffset:CGPointZero animated:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.65];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissVC)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    _contextTV.text = [XYString IsNotNull:_contentStr];
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isDescendantOfView:self.bgView]) {
        return NO;
    }
    return YES;
}

- (IBAction)closeButtonDidTouch:(UIButton *)sender {
    
    [self dismissVC];
}


/**
 *  返回实例
 */
+ (L_PointRuleShowViewController *)getInstance {
    L_PointRuleShowViewController * garageTimePopVC= [[L_PointRuleShowViewController alloc] initWithNibName:@"L_PointRuleShowViewController" bundle:nil];
    return garageTimePopVC;
}

/**
 显示
 */
- (void)showVC:(UIViewController *)parent withString:(NSString *)string {
    
    if ([XYString isBlankString:string]) {
        return;
    }
    
    _contentStr = string;
    
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
