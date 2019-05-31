//
//  L_MyInfoBaseTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyInfoBaseTVC.h"


@implementation L_MyInfoBaseTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bottomLineView.hidden = YES;
    
    _dotView.hidden = YES;
    _dotView.layer.cornerRadius = 2.5;

//    self.contentView.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.2 alpha:1];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
