//
//  PAWaterFailView.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/4.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterFailView.h"
#import "PAWaterOrderModel.h"
@interface PAWaterFailView()
@property (weak, nonatomic) IBOutlet UIView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *waterNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *getWaterButton;
@property (weak, nonatomic) IBOutlet UILabel *merOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *communityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaTitleLabel;

@end

@implementation PAWaterFailView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

#pragma mark - initUI
- (void)initUI{
    self.iconView.layer.borderColor = [UIColor colorWithHexString:@"#276DFC"].CGColor;
    self.iconView.layer.borderWidth = 1.0;
    self.closeButton.layer.borderColor = [UIColor colorWithHexString:@"#007AFF"].CGColor;
    self.closeButton.layer.borderWidth = 1.0;
    [self.areaNameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [self.communityNameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [self.communityTitleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [self.areaTitleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    self.getWaterButton.layer.cornerRadius = 2.0;
    self.getWaterButton.layer.masksToBounds = YES;
    self.closeButton.layer.cornerRadius = 2.0;
    self.closeButton.layer.masksToBounds = YES;
    [self.amountLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
    [self.waterNumLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
}

-(void)setOrderDataModel:(PAWaterOrderModel *)orderDataModel{
    _orderDataModel = orderDataModel;
    self.merOrderLabel.text = [NSString stringWithFormat:@"%@",orderDataModel.merOrderId];
    self.communityNameLabel.text = [NSString stringWithFormat:@"%@",orderDataModel.communityName];
    self.areaNameLabel.text = [NSString stringWithFormat:@"%@",orderDataModel.areaName];
    self.deviceNameLabel.text = [NSString stringWithFormat:@"%@",orderDataModel.deviceName];
    self.amountLabel.text = [NSString stringWithFormat:@"%@",orderDataModel.amount];
    self.waterNumLabel.text = [NSString stringWithFormat:@"%@",orderDataModel.waterNum];
}

#pragma mark - Actions
- (IBAction)closeButtonClick:(id)sender {
    if (self.callBackBlock) {
        self.callBackBlock(nil, self, 0);
    }
}

- (IBAction)getWaterClick:(id)sender {
    if (self.callBackBlock) {
        self.callBackBlock(nil, self, 1);
    }
}

@end
