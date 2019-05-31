//
//  THBottomStateView.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBottomStateView.h"

@implementation THBottomStateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _rightBottomLine_View = [[UIView alloc]init];
        [self addSubview:_rightBottomLine_View];
        _rightBottomLine_View.sd_layout.rightEqualToView(self).centerYEqualToView(self).widthIs(4).heightIs(18);
        _rightBottomLine_View.sd_cornerRadiusFromWidthRatio = @(0.5);
        
        _rightBottom_Label = [[UILabel alloc]init];
        _rightBottom_Label.font = DEFAULT_FONT(14);
        _rightBottom_Label.textColor = TITLE_TEXT_COLOR;
        [self addSubview:_rightBottom_Label];
        _rightBottom_Label.sd_layout.rightSpaceToView(_rightBottomLine_View,WidthSpace(10)).centerYEqualToView(_rightBottomLine_View).widthIs(35).heightIs(20);
        
        _rightBottom_ImageView = [[UIImageView alloc]init];
        _rightBottom_ImageView.image = [UIImage imageNamed:@"我发布的房源_发布状态"];
        [self addSubview:_rightBottom_ImageView];
        _rightBottom_ImageView.sd_layout.rightSpaceToView(_rightBottom_Label,WidthSpace(12)).centerYEqualToView(_rightBottom_Label).widthIs(WidthSpace(32)).heightIs(WidthSpace(32));
        
    }
    return self;
}


@end
