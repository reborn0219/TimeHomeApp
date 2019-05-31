//
//  L_GarageDayButton.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/12/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_GarageDayButton.h"

@implementation L_GarageDayButton

- (void)setIsDaySelected:(BOOL)isDaySelected {
    _isDaySelected = isDaySelected;
    
    self.layer.borderWidth = 1.f;

    if (isDaySelected) {
        
        self.backgroundColor = kNewRedColor;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
    }else {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:kNewRedColor forState:UIControlStateNormal];
        self.layer.borderColor = kNewRedColor.CGColor;

    }
    
}

@end
