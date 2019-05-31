//
//  L_MyInteractFourButton.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/27.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyInteractFourButton.h"

@implementation L_MyInteractFourButton


- (IBAction)fourButtonDidTouch:(UIButton *)sender {
    
    if (self.fourButtonDidClickBlock) {
        self.fourButtonDidClickBlock(sender.tag);
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
