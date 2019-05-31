//
//  Topic_Cell_1.m
//  TimeHomeApp
//
//  Created by UIOS on 16/2/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.

#import "Topic_Cell_1.h"

@implementation Topic_Cell_1

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
    self.imgV.layer.cornerRadius = 8;
    self.imgV.clipsToBounds = YES;
    
}

@end
