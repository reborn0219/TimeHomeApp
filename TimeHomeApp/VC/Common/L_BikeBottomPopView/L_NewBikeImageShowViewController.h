//
//  L_NewBikeImageShowViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/20.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^CompleteCallBack)();
@interface L_NewBikeImageShowViewController : BaseViewController

@property (nonatomic, copy) CompleteCallBack completeCallBack;

/**
 *  返回实例
 */
+ (L_NewBikeImageShowViewController *)getInstance;

/**
 显示
 */
- (void)showVC:(UIViewController *)parent withCallBack:(CompleteCallBack)callBack;

@end
