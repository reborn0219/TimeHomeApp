//
//  GarageDetailCell.m
//  TimeHomeApp
//
//  Created by us on 16/2/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "GarageDetailCell.h"

@implementation GarageDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  锁车事件处理
 *
 *  @param sender sender description
 */
- (IBAction)btn_LockCarClike:(UIButton *)sender {
    if(self.delegate)
    {
        [self.delegate lockCarClikeWithIndexPath:self.indexPath];
    }
}

@end
