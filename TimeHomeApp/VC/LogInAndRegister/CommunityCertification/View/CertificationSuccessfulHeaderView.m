//
//  CertificationSuccessfulHeaderView.m
//  PropertyButler
//
//  Created by 赵思雨 on 2017/7/19.
//  Copyright © 2017年 优思科技. All rights reserved.
//

#import "CertificationSuccessfulHeaderView.h"

@implementation CertificationSuccessfulHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];

    _rightImage.transform = CGAffineTransformMakeRotation(M_PI);
    self.backgroundColor = BLACKGROUND_COLOR;
    if (SCREEN_WIDTH == 320) {
        _theTitleLabel.font =DEFAULT_BOLDFONT(28);
    }
}


@end
