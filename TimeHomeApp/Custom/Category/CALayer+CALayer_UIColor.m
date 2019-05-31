//
//  CALayer+CALayer_UIColor.m
//  YouLifeApp
//
//  Created by us on 15/8/15.
//  Copyright © 2015年 us. All rights reserved.
//

#import "CALayer+CALayer_UIColor.h"
#import <objc/runtime.h>

@implementation CALayer (CALayer_UIColor)

//static const void *borderColorFromUIColorKey = &borderColorFromUIColorKey;

@dynamic borderColorFromUIColor;



- (UIColor *)borderColorFromUIColor {
    
    return objc_getAssociatedObject(self, @selector(borderColorFromUIColor));
    
}

-(void)setBorderColorFromUIColor:(UIColor *)color

{
    
    objc_setAssociatedObject(self, @selector(borderColorFromUIColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setBorderColorFromUI:self.borderColorFromUIColor];
    
}



- (void)setBorderColorFromUI:(UIColor *)color

{
    
    self.borderColor = color.CGColor;
    
    //    NSLog(@"%@", color);
    
    
    
}


@end
