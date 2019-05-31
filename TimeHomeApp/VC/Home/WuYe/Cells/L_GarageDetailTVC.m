//
//  L_GarageDetailTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/12/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_GarageDetailTVC.h"

@implementation L_GarageDetailTVC

- (void)awakeFromNib {
    [super awakeFromNib];

    
}

- (void)setCarModel:(ParkingCarModel *)carModel {
    _carModel = carModel;
    
    if (carModel.isinit.integerValue == 1) {
        self.img_Init.hidden = NO;
    }else {
        self.img_Init.hidden = YES;
    }

    self.carNum_Label.text = [XYString IsNotNull:carModel.card];
    
    //        cell.lab_Name.text=carModle.remarks;

    
}

- (IBAction)garageButtonsDidTouch:(UIButton *)sender {
    
    //1.删除 2.修改 3.定时锁车、关闭定时
    if (self.buttonsCallBack) {
        self.buttonsCallBack(sender.tag);
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
