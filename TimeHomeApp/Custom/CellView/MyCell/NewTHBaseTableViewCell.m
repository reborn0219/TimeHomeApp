//
//  NewTHBaseTableViewCell.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/20.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NewTHBaseTableViewCell.h"

@implementation NewTHBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = BLACKGROUND_COLOR;
    _leftLabel.textColor = TITLE_TEXT_COLOR;
//    _leftLabel.font = DEFAULT_FONT(16);
    _rightLabel.textColor = TEXT_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
