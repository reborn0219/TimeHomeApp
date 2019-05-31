//
//  PersonnalBarView.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PersonnalBarView.h"

@implementation PersonnalBarView

-(void)awakeFromNib
{
    [super awakeFromNib];

    self.badgeView.layer.cornerRadius = 4.0f;
    self.badgeView.hidden = YES;
      // [self setFrame:CGRectMake(0,SCREEN_HEIGHT - 55, SCREEN_WIDTH, 55)];

}

- (IBAction)focusAction:(id)sender {
    
    self.block(nil,nil,1000);
    
}
- (IBAction)chatAction:(id)sender {
    
    self.block(nil,nil,1001);
}
@end
