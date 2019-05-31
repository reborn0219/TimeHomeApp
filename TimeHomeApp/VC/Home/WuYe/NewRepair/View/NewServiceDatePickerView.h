//
//  NewServiceDatePickerView.h
//  TimeHomeApp
//
//  Created by RaiN on 2017/8/11.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewServiceDatePickerView : UIViewController

@property (nonatomic, copy) ViewsEventBlock selectButtonCallBack;

@property (nonatomic, copy) NSString *minDate;

/**
 *  返回实例
 */
+ (NewServiceDatePickerView *)getInstance;

/**
 显示
 */
- (void)showVC:(UIViewController *)parent withTitle:(NSString *)title cellEvent:(ViewsEventBlock)eventCallBack;

@end
