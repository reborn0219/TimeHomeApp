//
//  PAHaveBindingVehiclesTableViewCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAHaveBindingVehiclesTableViewCell.h"
@interface PAHaveBindingVehiclesTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *carLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIView *selectRectView;

@end

@implementation PAHaveBindingVehiclesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectRectView.layer.borderColor = UIColorFromRGB(0xC1C0C0).CGColor;
    self.selectRectView.layer.borderWidth = 1;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)assignmentWithModel:(PACarManagementModel *)vehicleModel{
    
    self.carLabel.text = vehicleModel.carNo;
    self.nameLabel.text = vehicleModel.ownerName?vehicleModel.ownerName:@"";
    
    [self.selectImageView setHidden:!vehicleModel.isSelected];
    
}
@end
