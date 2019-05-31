//
//  UIColor+LXAddition.h
//  demo2
//
//  Created by ZHAO on 15/9/28.
//  Copyright © 2015年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LXAddition)
//设置颜色 #abcdef
+ (UIColor *) colorWithHexString: (NSString *) hexString;

//设置颜色0＊00FF00
+ (UIColor *)UIColorFromRGB:(int)rgbValue;


@end
