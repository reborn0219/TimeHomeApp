//
//  DynamicImgCell.m
//  TimeHomeApp
//
//  Created by UIOS on 16/2/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "DynamicImgCell.h"

@implementation DynamicImgCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
    self.imgV.contentScaleFactor = [[UIScreen mainScreen]scale];
    self.imgV.contentMode = UIViewContentModeScaleAspectFill;
    self.imgV.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.imgV.clipsToBounds = YES;
}

@end
