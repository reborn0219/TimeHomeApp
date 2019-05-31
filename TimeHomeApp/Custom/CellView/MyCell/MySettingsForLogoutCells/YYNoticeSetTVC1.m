//
//  YYNoticeSetTVC1.m
//  TimeHomeApp
//
//  Created by 世博 on 16/7/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "YYNoticeSetTVC1.h"

@implementation YYNoticeSetTVC1

- (void)awakeFromNib {
    [super awakeFromNib];

    

}
/**
 *  开关
 */
- (IBAction)openOrCloseSwitch:(UISwitch *)sender {
    
    if (self.switchClick) {
        self.switchClick(sender.isOn);
    }
    
}


@end
