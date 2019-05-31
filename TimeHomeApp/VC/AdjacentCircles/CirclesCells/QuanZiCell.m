//
//  QuanZiCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/7/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "QuanZiCell.h"

@implementation QuanZiCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)setCeshiStr:(NSString *)ceshiStr
{
    _ceshiStr = ceshiStr;
    
}
- (IBAction)guanZhuAction:(id)sender {
    
    self.block(nil,nil,_indexPath);
}
@end
