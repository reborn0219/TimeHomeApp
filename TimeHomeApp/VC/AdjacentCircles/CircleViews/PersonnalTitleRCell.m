//
//  PersonnalTitleRCell.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PersonnalTitleRCell.h"

@implementation PersonnalTitleRCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
    
    self.ageView.layer.cornerRadius = 8;
    self.noteBtn.layer.cornerRadius = 10;
    self.noteBtn.layer.borderWidth = 1;
    self.noteBtn.layer.borderColor = UIColorFromRGB(0xAB4D4F).CGColor;
    
}

- (IBAction)noteAction:(id)sender {
    self.block(nil,SucceedCode);
}
@end
