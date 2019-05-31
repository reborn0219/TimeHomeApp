//
//  THLineView.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THLineView.h"

@implementation THLineView
{
    UIView *line;
    UIView *line2;
    UIImageView *circle;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
//    line = [[UIView alloc]init];
//    [self addSubview:line];
//    line.backgroundColor = TEXT_COLOR;
//    line.sd_layout.topEqualToView(self).bottomEqualToView(self).centerXEqualToView(self).widthIs(1);
    
//    circle = [[UIView alloc]init];
//    [self addSubview:circle];
//    circle.backgroundColor = BLACKGROUND_COLOR;
//    circle.layer.borderColor = TITLE_TEXT_COLOR.CGColor;
//    circle.layer.borderWidth = 1;
//    circle.sd_layout.topSpaceToView(self,18).widthIs(11).heightEqualToWidth().centerXEqualToView(self);
//    circle.sd_cornerRadiusFromWidthRatio = @(0.5);
    circle = [[UIImageView alloc]init];
    [self addSubview:circle];
    circle.image = [UIImage imageNamed:@"我的_我的投诉_投诉详情_物业回复装饰"];
    circle.sd_layout.topSpaceToView(self,20).widthIs(9).heightEqualToWidth().centerXEqualToView(self);
    
    line = [[UIView alloc]init];
    [self addSubview:line];
    line.backgroundColor = TEXT_COLOR;
    line.sd_layout.topEqualToView(self).bottomSpaceToView(circle,0).centerXEqualToView(circle).widthIs(1);
    
    line2 = [[UIView alloc]init];
    [self addSubview:line2];
    line2.backgroundColor = TEXT_COLOR;
    line2.sd_layout.topSpaceToView(circle,0).bottomEqualToView(self).centerXEqualToView(self).widthIs(1);
}

@end
