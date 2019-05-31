//
//  THMyPointsDetailsTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyPointsDetailsTVC.h"

@implementation THMyPointsDetailsTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.font = DEFAULT_FONT(14);
    _timeLabel.textColor = TITLE_TEXT_COLOR;
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_timeLabel];
    _timeLabel.sd_layout.leftSpaceToView(self.contentView,WidthSpace(40)).centerYEqualToView(self.contentView).heightIs(20).widthIs(120);

    _addCountsLabel = [[UILabel alloc]init];
    _addCountsLabel.font = DEFAULT_FONT(14);
    _addCountsLabel.textColor = UIColorFromRGB(0x28C188);
    _addCountsLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_addCountsLabel];
    
    _addCountsLabel.sd_layout.rightSpaceToView(self.contentView,20).centerYEqualToView(_timeLabel).widthIs(35).heightIs(20);
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = DEFAULT_FONT(13);
    _contentLabel.textColor = TITLE_TEXT_COLOR;
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.numberOfLines = 2;
    [self.contentView addSubview:_contentLabel];
    _contentLabel.sd_layout.leftSpaceToView(_timeLabel,2).rightSpaceToView(_addCountsLabel,2).centerYEqualToView(_timeLabel).heightIs(20);
    
//画虚线----------------------
    _shapeLayer = [CAShapeLayer layer];
    [_shapeLayer setBounds:self.bounds];
    [_shapeLayer setPosition:self.center];
    [_shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为blackColor
    [_shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [_shapeLayer setStrokeColor:[[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
    
    // 3.0f设置虚线的宽度
    [_shapeLayer setLineWidth:1.0f];
    [_shapeLayer setLineJoin:kCALineJoinRound];
    
    // 3=线的宽度 1=每条线的间距
    [_shapeLayer setLineDashPattern:
    [NSArray arrayWithObjects:[NSNumber numberWithInt:4],
    [NSNumber numberWithInt:2],nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    // 0,10代表初始坐标的x，y
    // 320,10代表初始坐标的x，y
    CGPathMoveToPoint(path, NULL, 10, 2*WidthSpace(40)+10);
    CGPathAddLineToPoint(path, NULL,20 + SCREEN_WIDTH-14-2*WidthSpace(40),2*WidthSpace(40)+10);
    
    [_shapeLayer setPath:path];
    CGPathRelease(path);
    
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[self.contentView layer] addSublayer:_shapeLayer];
    
    [self setupAutoHeightWithBottomViewsArray:@[_timeLabel,_addCountsLabel,_contentLabel] bottomMargin:WidthSpace(40)];
}

- (void)setModel:(UserIntergralLog *)model {
    
    _model = model;

    NSString *dateString = [model.systime substringToIndex:16];
    
    _timeLabel.text = dateString;
    
    NSString *intergralString = [NSString stringWithFormat:@"%@",model.integral];
    
    _addCountsLabel.text = intergralString.integerValue < 0 ? [NSString stringWithFormat:@"%@",model.integral] : [NSString stringWithFormat:@"+%@",model.integral];
    
    _contentLabel.text = model.remarks;
    
}

@end
