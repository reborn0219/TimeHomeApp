//
//  PAWaterOrderNotFinishCell.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/4.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterOrderNotFinishCell.h"

@interface PAWaterOrderNotFinishCell()
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *waterNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricelabel;

@end

@implementation PAWaterOrderNotFinishCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setOrderModelData:(PAWaterOrderModel *)orderModelData{
    _orderModelData = orderModelData;
    self.orderIdLabel.text = [NSString stringWithFormat:@"账单号：%@",orderModelData.merOrderId];
    self.deviceNameLabel.text = [NSString stringWithFormat:@"%@",orderModelData.deviceName];
    self.communityNameLabel.text = [NSString stringWithFormat:@"%@",orderModelData.communityName];
    self.deviceNumLabel.text = [NSString stringWithFormat:@"%@",orderModelData.deviceNum];
    self.waterNumLabel.text = [NSString stringWithFormat:@"%@L",orderModelData.waterNum];
    self.amountLabel.text = [NSString stringWithFormat:@"%@元",orderModelData.amount];
    self.areaNameLabel.text = [NSString stringWithFormat:@"%@",orderModelData.areaName];
    self.pricelabel.text = [NSString stringWithFormat:@"%@升/元",orderModelData.waterPrice];
}

- (IBAction)toGetWaterClick:(id)sender {
    if (self.gotoWaterBlock) {
        self.gotoWaterBlock(nil, nil, 0);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
