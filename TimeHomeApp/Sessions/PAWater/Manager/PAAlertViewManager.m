//
//  PAAlertViewManager.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAAlertViewManager.h"
#import "SCLAlertView.h"

@implementation PAAlertViewManager

SYNTHESIZE_SINGLETON_FOR_CLASS(PAAlertViewManager)

- (void)showOneButtonAlertWithTitle:(NSString *)title content:(NSString *)content buttonContent:(NSString *)buttonContent buttonBgColor:(NSString *)buttonBgColor buttonBlock:(void(^)(void))buttonBlock{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert removeTopCircle];
    alert.showAnimationType = SCLAlertViewShowAnimationSimplyAppear;
    SCLButton *button = [alert addButton:buttonContent actionBlock:^{
        buttonBlock();
    }];
    button.buttonFormatBlock = ^NSDictionary *{
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        buttonConfig[@"backgroundColor"] = [UIColor colorWithHexString:buttonBgColor];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        return buttonConfig;
    };
    [alert showInfo:title subTitle:content closeButtonTitle:nil duration:0.0f];
}

@end
