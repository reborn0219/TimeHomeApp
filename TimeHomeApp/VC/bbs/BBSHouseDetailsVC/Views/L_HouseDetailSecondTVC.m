//
//  L_HouseDetailSecondTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_HouseDetailSecondTVC.h"

@interface L_HouseDetailSecondTVC ()
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation L_HouseDetailSecondTVC

- (void)setModel:(L_HouseDetailModel *)model {
    
    _model = model;

    _titleLabel.hidden = NO;
    _bottomLineView.hidden = NO;

    //10 房产出售 11 房产出租30 车位出售 31 车位出租
    if (model.housetype.integerValue == 10 ) {
        _titleLabel.text = @"房源描述";
        
        _roomsLabel.text = [NSString stringWithFormat:@"户型 | %@室 %@厅 %@卫",model.bedroom,model.livingroom,model.toilef];
        
        NSString *areaStr = [NSString stringWithFormat:@"%.2f",model.area.floatValue];
        if ([[XYString IsNotNull:areaStr] isEqualToString:@""]) {
            
            self.areaLabel.text = [XYString IsNotNull:[NSString stringWithFormat:@"面积 | 0㎡"]];
        }else{
            
            self.areaLabel.text = [NSString stringWithFormat:@"面积 | %@㎡",@(areaStr.doubleValue)];
        }
        
        _levelLabel.text = [NSString stringWithFormat:@"楼层 | 第%@层 共%@层",model.floornum,model.allfloornum];
        
        NSString *priceStr = [NSString stringWithFormat:@"%0.2f",model.price.floatValue];
        if ([[XYString IsNotNull:priceStr] isEqualToString:@""]) {
            
            _priceLabel.text = [NSString stringWithFormat:@"单价 | 0元/㎡"];
        }else{
            
            _priceLabel.text = [NSString stringWithFormat:@"单价 | %@元/㎡",@(priceStr.doubleValue)];
        }

        model.firstHeight = 140;
        
    }else if (model.housetype.integerValue == 11) {
        _titleLabel.text = @"房源描述";
        
        _roomsLabel.text = [NSString stringWithFormat:@"户型 | %@室 %@厅 %@卫",model.bedroom,model.livingroom,model.toilef];
        
        NSString *areaStr = [NSString stringWithFormat:@"%.2f",model.area.floatValue];
        if ([[XYString IsNotNull:areaStr] isEqualToString:@""]) {
            
            self.areaLabel.text = [XYString IsNotNull:[NSString stringWithFormat:@"面积 | 0㎡"]];
        }else{
            
            self.areaLabel.text = [NSString stringWithFormat:@"面积 | %@㎡",@(areaStr.doubleValue)];
        }
        
        if ([model.decorattype isEqualToString:@"1"]) {
            
            _levelLabel.text = [NSString stringWithFormat:@"装修 | 拎包入住"];
        }else if ([model.decorattype isEqualToString:@"2"]){
            
            _levelLabel.text = [NSString stringWithFormat:@"装修 | 简单装修"];
        }else{
            
            _levelLabel.text = [NSString stringWithFormat:@"装修 | "];
        }
        
        NSString *priceStr = [NSString stringWithFormat:@"%0.2f",model.price.doubleValue];
        if ([[XYString IsNotNull:priceStr] isEqualToString:@""]) {
            
            _priceLabel.text = [NSString stringWithFormat:@"租金 | 0元/月"];
        }else{
            
            _priceLabel.text = [NSString stringWithFormat:@"租金 | %@元/月",@(priceStr.doubleValue)];
        }

        model.firstHeight = 140;

    }else if (model.housetype.integerValue == 30) {
        _titleLabel.text = @"车位描述";
        
        if ([model.fixed isEqualToString:@"0"]) {
            
            _roomsLabel.text = [NSString stringWithFormat:@"位置 | 非固定"];
        }else if ([model.fixed isEqualToString:@"1"]){
            
            _roomsLabel.text = [NSString stringWithFormat:@"位置 | 固定"];
        }
        
        if ([model.underground isEqualToString:@"0"]) {
            
            _areaLabel.text = [NSString stringWithFormat:@"模式 | 地上车位"];
        }else if ([model.underground isEqualToString:@"1"]){
            
            _areaLabel.text = [NSString stringWithFormat:@"模式 | 地下车位"];
        }
        
        if ([[XYString IsNotNull:[NSString stringWithFormat:@"%0.2f",model.price.floatValue]] isEqualToString:@""]) {
            
            _levelLabel.text = [NSString stringWithFormat:@"总价 | 0元"];
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
                self.levelLabel.text = [NSString stringWithFormat:@"总价 | %@万元",lead];
            }else{
                
                self.levelLabel.text = [NSString stringWithFormat:@"总价 | %@元",moneyStr];
            }
        }
        
        model.firstHeight = 115;

    }else if (model.housetype.integerValue == 31) {
        _titleLabel.text = @"车位描述";
        
        if ([model.fixed isEqualToString:@"0"]) {
            
           _roomsLabel.text = [NSString stringWithFormat:@"位置 | 非固定"];
        }else if ([model.fixed isEqualToString:@"1"]){
            
            _roomsLabel.text = [NSString stringWithFormat:@"位置 | 固定"];
        }
        
        if ([model.underground isEqualToString:@"0"]) {
            
            _areaLabel.text = [NSString stringWithFormat:@"模式 | 地上车位"];
        }else if ([model.underground isEqualToString:@"1"]){
            
            _areaLabel.text = [NSString stringWithFormat:@"模式 | 地下车位"];
        }

        NSString *priceStr = [NSString stringWithFormat:@"%0.2f",model.price.floatValue];
        if ([[XYString IsNotNull:priceStr] isEqualToString:@""]) {
            
            _levelLabel.text = [NSString stringWithFormat:@"租金 | 0元/月"];
        }else{
            
            _levelLabel.text = [NSString stringWithFormat:@"租金 | %@元/月",@(priceStr.doubleValue)];
        }
        
        model.firstHeight = 115;
        
    }else {
        _titleLabel.text = @"";
        _roomsLabel.text = @"";
        _areaLabel.text = @"";
        _levelLabel.text = @"";
        _priceLabel.text = @"";
        
        model.firstHeight = 115;

    }
    

}

- (void)awakeFromNib {
    [super awakeFromNib];

    _titleLabel.text = @"";
    _roomsLabel.text = @"";
    _areaLabel.text = @"";
    _levelLabel.text = @"";
    _priceLabel.text = @"";

    _titleLabel.hidden = YES;
    _bottomLineView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
