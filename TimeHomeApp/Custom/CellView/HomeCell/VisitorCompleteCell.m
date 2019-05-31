//
//  VisitorCompleteCell.m
//  TimeHomeApp
//
//  Created by us on 16/3/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "VisitorCompleteCell.h"

@implementation VisitorCompleteCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
///进地图
- (IBAction)btn_AddressEvent:(UIButton *)sender {
    if(self.cellEventBlock)
    {
        self.cellEventBlock(nil,sender,self.indexPath);
    }
}

@end
