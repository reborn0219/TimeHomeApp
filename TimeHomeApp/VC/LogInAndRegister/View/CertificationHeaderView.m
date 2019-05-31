//
//  CertificationHeaderView.m
//  PropertyButler
//
//  Created by 赵思雨 on 2017/7/19.
//  Copyright © 2017年 优思科技. All rights reserved.
//

#import "CertificationHeaderView.h"

@implementation CertificationHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    _certificationBtn.layer.cornerRadius = 35/2;
    _certificationBtn.layer.masksToBounds = YES;
    _rightImage.transform = CGAffineTransformMakeRotation(M_PI);
    self.backgroundColor = BLACKGROUND_COLOR;
}


- (IBAction)certificationBtnClick:(id)sender {
    if (self.block) {
        self.block(nil, nil, 0);
    }
}


@end
