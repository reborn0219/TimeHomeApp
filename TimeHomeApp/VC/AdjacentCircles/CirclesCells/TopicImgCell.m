//
//  TopicImgCell.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "TopicImgCell.h"

@implementation TopicImgCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
//    self.backImgV.layer.borderWidth = 2;
//    self.backImgV.layer.borderColor = PURPLE_COLOR.CGColor;
//    self.backImgV.layer.masksToBounds = YES;
    
    self.backImgV.contentScaleFactor = [[UIScreen mainScreen]scale];
    self.backImgV.contentMode = UIViewContentModeScaleAspectFill;
    self.backImgV.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backImgV.clipsToBounds = YES;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.backImgV.layer.borderWidth = 2;
        self.backImgV.layer.borderColor = PURPLE_COLOR.CGColor;
        self.backImgV.layer.masksToBounds = YES;
        [_leftBtn setHidden:NO];
    }else
    {
        self.backImgV.layer.borderWidth = 0;
        [_leftBtn setHidden:YES];
    }
    // Configure the view for the selected state
}

@end
