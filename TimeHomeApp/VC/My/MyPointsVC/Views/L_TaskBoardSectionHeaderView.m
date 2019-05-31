//
//  L_TaskBoardSectionHeaderView.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_TaskBoardSectionHeaderView.h"

@implementation L_TaskBoardSectionHeaderView

+ (L_TaskBoardSectionHeaderView *)getInstance {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"L_TaskBoardSectionHeaderView" owner:nil options:nil];
    L_TaskBoardSectionHeaderView *cv =[nibView objectAtIndex:0];
    return cv;
}

@end
