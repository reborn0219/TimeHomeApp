//
//  SpeedyLockCollectionViewCell.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/9/6.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SpeedyLockCollectionViewCell.h"

@implementation SpeedyLockCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)buttonClick:(id)sender {
    
    if (self.LockButtonDidClickBlock) {
        self.LockButtonDidClickBlock(0);
    }
}

- (IBAction)leftClick:(id)sender {
    
    if (self.LockButtonDidClickBlock) {
        self.LockButtonDidClickBlock(1);
    }
}


- (IBAction)rightClick:(id)sender {
    
    if (self.LockButtonDidClickBlock) {
        self.LockButtonDidClickBlock(2);
    }
}

@end
