//
//  PAWaterBottomView.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterBottomView.h"

@interface PAWaterBottomView()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@end

@implementation PAWaterBottomView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.payButton.layer.cornerRadius= 2.0;
    self.payButton.layer.masksToBounds = YES;
}
- (void)updateMoney:(NSInteger )money{
    self.moneyLabel.text = [NSString stringWithFormat:@"%ld",(long)money];
    self.money = money;
}

- (IBAction)payButtonClick:(id)sender {
    if (self.payButtonClickBlock) {
        self.payButtonClickBlock(@(self.money), nil, 0);
    }
}

@end
