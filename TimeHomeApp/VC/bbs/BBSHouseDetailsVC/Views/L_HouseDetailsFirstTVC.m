//
//  L_HouseDetailsFirstTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_HouseDetailsFirstTVC.h"
#import "UIImage+ImageEffects.h"

@interface L_HouseDetailsFirstTVC ()

/**
 浏览图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *pvImageView;

/**
 时间图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *dateImageView;

/**
 定位图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyCentetLayout;


@end

@implementation L_HouseDetailsFirstTVC

- (void)setModel:(L_HouseDetailModel *)model {
    
    _model = model;
    
    if ([XYString isBlankString:model.pvcount]) {
        _pvcountLabel.text = @"0";
    }else {
        _pvcountLabel.text = [NSString stringWithFormat:@"%@",model.pvcount];
    }
    
    NSString *dateString = @"";
    if (model.releasetime.length > 10) {
        dateString = [model. releasetime substringToIndex:10];
    }else {
        dateString = model.releasetime;
    }
    _publishDateLabel.text = [NSString stringWithFormat:@"发布日期 %@",[XYString IsNotNull:dateString]];
    
    _communityNameLabel.text = [XYString IsNotNull:model.communityname];
    
    //10 房产出售 11 房产出租30 车位出售 31 车位出租
    if (model.housetype.integerValue == 10) {
        
        _moneyCentetLayout.constant = -8;
        
        if ([[XYString IsNotNull:[NSString stringWithFormat:@"%@",model.money]] isEqualToString:@""]) {
            
            self.moneyLabel.text = [NSString stringWithFormat:@"￥0元"];
        }else{
            
            NSString *moneyStr = [NSString stringWithFormat:@"%@",model.money];
            NSArray *array = [moneyStr componentsSeparatedByString:@"."];
            NSString *totalStr = array[0];
            if (totalStr.length >= 5) {
                
                NSString * lead = [totalStr substringToIndex:totalStr.length - 4];
                NSString * tail = [totalStr substringWithRange:NSMakeRange(totalStr.length - 4, 1)];
                if ([tail integerValue] >= 5) {
                    
                    lead = [NSString stringWithFormat:@"%li",[lead integerValue] + 1];
                }
                //[totalStr substringFromIndex:totalStr.length - 4];
                self.moneyLabel.text = [NSString stringWithFormat:@"￥%@万元",lead];
            }else{
                
                self.moneyLabel.text = [NSString stringWithFormat:@"￥%@元",moneyStr];
            }
        }
        
        NSString *priceStr = [NSString stringWithFormat:@"%0.2f",model.price.floatValue];
        if ([[XYString IsNotNull:priceStr] isEqualToString:@""]) {
            
            _priceLabel.text = [NSString stringWithFormat:@"0元/㎡"];
        }else{
            
            _priceLabel.text = [NSString stringWithFormat:@"%@元/㎡",@(priceStr.doubleValue)];
        }

    }else if (model.housetype.integerValue == 11) {
        _moneyCentetLayout.constant = 0;

        _priceLabel.text = @"";

        NSString *priceStr = [NSString stringWithFormat:@"%0.2f",model.price.doubleValue];
        if ([[XYString IsNotNull:priceStr] isEqualToString:@""]) {
            
            self.moneyLabel.text = [NSString stringWithFormat:@"￥0元/月"];
        }else{
            
            self.moneyLabel.text = [NSString stringWithFormat:@"￥%@元/月",@(priceStr.doubleValue)];
        }
        
    }else if (model.housetype.integerValue == 30) {
        _moneyCentetLayout.constant = 0;

        _priceLabel.text = @"";
        if ([[XYString IsNotNull:[NSString stringWithFormat:@"%0.2f",model.price.floatValue]] isEqualToString:@""]) {
            
            self.moneyLabel.text = [NSString stringWithFormat:@"￥0元"];
        }else{
            
            NSString *moneyStr = [NSString stringWithFormat:@"%0.2f",model.price.floatValue];
            NSArray *array = [moneyStr componentsSeparatedByString:@"."];
            NSString *totalStr = array[0];
            if (totalStr.length >= 5) {
                
                NSString * lead = [totalStr substringToIndex:totalStr.length - 4];
                NSString * tail = [totalStr substringWithRange:NSMakeRange(totalStr.length - 4, 1)];
                if ([tail integerValue] >= 5) {
                    
                    lead = [NSString stringWithFormat:@"%li",[lead integerValue] + 1];
                }
                //[totalStr substringFromIndex:totalStr.length - 4];
                self.moneyLabel.text = [NSString stringWithFormat:@"￥%@万元",lead];
            }else{
                
                self.moneyLabel.text = [NSString stringWithFormat:@"￥%@元",moneyStr];
            }
        }
        
    }else if (model.housetype.integerValue == 31) {
        _moneyCentetLayout.constant = 0;

        _priceLabel.text = @"";
        NSString *priceStr = [NSString stringWithFormat:@"%0.2f",model.price.floatValue];
        if ([[XYString IsNotNull:priceStr] isEqualToString:@""]) {
            
            self.moneyLabel.text = [NSString stringWithFormat:@"￥0元/月"];
        }else{
            
            self.moneyLabel.text = [NSString stringWithFormat:@"￥%@元/月",@(priceStr.doubleValue)];
        }
        
    }else {
        
        _priceLabel.text = @"";
        _moneyLabel.text = @"";
        
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    _moneyLabel.text = @"";
    _priceLabel.text = @"";
    _pvcountLabel.text = @"0";
    _communityNameLabel.text = @"";
    _publishDateLabel.text = @"";
    
    _pvImageView.image = [[UIImage imageNamed:@"邻趣-浏览图标"] imageWithColor:[UIColor whiteColor]];
    _dateImageView.image = [[UIImage imageNamed:@"邻趣-时间图标"] imageWithColor:[UIColor whiteColor]];
    _locationImageView.image = [[UIImage imageNamed:@"邻趣-发布-社区定位图标"] imageWithColor:[UIColor whiteColor]];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
