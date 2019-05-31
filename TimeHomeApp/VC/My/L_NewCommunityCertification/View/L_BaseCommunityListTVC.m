//
//  L_BaseCommunityListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_BaseCommunityListTVC.h"

@implementation L_BaseCommunityListTVC

- (void)awakeFromNib {
    [super awakeFromNib];

    self.dot_View.layer.cornerRadius = 2.5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
