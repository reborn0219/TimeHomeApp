//
//  UITabBar+Badge.h
//  YouLifeApp
//
//  Created by us on 15/9/9.
//  Copyright © 2015年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点
- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
@end
