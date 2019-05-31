//
//  LS_ZakerCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/1/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LS_ZakerCell.h"

@implementation LS_ZakerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imgV.clipsToBounds  = YES;
    
    [_imgV setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _imgV.contentMode =  UIViewContentModeScaleAspectFill;
    _imgV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    _imgV.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
