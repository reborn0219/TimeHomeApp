//
//  PACarSwitch.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/7/12.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.//

#import <UIKit/UIKit.h>

@interface PACarSwitch : UIControl

@property(nonatomic, retain) UIColor *tintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, retain) UIColor *onTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, retain) UIColor *offTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, assign) UIColor *thumbTintColor UI_APPEARANCE_SELECTOR;

@property(nonatomic,getter=isOn) BOOL on;

- (id)initWithFrame:(CGRect)frame;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

- (void)setOnImageNamed:(NSString*)imageName;
- (void)setOffImageNamed:(NSString*)imageName;

@end
