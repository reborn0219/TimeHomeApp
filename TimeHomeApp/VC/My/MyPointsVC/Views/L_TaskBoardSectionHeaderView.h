//
//  L_TaskBoardSectionHeaderView.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface L_TaskBoardSectionHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *sectionTitleLabel;

+ (L_TaskBoardSectionHeaderView *)getInstance;

@end
