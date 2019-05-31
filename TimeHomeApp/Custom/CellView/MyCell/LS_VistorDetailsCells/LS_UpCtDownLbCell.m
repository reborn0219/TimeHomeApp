//
//  LS_UpCtDownLbCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/8/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LS_UpCtDownLbCell.h"

@implementation LS_UpCtDownLbCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)assignmentWithModel:(UserVisitor *)UV
{
    [super assignmentWithModel:UV];
    self.centerLb.text = [UV.visitdate substringToIndex:10];
}
@end
