//
//  PersonalView.m
//  TimeHomeApp
//
//  Created by UIOS on 16/2/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PersonalView.h"

@implementation PersonalView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [super awakeFromNib];

    self.headerImgV.layer.masksToBounds = YES;
    self.headerImgV.layer.cornerRadius = 30;
    self.setNoteBtn.layer.cornerRadius = 10;
    self.setNoteBtn.layer.borderWidth = 1;
    self.setNoteBtn.layer.borderColor = UIColorFromRGB(0x96111A).CGColor;
    self.sexAgeV.layer.cornerRadius = 10;
    
}
- (IBAction)setNotAction:(id)sender {
}
@end
