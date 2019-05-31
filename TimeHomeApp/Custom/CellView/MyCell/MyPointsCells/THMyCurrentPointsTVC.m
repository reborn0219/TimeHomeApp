//
//  THMyCurrentPointsTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyCurrentPointsTVC.h"

@implementation THMyCurrentPointsTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.clipsToBounds = YES;
//    _headImageView.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_headImageView];
    _headImageView.sd_layout.leftSpaceToView(self.contentView,WidthSpace(40)).centerYEqualToView(self.contentView).widthIs(28).heightEqualToWidth();
    _headImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"当前积分 ：";
    label1.font = DEFAULT_FONT(16);
    label1.textColor = TITLE_TEXT_COLOR;
    label1.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:label1];
    label1.sd_layout.leftSpaceToView(_headImageView,WidthSpace(60)).centerYEqualToView(_headImageView).widthIs(90).heightIs(20);
    
    _currentPointsLabel = [[UILabel alloc]init];
    _currentPointsLabel.font = DEFAULT_FONT(16);
    _currentPointsLabel.textColor = kNewRedColor;
    _currentPointsLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_currentPointsLabel];
    _currentPointsLabel.sd_layout.leftSpaceToView(label1,0).centerYEqualToView(_headImageView).rightSpaceToView(self.contentView,WidthSpace(40)).heightIs(20);
    
//    [self setupAutoHeightWithBottomView:_headImageView bottomMargin:1];

}

@end
