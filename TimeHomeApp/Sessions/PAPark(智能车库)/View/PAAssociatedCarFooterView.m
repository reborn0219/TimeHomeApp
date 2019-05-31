//
//  PAAssociatedCarFooterView.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAAssociatedCarFooterView.h"

@implementation PAAssociatedCarFooterView
- (IBAction)associatedCarAction:(id)sender {
    if (self.block) {
        self.block(1);
    }
}
@end
