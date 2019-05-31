//
//  GarageCarCell.m
//  TimeHomeApp
//
//  Created by us on 16/2/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "GarageCarCell.h"

@implementation GarageCarCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}
/**
 *  删除车牌事件
 *
 *  @param sender sender description
 */
- (IBAction)btn_DelCarClike:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate delCarNumWithIndexPath:self.indexPath];
    }
}

@end
