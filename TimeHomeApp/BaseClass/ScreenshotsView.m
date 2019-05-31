//
//  ScreenshotsView.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/9.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ScreenshotsView.h"

@implementation ScreenshotsView

+(ScreenshotsView *)instanceScreenshotsView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ScreenshotsView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


/**
 反馈问题
 */
- (IBAction)faceBackClick:(id)sender {
    
    if (self.block) {
        self.block(nil, nil, 0);
    }
    [self removeFromSuperview];
}


/**
 分享
 */
- (IBAction)shareClick:(id)sender {
    if (self.block) {
        self.block(nil, nil, 1);
    }
    [self removeFromSuperview];
}


@end
