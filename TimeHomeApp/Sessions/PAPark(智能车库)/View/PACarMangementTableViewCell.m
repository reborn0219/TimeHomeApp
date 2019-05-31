//
//  PACarMangementTableViewCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarMangementTableViewCell.h"
@interface PACarMangementTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *carStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *lockButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) PACarManagementModel *carModel;
@end
@implementation PACarMangementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.editButton.layer.cornerRadius = 12;
    self.editButton.layer.borderWidth =1;
    self.editButton.layer.borderColor = UIColorFromRGB(0x3090E9).CGColor;
    self.deleteButton.layer.cornerRadius = 12;
    self.deleteButton.layer.borderWidth =1;
    self.deleteButton.layer.borderColor = UIColorFromRGB(0xD0021B).CGColor;

}
#pragma mark - 锁车
- (IBAction)lockCarAction:(id)sender {
    
    if (self.block) {
        self.block(_carModel, nil, 1);
    }
}
- (IBAction)editCarAction:(id)sender {
    
    if (self.block) {
        
        self.block(_carModel, nil, 2);

    }
}

- (IBAction)deleteCarAction:(id)sender {
    if (self.block) {
        
        self.block(_carModel, nil, 0);
    }
}

-(void)assignmentWithModel:(PACarManagementModel *)vehicleModel{
    _carModel = vehicleModel;
    self.carNumberLabel.text = vehicleModel.carNo;
    if (vehicleModel.isInLib.integerValue == 1) {
        self.carStateLabel.textColor = UIColorFromRGB(0x3276C4);
        [self.lockButton setHidden:NO];
        self.carStateLabel.text = @"已入库";
        [self.deleteButton setHidden:YES];
        [self.editButton setHidden:YES];
    }else
    {
        self.carStateLabel.text = @"未入库";
        self.carStateLabel.textColor = UIColorFromRGB(0x909090);
        [self.lockButton setHidden:YES];
        [self.deleteButton setHidden:NO];
        [self.editButton setHidden:NO];
    }
    
}
-(void)limitedToEdit:(BOOL)isLimited{
    
    if (isLimited) {
        [self.editButton setHidden:isLimited];
        [self.deleteButton setHidden:isLimited];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
