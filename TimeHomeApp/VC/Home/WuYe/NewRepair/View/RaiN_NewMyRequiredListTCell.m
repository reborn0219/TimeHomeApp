//
//  RaiN_NewMyRequiredListTCell.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/9/6.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_NewMyRequiredListTCell.h"

@implementation RaiN_NewMyRequiredListTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(UserReserveInfo *)model {
    _model = model;
    
    NSString *dateString = [model.systime substringToIndex:16];
    
    _timeLabel.text = dateString;
    
    
    if ([model.type intValue] == 0) {
        _leftImageView.image = [UIImage imageNamed:@"NEW家用"];
        _topTitleLabel.text = [NSString stringWithFormat:@"家用设施：%@",model.typeName];
    }else {
        _topTitleLabel.text = [NSString stringWithFormat:@"公共设施：%@",model.typeName];
        _leftImageView.image = [UIImage imageNamed:@"NEW公共"];
    }
    //    model.state = @"3";
    if ([model.isok intValue] == 1) {
        
        switch ([model.state intValue]) {
            case -1:
            {
                _stateLabel.text = @"已驳回";
                _stateImageView.image = [UIImage imageNamed:@"新在线报修驳回"];
            }
                break;
            case 0:
            {
                _stateLabel.text = @"待分派物业";
                _stateImageView.image = [UIImage imageNamed:@"新在线报修等待"];
            }
                break;
            case 1:
            {
                _stateLabel.text = @"物业已接收";
                _stateImageView.image = [UIImage imageNamed:@"新在线报修成功"];
            }
                break;
            case 2:
            {
                _stateLabel.text = @"维修处理中";
                _stateImageView.image = [UIImage imageNamed:@"新在线报修维修中..."];
            }
                break;
            case 3:
            {
                _stateLabel.text = @"已完成 待评价";
                _stateImageView.image = [UIImage imageNamed:@"新在线报修成功"];
            }
                break;
            case 4:
            {
                _stateLabel.text = @"已评价";
                _stateImageView.image = [UIImage imageNamed:@"新在线报修成功"];
            }
                break;
            case -2:
            {
                _stateLabel.text = @"暂不维修";
                _stateImageView.image = [UIImage imageNamed:@"新在线报修暂停"];
            }
                break;
            default:
                break;
        }
        
    }else {
        _stateLabel.text = @"暂不维修";
        _stateImageView.image = [UIImage imageNamed:@"新在线报修暂停"];
    }
    
}

@end
