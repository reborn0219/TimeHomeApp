//
//  THMyrequiredTVCStyle1.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyrequiredTVCStyle1.h"

@implementation THMyrequiredTVCStyle1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}
- (void)setUp {
    
    _lineView = [[UIView alloc]init];
    [self.contentView addSubview:_lineView];
    
    _detailLabel = [[UILabel alloc]init];
    _detailLabel.font = DEFAULT_FONT(14);
    _detailLabel.textColor = TITLE_TEXT_COLOR;
    _detailLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_detailLabel];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = DEFAULT_FONT(16);
    _titleLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_titleLabel];
    
    _titleLabel.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.contentView,15).heightIs(20).rightSpaceToView(self.contentView,10);
    
    _detailLabel.sd_layout.rightSpaceToView(self.contentView,24).heightIs(20).topSpaceToView(_titleLabel,10).leftSpaceToView(self.contentView,10);
    _lineView.sd_layout.rightSpaceToView(self.contentView,10).centerYEqualToView(_detailLabel).heightIs(18).widthIs(4);
    _lineView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
//    [self setupAutoHeightWithBottomViewsArray:@[_lineView,_detailLabel,_titleLabel] bottomMargin:15];
    [self setupAutoHeightWithBottomViewsArray:@[_lineView,_detailLabel] bottomMargin:15];
    
}
- (void)setUserInfo:(UserReserveInfo *)userInfo {
    _userInfo = userInfo;
    _titleLabel.text = [NSString stringWithFormat:@"维修单号  %@",userInfo.reserveno];
    
//    _titleLabel.adjustsFontSizeToFitWidth = YES;
    
    if ([userInfo.isok intValue] == 1) {
        
        switch ([userInfo.state intValue]) {
            case -1:
            {
                _detailLabel.text = @"已驳回";
                _lineView.backgroundColor = TEXT_COLOR;
            }
                break;
            case 0:
            {
                _detailLabel.text = @"待分派物业";
                _lineView.backgroundColor = kNewRedColor;
            }
                break;
            case 1:
            {
                _detailLabel.text = @"物业已接收";
                _lineView.backgroundColor = MAN_COLOR;//蓝色
            }
                break;
            case 2:
            {
                _detailLabel.text = @"处理中";
                _lineView.backgroundColor = MAN_COLOR;//蓝色
            }
                break;
            case 3:
            {
                _detailLabel.text = @"已完成 待评价";
                _lineView.backgroundColor = GREEN_COLOR;//绿色
            }
                break;
            case 4:
            {
                _detailLabel.text = @"已评价";
                _lineView.backgroundColor = GREEN_COLOR;//绿色
            }
                break;
            case -2:
            {
                _detailLabel.text = @"暂不维修";
                _lineView.backgroundColor = TEXT_COLOR;
            }
                break;
            default:
                break;
        }
        
    }else {
        _detailLabel.text = @"暂不维修";
        _lineView.backgroundColor = TEXT_COLOR;
    }
    
}
- (void)setUserComplaint:(UserComplaint *)userComplaint {
    _userComplaint = userComplaint;
    
    if ([userComplaint.state intValue] == 0) {
        _lineView.backgroundColor = kNewRedColor;
        _detailLabel.text = @"待处理";
    }else {
        _lineView.backgroundColor = GREEN_COLOR;
        _detailLabel.text = @"已处理";
    }
    NSString *dateString = [userComplaint.systime substringToIndex:16];
    _titleLabel.text = dateString;

}
- (void)setUserComplaint2:(UserComplaint *)userComplaint2 {
    _userComplaint2 = userComplaint2;
    if ([userComplaint2.state intValue] == 0) {
        _lineView.backgroundColor = kNewRedColor;
        _detailLabel.text = @"待处理";
    }else {
        _lineView.backgroundColor = GREEN_COLOR;
        _detailLabel.text = @"已处理";
    }
    _titleLabel.text = [NSString stringWithFormat:@"投诉单号: %@",userComplaint2.complaintno];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
}


@end
