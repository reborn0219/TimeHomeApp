//
//  THMyComplainPropertyReplysTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyComplainPropertyReplysTVC.h"

@interface THMyComplainPropertyReplysTVC ()
/**
 *  左边小圆圈
 */
@property (nonatomic, strong) UIImageView *circleImageView;
/**
 *  物业名称
 */
@property (nonatomic, strong) UILabel *propertyNameLabel;
/**
 *  物业回复内容
 */
@property (nonatomic, strong) UILabel *replysLabel;
/**
 *  物业回复时间
 */
@property (nonatomic, strong) UILabel *replysTimeLabel;

@end

@implementation THMyComplainPropertyReplysTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = BLACKGROUND_COLOR;
        self.contentView.backgroundColor = BLACKGROUND_COLOR;
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _replysTimeLabel = [[UILabel alloc]init];
//    _replysTimeLabel.backgroundColor = [UIColor redColor];
    _replysTimeLabel.textColor = TITLE_TEXT_COLOR;
    _replysTimeLabel.font = DEFAULT_FONT(15);
    [self.contentView addSubview:_replysTimeLabel];
    _replysTimeLabel.textAlignment = NSTextAlignmentRight;
    _replysTimeLabel.sd_layout.rightSpaceToView(self.contentView,5).topSpaceToView(self.contentView,10).widthIs(120).heightIs(20);
    
    _propertyNameLabel = [[UILabel alloc]init];
    _propertyNameLabel.textColor = TITLE_TEXT_COLOR;
    _propertyNameLabel.font = DEFAULT_FONT(16);
    [self.contentView addSubview:_propertyNameLabel];
    _propertyNameLabel.sd_layout.leftSpaceToView(self.contentView,30).topSpaceToView(self.contentView,10).rightSpaceToView(_replysTimeLabel,1).heightIs(20);
    
    _circleImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_circleImageView];
    _circleImageView.sd_layout.leftSpaceToView(self.contentView,10).centerYEqualToView(_propertyNameLabel).widthIs(10).heightIs(10);
    
    _replysLabel = [[UILabel alloc]init];
    _replysLabel.font = DEFAULT_FONT(15);
    _replysLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_replysLabel];
    _replysLabel.sd_layout.leftEqualToView(_propertyNameLabel).topSpaceToView(_propertyNameLabel,15).rightSpaceToView(self.contentView,10).autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_replysLabel bottomMargin:15];
}
- (void)setUserComplaint2:(UserComplaint *)userComplaint2 {
    _userComplaint2 = userComplaint2;
    _circleImageView.image = [UIImage imageNamed:@"我的_我的投诉_投诉详情_物业回复装饰"];
    _propertyNameLabel.text = userComplaint2.propertyname;
    
    NSString *dateString = [userComplaint2.viewsdate substringToIndex:16];
    
    _replysTimeLabel.text = dateString;
    
    _replysLabel.text = userComplaint2.views;
    
}


@end
