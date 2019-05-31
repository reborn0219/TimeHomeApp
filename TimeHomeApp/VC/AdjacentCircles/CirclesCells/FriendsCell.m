//
//  FriendsCell.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "FriendsCell.h"

@implementation FriendsCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
    self.sexV.layer.cornerRadius = 8;
    self.imgV.layer.masksToBounds = YES;
    self.imgV.layer.cornerRadius = 22.5;
    self.rightBtn.layer.cornerRadius = 10;
    self.rightBtn.layer.borderColor = PURPLE_COLOR.CGColor;
    self.rightBtn.layer.borderWidth = 1.0f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (IBAction)removeAction:(id)sender {
    self.block(nil,nil,_indexPath);

}
@end
