//
//  L_NewBikeInfoShowViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewBikeInfoShowViewController.h"

@interface L_NewBikeInfoShowViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, copy) NSString *infoString;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation L_NewBikeInfoShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];

    _infoLabel.text = _infoString;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissVC)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isDescendantOfView:self.bgView] || [touch.view isDescendantOfView:self.infoLabel]) {
        return NO;
    }
    return YES;
}

- (IBAction)knowButtonDidTouch:(UIButton *)sender {
    
    [self dismissVC];
    
}

/**
 *  返回实例
 */
+ (L_NewBikeInfoShowViewController *)getInstance {
    L_NewBikeInfoShowViewController * garageTimePopVC= [[L_NewBikeInfoShowViewController alloc] initWithNibName:@"L_NewBikeInfoShowViewController" bundle:nil];
    return garageTimePopVC;
}

/**
 显示
 */
- (void)showVC:(UIViewController *)parent withInfo:(NSString *)info cellEvent:(OKButtonDidTouchBlock)eventCallBack {
    
    self.okButtonDidTouchBlock = eventCallBack;
    
    _infoString = [XYString IsNotNull:info];
    
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
