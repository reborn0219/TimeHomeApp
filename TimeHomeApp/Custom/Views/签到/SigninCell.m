//
//  SigninCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/7/18.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SigninCell.h"

@implementation SigninCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = UIColorFromRGB(0xEEEEEE).CGColor;
    
}

@end
