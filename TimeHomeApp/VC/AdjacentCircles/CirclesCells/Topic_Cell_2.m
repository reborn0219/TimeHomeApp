//
//  Topic_Cell_2.m
//  TimeHomeApp
//
//  Created by UIOS on 16/2/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "Topic_Cell_2.h"

@implementation Topic_Cell_2

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
    self.headerImgV.contentScaleFactor = [[UIScreen mainScreen]scale];
    self.headerImgV.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImgV.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.headerImgV.clipsToBounds = YES;
}

- (IBAction)guanZhuAction:(id)sender {
    self.block(nil,sender,_indexPath);
}
@end
