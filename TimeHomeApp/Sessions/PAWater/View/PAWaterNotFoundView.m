//
//  PAWaterNotFoundView.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/4.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterNotFoundView.h"

@interface PAWaterNotFoundView()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;


@end

@implementation PAWaterNotFoundView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initUI];
}

- (void)initUI{
    self.messageLabel.text = @"无法搜索到设备\n可继续扫描或联系客服为您处理异常订单";
    self.continueButton.layer.borderColor = [UIColor colorWithHexString:@"#276DFC"].CGColor;
    self.continueButton.layer.borderWidth = 2.0;
}

- (IBAction)continueButtonClick:(id)sender {
    if (self.continueScanBlock) {
        self.continueScanBlock(@"", self, 0);
    }
}

@end
