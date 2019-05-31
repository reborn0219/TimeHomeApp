//
//  GarageCell.m
//  TimeHomeApp
//
//  Created by us on 16/2/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "GarageCell.h"

@implementation GarageCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}
/**
 *  点击进入车位详情
 *
 *  @param sender sender description
 */
- (IBAction)btn_CarStateClike:(UIButton *)sender {
    
    if(self.delegate)
    {
        [self.delegate toGarageDetailWithIndexPath:self.indexPath];
    }
}

/**
 *  锁车和开锁事件
 *
 *  @param sender sender description
 */
- (IBAction)btn_LockClike:(UIButton *)sender {
    if(self.delegate)
    {
        [self.delegate lockOrCallPhoneCarWithIndexPath:self.indexPath];
    }
}

@end
