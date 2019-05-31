//
//  L_NewCommunityVertifyListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/29.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewCommunityVertifyListTVC.h"

@implementation L_NewCommunityVertifyListTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _dotImg.layer.cornerRadius = 2.5;
    _dotImg.clipsToBounds = YES;
    _dotImg.hidden = YES;
    
    _bottomLineView.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
