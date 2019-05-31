//
//  PublishPostReView.m
//  TimeHomeApp
//
//  Created by UIOS on 16/4/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PublishPostReView.h"

@implementation PublishPostReView

- (IBAction)selectImgAction:(id)sender {
    self.imgBlock(nil,SucceedCode);
}
- (IBAction)addFollowAction:(id)sender {
    self.followBlock(sender,SucceedCode);
}
@end
