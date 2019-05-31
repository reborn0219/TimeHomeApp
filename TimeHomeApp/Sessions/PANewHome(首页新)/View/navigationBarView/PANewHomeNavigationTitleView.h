//
//  PANewHomeNavigationTitleView.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/2.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PANewHomeNavigationTitleView : UIButton
@property (nonatomic, copy)UpDateViewsBlock callback;

- (id)initWithTitle:(NSString *)title;
- (void)reloadNavigationTitle:(NSString *)title;

@end
