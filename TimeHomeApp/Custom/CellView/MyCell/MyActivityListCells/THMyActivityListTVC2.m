//
//  THMyActivityListTVC2.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyActivityListTVC2.h"

@interface THMyActivityListTVC2 ()

/**
 *  活动时间4个字
 */
@property (nonatomic, strong) UILabel *activityTime;
/**
 *  活动时间图片
 */
@property (nonatomic, strong) UIImageView *activityTimeImage;

@end

@implementation THMyActivityListTVC2

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _activityTime = [[UILabel alloc]init];
    _activityTime.text = @"活动时间";
    _activityTime.font = DEFAULT_FONT(13);
    _activityTime.textColor = TEXT_COLOR;
    [self.contentView addSubview:_activityTime];
    [_activityTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60);
        make.left.equalTo(self.contentView).offset(15);
        make.height.equalTo(@15);
        make.top.equalTo(@20);
    }];
    
    _activityTimeImage = [[UIImageView alloc]init];
    _activityTimeImage.image = [UIImage imageNamed:@"社区_社区活动_活动时间"];
    [self.contentView addSubview:_activityTimeImage];
    [_activityTimeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_activityTime.mas_right).offset(1);
        make.centerY.equalTo(_activityTime.mas_centerY);
        make.width.equalTo(@14);
        make.height.equalTo(@14);
    }];
    
    _time_Label = [[UILabel alloc]init];
    _time_Label.font = DEFAULT_FONT(14);
    _time_Label.textColor = TEXT_COLOR;
    _time_Label.adjustsFontSizeToFitWidth = YES;

    [self.contentView addSubview:_time_Label];
    [_time_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_activityTimeImage.mas_right).offset(10);
        make.centerY.equalTo(_activityTime.mas_centerY);
        make.height.equalTo(@20);
        make.right.equalTo(self.contentView).offset(-10);

    }];
    
    _content_Label = [[UILabel alloc]init];
    _content_Label.font = DEFAULT_FONT(14);
    _content_Label.textColor = TITLE_TEXT_COLOR;
    _content_Label.numberOfLines = 2;
    [self.contentView addSubview:_content_Label];
    [_content_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_activityTime);
        make.height.equalTo(@40);
        make.top.equalTo(_activityTime.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
}
- (void)setUserActivity:(UserActivity *)userActivity {
    _userActivity = userActivity;
    
    NSString *beginString = [userActivity.begindate substringToIndex:10];
    NSString *endString = [userActivity.enddate substringToIndex:10];

    _time_Label.text = [NSString stringWithFormat:@"%@-%@",beginString,endString];
    _content_Label.text = userActivity.remarks;
}


@end
