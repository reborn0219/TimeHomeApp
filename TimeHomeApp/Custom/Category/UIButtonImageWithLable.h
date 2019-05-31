//
//  UIButtonImageWithLable.h
//  YouLifeApp
//
//  Created by 王好雷 on 15/8/7.
//  Copyright © 2015年 us. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIButton (UIButtonImageWithLable)
- (void) setTopImage:(UIImage *)image withTitle:(NSString *)title  forState:(UIControlState)stateType;
- (void) setrightImage:(UIImage *)image withTitle:(NSString *)title  forState:(UIControlState)stateType;

@end