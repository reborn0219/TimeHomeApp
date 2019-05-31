//
//  L_AppNotificationPopVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/7/26.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface L_AppNotificationPopVC : UIViewController

/**
 显示消息
 */
@property (weak, nonatomic) IBOutlet UILabel *msg_Label;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, copy) ViewsEventBlock selectButtonCallBack;

/**
 *  返回实例
 */
+ (L_AppNotificationPopVC *)getInstance;

/**
 显示
 */
- (void)showVC:(UIViewController *)parent cellEvent:(ViewsEventBlock)eventCallBack;

@end
