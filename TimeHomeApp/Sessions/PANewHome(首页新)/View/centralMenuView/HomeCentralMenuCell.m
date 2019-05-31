//
//  HomeCentralMenuCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/8/2.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "HomeCentralMenuCell.h"

@implementation HomeCentralMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickAction:(id)sender {
    
    UIButton * button = (UIButton *)sender;
    if (self.block) {
        self.block(button.tag);
    }
    
}

@end
