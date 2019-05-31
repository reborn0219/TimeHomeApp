//
//  MyGroupCell.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MyGroupCell.h"

@implementation MyGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
    self.imgV.layer.cornerRadius = 25;
    self.imgV.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
