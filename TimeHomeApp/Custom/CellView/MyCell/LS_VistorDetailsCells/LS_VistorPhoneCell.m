//
//  LS_VistorPhoneCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/8/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LS_VistorPhoneCell.h"

@implementation LS_VistorPhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)callPoneAction:(id)sender {
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)assignmentWithModel:(UserVisitor *)UV
{
    [super assignmentWithModel:UV];
    self.masterNameLb.text = UV.ownername;
    self.masterCallLb.text = UV.ownerphone;
    self.friendNameLb.text = UV.visitname;
    self.friendCallLb.text = UV.visitphone;
    
}
@end
