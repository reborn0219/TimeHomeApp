//
//  L_CarErrorAlertVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/6/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_CarErrorAlertVC.h"

@interface L_CarErrorAlertVC ()
{
    NSInteger showType;
    NSString *showMsg;
}
/** 中间label */
@property (weak, nonatomic) IBOutlet UILabel *centerMsg_Label;

@property (weak, nonatomic) IBOutlet UILabel *top_Label;
@property (weak, nonatomic) IBOutlet UILabel *bottom_Label;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabelWidthLayout;

@end

@implementation L_CarErrorAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    //三分钟内不可重复提交纠错申请，请耐心等待
    
    if (SCREEN_WIDTH == 414) {
        _topToTopLayout.constant = 100;
        _topLabelWidthLayout.constant = 257;
        _top_Label.font = DEFAULT_FONT(18);
        _bottom_Label.font = DEFAULT_FONT(16);
    }
    
    if (SCREEN_WIDTH == 375) {
        _topToTopLayout.constant = 80;
        _topLabelWidthLayout.constant = 257;
        _top_Label.font = DEFAULT_FONT(18);
        _bottom_Label.font = DEFAULT_FONT(16);
    }
    
    if (SCREEN_WIDTH == 320) {
        _topToTopLayout.constant = 65;
        _topLabelWidthLayout.constant = 230;
        _top_Label.font = DEFAULT_FONT(16);
        _bottom_Label.font = DEFAULT_FONT(15);
    }
    
    if (showType == 1) {
        _top_Label.text = @"您提交的申请已发送给物业审核";
        _bottom_Label.text = @"物业如果3分钟内通过审核，系统会为您进行开闸通行；超过此时间，您可再次申请或直接联系物业进行处理。";
        _top_Label.hidden = NO;
        _bottom_Label.hidden = NO;
        _centerMsg_Label.hidden = YES;
    }
    
    if (showType == 2) {
        //        _centerMsg_Label.text = @"三分钟内不可重复提交纠错申请，请耐心等待";
        _centerMsg_Label.text = showMsg;
        _top_Label.hidden = YES;
        _bottom_Label.hidden = YES;
        _centerMsg_Label.hidden = NO;
    }
    
}

- (IBAction)OK_BtnDidTouch:(UIButton *)sender {
    if (self.ok_btnEventBlock) {
        self.ok_btnEventBlock(nil, nil, 0);
    }
    [self dismissVC];
}

/**
 *  返回实例
 */
+ (L_CarErrorAlertVC *)getInstance {
    L_CarErrorAlertVC * givenPopVC = [[L_CarErrorAlertVC alloc] initWithNibName:@"L_CarErrorAlertVC" bundle:nil];
    return givenPopVC;
}

/**
 显示
 */
- (void)showVC:(UIViewController *)parent withMsg:(NSString *)msg withType:(NSInteger)type withBlock:(ViewsEventBlock)callBack {
    
    _ok_btnEventBlock = callBack;
    showType = type;
    showMsg = [XYString IsNotNull:msg];
    
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

