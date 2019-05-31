//
//  THMyActivityListTVCStyle1.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/27.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyActivityListTVCStyle1.h"

@implementation THMyActivityListTVCStyle1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _activityImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_activityImage];
    _activityImage.sd_layout.leftEqualToView(self.contentView).topEqualToView(self.contentView).rightEqualToView(self.contentView).heightIs((SCREEN_WIDTH-14)*276/690.0);
    
    _outDateImage = [[UIImageView alloc]init];
    _outDateImage.image = [UIImage imageNamed:@"社区活动_已结束图标"];
    _outDateImage.hidden = YES;
    [self.contentView addSubview:_outDateImage];
    _outDateImage.sd_layout.rightSpaceToView(self.contentView,15).topSpaceToView(_activityImage,10).heightIs(40).widthEqualToHeight();
    
    _titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.textColor = TITLE_TEXT_COLOR;
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = DEFAULT_FONT(16);
    _titleLabel.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(_activityImage,15).rightSpaceToView(_outDateImage,5).heightIs(40);
    
    _timeImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_timeImage];
    _timeImage.image = [UIImage imageNamed:@"社区_社区活动_活动时间"];
    _timeImage.sd_layout.leftEqualToView(_titleLabel).topSpaceToView(_titleLabel,10).widthIs(14).heightEqualToWidth();
    
    _timeLabel = [[UILabel alloc]init];
//    _timeLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_timeLabel];
    _timeLabel.textColor = TEXT_COLOR;
    _timeLabel.font = DEFAULT_FONT(14);
    _timeLabel.sd_layout.leftSpaceToView(_timeImage,10).centerYEqualToView(_timeImage).widthIs(150).heightIs(20);
//    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    

    [self setupAutoHeightWithBottomViewsArray:@[_activityImage,_outDateImage,_titleLabel,_timeImage,_timeLabel] bottomMargin:15];
}
- (void)setUserActivity:(UserActivity *)userActivity {
    _userActivity = userActivity;
    
    _titleLabel.text = userActivity.title;
    
    NSString *beginString = [userActivity.begindate substringToIndex:10];
    NSString *endString = [userActivity.enddate substringToIndex:10];
    
    beginString = [XYString NSDateToString:[XYString NSStringToDate:beginString withFormat:@"yyyy-MM-dd"] withFormat:@"yyyy/MM/dd"];
    endString = [XYString NSDateToString:[XYString NSStringToDate:endString withFormat:@"yyyy-MM-dd"] withFormat:@"yyyy/MM/dd"];

    _timeLabel.text = [NSString stringWithFormat:@"%@-%@",beginString,endString];
    
    [_activityImage sd_setImageWithURL:[NSURL URLWithString:userActivity.picurl] placeholderImage:PLACEHOLDER_IMAGE];
    
    
    if (userActivity.endtype.intValue == 1) {
        _outDateImage.hidden = NO;
        _titleLabel.sd_resetLayout.leftSpaceToView(self.contentView,10).topSpaceToView(_activityImage,15).rightSpaceToView(_outDateImage,5).heightIs(40);

    }else {
        _outDateImage.hidden = YES;
        _titleLabel.sd_resetLayout.leftSpaceToView(self.contentView,10).topSpaceToView(_activityImage,15).rightSpaceToView(self.contentView,10).heightIs(40);

    }
    
}

@end
