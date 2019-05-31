//
//  CarLocationCell.m
//  TimeHomeApp
//
//  Created by us on 16/3/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CarLocationCell.h"

@implementation CarLocationCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/**
 *  编辑事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_EditEvent:(UIButton *)sender {
    if (self.editCallBack) {
        self.editCallBack(nil,sender,self.indexpath);
    }
}
/**
 *  删除事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_DelEvent:(UIButton *)sender {
    if (self.delCallBack) {
        self.delCallBack(nil,sender,self.indexpath);
    }
}


@end
