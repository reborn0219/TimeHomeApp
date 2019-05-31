//
//  L_NewBikeAddShowViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SendButtonDidTouchBlock)(NSString *peopleName, NSString *peoplePhoneNum);

@interface L_NewBikeAddShowViewController : BaseViewController

@property (nonatomic, copy) SendButtonDidTouchBlock sendButtonDidTouchBlock;

/**
 *  返回实例
 */
+ (L_NewBikeAddShowViewController *)getInstance;
/**
 显示
 */
- (void)showVC:(UIViewController *)parent cellEvent:(SendButtonDidTouchBlock)eventCallBack;

@end
