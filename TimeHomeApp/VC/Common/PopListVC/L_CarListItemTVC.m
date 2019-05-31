//
//  L_CarListItemTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/7/27.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_CarListItemTVC.h"

@implementation L_CarListItemTVC

- (void)setGateModel:(L_CorrgateModel *)gateModel {
    
    _gateModel = gateModel;
    
    _content_Label.text = [XYString IsNotNull:gateModel.aislename];
    
    [self layoutIfNeeded];
    
    CGFloat rectY = CGRectGetMaxY(_content_Label.frame);
    
    gateModel.height = rectY + 15;
    
}

//- (void)setCarNumDict:(NSDictionary *)carNumDict {
//    
//    _carNumDict = carNumDict;
//    
//    _content_Label.text = [XYString IsNotNull:carNumDict[@"card"]];
//
//    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:carNumDict];
//    
//    [self layoutIfNeeded];
//    
//    CGFloat rectY = CGRectGetMaxY(_content_Label.frame);
//    
//    [mutDic setObject:[NSString stringWithFormat:@"%f",rectY+15] forKey:@"height"];
//    
//    carNumDict = [mutDic copy];
//}

- (void)awakeFromNib {
    [super awakeFromNib];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
