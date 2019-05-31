//
//  RaiN_FamilyListCell.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/11.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_FamilyListCell.h"

@implementation RaiN_FamilyListCell

- (void)awakeFromNib {
    [super awakeFromNib];

}


/**
 编辑
 */
- (IBAction)editClick:(id)sender {
    if (self.block) {
        self.block(nil, nil, 0);
    }
}


/**
 删除
 */
- (IBAction)deleteClick:(id)sender {
    if (self.block) {
        self.block(nil, nil, 1);
    }
}


@end
