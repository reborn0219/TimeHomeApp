//
//  L_NewBikeInfoShowViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^OKButtonDidTouchBlock)();
@interface L_NewBikeInfoShowViewController : BaseViewController

@property (nonatomic, copy) OKButtonDidTouchBlock okButtonDidTouchBlock;

/**
 *  返回实例
 */
+ (L_NewBikeInfoShowViewController *)getInstance;
/**
 显示
 */
- (void)showVC:(UIViewController *)parent withInfo:(NSString *)info cellEvent:(OKButtonDidTouchBlock)eventCallBack;

@end
