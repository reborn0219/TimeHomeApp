//
//  MessageCell.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
    self.headerImg.layer.masksToBounds = YES;
    self.headerImg.layer.cornerRadius = 20;
    self.headerImg.backgroundColor = PURPLE_COLOR;
    
    self.contentImgV.contentScaleFactor = [[UIScreen mainScreen]scale];
    self.contentImgV.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImgV.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.contentImgV.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
