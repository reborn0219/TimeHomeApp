//
//  CALayer+borderXib.m
//  TimeHomeApp
//
//  Created by UIOS on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CALayer+borderXib.h"

@implementation CALayer (borderXib)

-(void)setBorderUIColor:(UIColor *)color{
    
    self.borderColor = color.CGColor;
}

-(UIColor *)borderUIColor{
    
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
