//
//  PersonnalTitleRCell.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOTagList.h"

@interface PersonnalTitleRCell : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *ageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIButton *noteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *ageLb;
@property (weak, nonatomic) IBOutlet VOTagList *colorLabelV;
@property (nonatomic,copy)UpDateViewsBlock block;
@property (weak, nonatomic) IBOutlet UIImageView *lineImg;
@property (weak, nonatomic) IBOutlet UILabel *levelLb;

- (IBAction)noteAction:(id)sender;

@end
