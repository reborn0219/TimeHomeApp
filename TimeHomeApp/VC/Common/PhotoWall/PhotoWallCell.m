//
//  PhotoWallCell.m
//  TimeHomeApp
//
//  Created by us on 16/4/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PhotoWallCell.h"

@implementation PhotoWallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

///删除事件
- (IBAction)btn_DelEvent:(UIButton *)sender {
    
    if(self.cellEventBlock)
    {
        self.cellEventBlock(nil,sender,self.indexPath);
    }
}

@end
