//
//  PANewHomeAlertView.h
//  TimeHomeApp
//
//  Created by ning on 2018/7/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PANewHomeAlertView : UIView

typedef void (^callback) (UIViewController *controller);

@property (nonatomic,copy) callback callback;

/**
 刷新弹窗内容
 */
- (void)refreshUIWithAlertDict:(NSDictionary *)alertDict;

@end
