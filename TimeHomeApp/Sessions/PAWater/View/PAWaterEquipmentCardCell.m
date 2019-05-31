//
//  PAWaterEquipmentCardCell.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterEquipmentCardCell.h"

@interface PAWaterEquipmentCardCell()
@property (weak, nonatomic) IBOutlet UILabel *bottomTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *iconView;
//设备编号
@property (weak, nonatomic) IBOutlet UILabel *deviceNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *waterPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaNameLabel;

@end

@implementation PAWaterEquipmentCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

- (void)initUI{
    self.bgView.layer.masksToBounds = YES;
    [self.bottomTitleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = 8.0;
}

-(void)setDeviceData:(PAWaterDispenserModel *)deviceData{

    _deviceData = deviceData;
    self.deviceNumLabel.text = [NSString stringWithFormat:@"编号：%@",deviceData.deviceNum];
    self.waterPriceLabel.text = [NSString stringWithFormat:@"%@升/元",deviceData.waterPrice];
    self.areaNameLabel.text = [NSString stringWithFormat:@"%@",deviceData.areaName];
}

@end
