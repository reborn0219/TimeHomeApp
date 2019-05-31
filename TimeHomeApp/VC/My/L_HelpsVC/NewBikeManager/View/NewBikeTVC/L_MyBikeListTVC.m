//
//  L_MyBikeListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/9/6.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyBikeListTVC.h"

@implementation L_MyBikeListTVC

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    //遍历子视图，找出左滑按钮
    
    for (UIView *subView in self.subviews)
        
    {
        
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
            
        {
            
            for (UIButton *btn in subView.subviews) {
                
                if ([btn isKindOfClass:[UIButton class]]) {
                    
                    btn.titleLabel.font = [UIFont systemFontOfSize:15];
                    
                }
            }
        }
    }
    
}

- (void)setModel:(L_BikeListModel *)model {
    
    _model = model;
    
    _bikeBrand_Label.text = [XYString IsNotNull:model.brand];/** 品牌 */
    
    /** 自行车类型 0 自行车 1电动车  */
    if (model.devicetype.integerValue == 1) {
        _bikeType_Label.text = @"电动车";
    }
    if (model.devicetype.integerValue == 0) {
        _bikeType_Label.text = @"自行车";
    }
    
    _communityName_Label.text = [XYString IsNotNull:model.communityname];
    
    /** 感应条码 */
    if (model.device.count == 0) {
        
        _bottomLeft_Label.text = @"感应条码";
        _bottomLeft_ImageView.image = [UIImage imageNamed:@"二轮车优化-条码"];
        
        _bottomMiddle_Label.text = @"未锁定";
        _bottomMiddle_Label.textColor = UIColorFromRGB(0xc0bebe);
        _bottomMiddle_ImageView.image = [UIImage imageNamed:@"二轮车优化-未锁灰"];
        
        _bottomRight_Label.text = @"定时锁车";
        _bottomRight_Label.textColor = UIColorFromRGB(0xc0bebe);
        _bottomRight_ImageView.image = [UIImage imageNamed:@"二轮车优化-定时灰"];
        
    }else {

        _bottomLeft_Label.text = @"修改二轮车";
        _bottomLeft_ImageView.image = [UIImage imageNamed:@"二轮车优化-修改"];
        
        _bottomRight_Label.text = @"定时锁车";
        _bottomRight_Label.textColor = kNewRedColor;
        _bottomRight_ImageView.image = [UIImage imageNamed:@"二轮车优化-定时"];
        
        /** 自行车是否锁定：0否1是 */
        if (model.islock.integerValue == 0) {
            _bottomMiddle_Label.text = @"未锁定";
            _bottomMiddle_Label.textColor = kNewRedColor;
            _bottomMiddle_ImageView.image = [UIImage imageNamed:@"二轮车优化-未锁"];
            
        }else {
            
            _bottomMiddle_Label.text = @"已锁定";
            _bottomMiddle_Label.textColor = kNewRedColor;
            _bottomMiddle_ImageView.image = [UIImage imageNamed:@"二轮车优化-已锁"];
            
        }

    }
    
}

- (IBAction)allButtonsDidTouch:(UIButton *)sender {
    //1.左边 2.中间 3.右边
    
    if (self.btnDidClickBlock) {
        self.btnDidClickBlock(nil, nil, sender.tag);
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.layer.borderColor = UIColorFromRGB(0xc1c1c1).CGColor;
    self.contentView.layer.borderWidth = 1.;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
