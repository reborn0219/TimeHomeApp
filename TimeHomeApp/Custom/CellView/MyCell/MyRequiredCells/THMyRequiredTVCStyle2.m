//
//  THMyRequiredTVCStyle2.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyRequiredTVCStyle2.h"

@implementation THMyRequiredTVCStyle2

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
    _timeLabel.font = DEFAULT_FONT(16);
    _timeLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_timeLabel];
    _timeLabel.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.contentView,15).heightIs(20).rightSpaceToView(self.contentView,15);
    

    _deviceLabel = [[UILabel alloc]init];
    _deviceLabel.font = DEFAULT_FONT(16);
    _deviceLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_deviceLabel];
    _deviceLabel.sd_layout.topSpaceToView(_timeLabel,15).heightIs(20).leftEqualToView(_timeLabel).rightSpaceToView(self.contentView,15);
    
    _appointmentTimeLabel = [[UILabel alloc] init];
    _appointmentTimeLabel.font = DEFAULT_FONT(16);
    _appointmentTimeLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_appointmentTimeLabel];
    _appointmentTimeLabel.sd_layout.topSpaceToView(_deviceLabel,15).heightIs(20).rightSpaceToView(self.contentView,15).leftEqualToView(_timeLabel);
    
    _priceLabel = [[UILabel alloc]init];
    _priceLabel.font = DEFAULT_FONT(16);
    _priceLabel.textColor = TITLE_TEXT_COLOR;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_priceLabel];
    _priceLabel.sd_layout.topSpaceToView(_appointmentTimeLabel,15).heightIs(20).rightSpaceToView(self.contentView,15).widthIs(100);
    
    [self setupAutoHeightWithBottomViewsArray:@[_priceLabel,_appointmentTimeLabel,_deviceLabel,_timeLabel] bottomMargin:15];
    
}
- (void)setUserInfo:(UserReserveInfo *)userInfo {
    _userInfo = userInfo;
    NSString *dateString = [userInfo.systime substringToIndex:16];

    _timeLabel.text = [NSString stringWithFormat:@"报修时间  %@",dateString];
    _deviceLabel.text = [NSString stringWithFormat:@"报修设施  %@",userInfo.typeName];
   
    
    if (userInfo.type.intValue == 1) {
        _priceLabel.text = @"";
        _priceLabel.hidden = YES;
        [self setupAutoHeightWithBottomViewsArray:@[_deviceLabel] bottomMargin:15];

    }else {
        
        ///价格预约时间都不为空
        if (![XYString isBlankString:userInfo.pricedesc] && ![XYString isBlankString:userInfo.reservedate]) {
            _priceLabel.hidden = NO;
            _priceLabel.text = [NSString stringWithFormat:@"价格  %@",userInfo.pricedesc];
            _appointmentTimeLabel.hidden = NO;
            _appointmentTimeLabel.text = [NSString stringWithFormat:@"预约时间  %@",[userInfo.reservedate substringToIndex:16]];
            
            [self setupAutoHeightWithBottomViewsArray:@[_priceLabel,_deviceLabel,_timeLabel] bottomMargin:15];

        }else if ([XYString isBlankString:userInfo.reservedate] && ![XYString isBlankString:userInfo.pricedesc]) {
            ///预约时间为空价格不为空
            _appointmentTimeLabel.hidden = YES;
            _appointmentTimeLabel.text = @"";
            
            _priceLabel.sd_layout.topSpaceToView(_deviceLabel,15).heightIs(20).rightSpaceToView(self.contentView,15).widthIs(100);
            _priceLabel.hidden = NO;
            _priceLabel.text = [NSString stringWithFormat:@"价格  %@",userInfo.pricedesc];
            
            [self setupAutoHeightWithBottomViewsArray:@[_priceLabel,_deviceLabel,_timeLabel] bottomMargin:15];
            
        }else if (![XYString isBlankString:userInfo.reservedate] && [XYString isBlankString:userInfo.pricedesc]) {
            ///预约时间为不为空价格为空
            _appointmentTimeLabel.hidden = NO;
            _appointmentTimeLabel.text = [NSString stringWithFormat:@"预约时间  %@",[userInfo.reservedate substringToIndex:16]];
        
            _priceLabel.hidden = YES;
            _priceLabel.text = @"";
            
            [self setupAutoHeightWithBottomViewsArray:@[_appointmentTimeLabel,_deviceLabel,_timeLabel] bottomMargin:15];
            
        }else if ([XYString isBlankString:userInfo.reservedate] && [XYString isBlankString:userInfo.pricedesc]) {
            ///预约时间为价格都为空
            _priceLabel.text = @"";
            _priceLabel.hidden = YES;
            _appointmentTimeLabel.text = @"";
            _appointmentTimeLabel.hidden = YES;
            [self setupAutoHeightWithBottomViewsArray:@[_deviceLabel] bottomMargin:15];
        }
    }
    
}
//- (void)setUserInfo2:(UserReserveInfo *)userInfo2 {
//    _userInfo2 = userInfo2;
//    _priceLabel.hidden = YES;
//
//    NSString *dateString = [userInfo2.systime substringToIndex:16];
//
//    _timeLabel.text = [NSString stringWithFormat:@"报修时间  %@",dateString];
//    _deviceLabel.text = [NSString stringWithFormat:@"报修设施  %@",userInfo2.typeName];
//    [self setupAutoHeightWithBottomViewsArray:@[_deviceLabel] bottomMargin:15];
//
//}

- (void)setUserComplaint2:(UserComplaint *)userComplaint2 {
    _userComplaint2 = userComplaint2;
    
    _priceLabel.hidden = YES;
    _deviceLabel.hidden = YES;
    
    NSString *dateString = [userComplaint2.systime substringToIndex:16];

    _timeLabel.text = [NSString stringWithFormat:@"投诉时间    %@",dateString];
    [self setupAutoHeightWithBottomViewsArray:@[_timeLabel] bottomMargin:15];
}


@end
