//
//  L_CarErrorAlertVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/6/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface L_CarErrorAlertVC : BaseViewController

@property (nonatomic, copy) ViewsEventBlock ok_btnEventBlock;

+ (L_CarErrorAlertVC *)getInstance;

/**
 @param type 1.上下label 2.中间label
 @param msg  中间label内容
 */
- (void)showVC:(UIViewController *)parent withMsg:(NSString *)msg withType:(NSInteger)type withBlock:(ViewsEventBlock)callBack;

@end
