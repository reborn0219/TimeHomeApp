//
//  L_NewBikeBottomPopViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/20.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SelectButtonCallBack)(NSString *selectedString);

@interface L_NewBikeBottomPopViewController : BaseViewController



@property (nonatomic, copy) SelectButtonCallBack selectButtonCallBack;

/**
 *  返回实例
 */
+ (L_NewBikeBottomPopViewController *)getInstance;

/**
 显示
 */
- (void)showVC:(UIViewController *)parent withDataArray:(NSArray *)array cellEvent:(SelectButtonCallBack)eventCallBack;

@end
