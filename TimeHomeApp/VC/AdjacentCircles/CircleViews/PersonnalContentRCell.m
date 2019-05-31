//
//  PersonnalContentRCell.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PersonnalContentRCell.h"

@implementation PersonnalContentRCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dongTaiAction:)];
    [self addGestureRecognizer:tap];
    
}
-(void)dongTaiAction:(UIGestureRecognizer *)gesture
{
    NSInteger tag = ((PersonnalContentRCell *)[gesture view]).indexPath.section;
    self.block(nil,nil,_indexPath);
    
    NSLog(@"%ld",(long)tag);
    
}
@end
