//
//  L_NewBikeInfoTitle1TableViewCell.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/1/20.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewBikeInfoTitle1TableViewCell.h"

@implementation L_NewBikeInfoTitle1TableViewCell

- (void)setBikeModel:(L_BikeListModel *)bikeModel {
    
    _bikeModel = bikeModel;
    
    _equipmentId.text = [XYString IsNotNull:bikeModel.bikeno];
    
    //自行车类型 0 自行车 1电动车
    if (bikeModel.devicetype.integerValue == 1) {
        _bikeType.text = @"电动车";
    }else if (bikeModel.devicetype.integerValue == 0){
        _bikeType.text = @"自行车";
    }else {
        _bikeType.text = @"";
    }
    
    _bikeBrand.text = [XYString IsNotNull:bikeModel.brand];
    
    if ([XYString isBlankString:bikeModel.color]) {
        _bikeColor.text = @"暂无";
    }else {
        _bikeColor.text = bikeModel.color;
    }

    /** 自行车是否锁定：0否1是 */
    if (bikeModel.islock.integerValue == 0) {
        _inOrOut.text = @"未锁定";
    }else {
        if ([XYString isBlankString:bikeModel.parklotname] && [XYString isBlankString:bikeModel.communitynamelock]) {
            _inOrOut.text = [NSString stringWithFormat:@"已锁定"];
        }else if ([XYString isBlankString:bikeModel.parklotname]) {
            _inOrOut.text = [NSString stringWithFormat:@"已锁定(%@)",bikeModel.communitynamelock];
        }else if ([XYString isBlankString:bikeModel.communitynamelock]) {
            _inOrOut.text = [NSString stringWithFormat:@"已锁定(%@)",bikeModel.parklotname];
        }else {
            _inOrOut.text = [NSString stringWithFormat:@"已锁定(%@ %@)",bikeModel.communitynamelock,bikeModel.parklotname];
        }
        
    }
    
    if (bikeModel.systime.length >= 19) {
        _bikeTime.text = [XYString IsNotNull:[bikeModel.systime substringToIndex:19]];
    }else {
        if ([XYString isBlankString:bikeModel.systime]) {
            _bikeTime.text = @"暂无";
        }else {
            _bikeTime.text = bikeModel.systime;
        }
    }
    
    [self layoutIfNeeded];
    
    CGFloat bottomY = CGRectGetMaxY(_bikeTime.frame);
    
    bikeModel.infoFirstRowHeight = bottomY + 20;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _inOrOut.text = @"";
    _bikeTime.text = @"";
    _bikeColor.text = @"";
    _bikeType.text = @"";

    // 注意：如果在XIB中有动态计算高度的Label 要写一下代码：（以确保正确计算label 的高度）
    _equipmentId.preferredMaxLayoutWidth = SCREEN_WIDTH - 30 - 81;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
