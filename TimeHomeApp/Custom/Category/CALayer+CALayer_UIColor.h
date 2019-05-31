//
//  CALayer+CALayer_UIColor.h
//  YouLifeApp
//
//  Created by us on 15/8/15.
//  Copyright © 2015年 us. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (CALayer_UIColor)
@property(nonatomic, strong) UIColor *borderColorFromUIColor;

- (void)setBorderColorFromUIColor:(UIColor *)color;

@end
