//
//  THMyActivityListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyActivityListTVC.h"

@interface THMyActivityListTVC ()

/**
 *  右边类型图片
 */
@property (nonatomic, strong) UIImageView *typeImage;

@end

@implementation THMyActivityListTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _typeImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_typeImage];
    [_typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@(WidthSpace(30)+20));
        make.height.equalTo(@(WidthSpace(30)+20));
        
    }];
    
    _activityTitle_Label = [[UILabel alloc]init];
    _activityTitle_Label.font = DEFAULT_FONT(16);
    _activityTitle_Label.numberOfLines = 2;
    _activityTitle_Label.textColor = kNewRedColor;
    [self.contentView addSubview:_activityTitle_Label];
    [_activityTitle_Label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(WidthSpace(30));
        make.right.equalTo(_typeImage.mas_left);
        make.bottom.equalTo(self.contentView).offset(-WidthSpace(20));
        make.height.equalTo(@40);
    }];
    
}
- (void)setUserActivity:(UserActivity *)userActivity {
    _userActivity = userActivity;
    
    _activityTitle_Label.text = userActivity.title;
    
    _typeImage.image = [UIImage imageNamed:@"社区_社区活动_活动"];
}


@end
