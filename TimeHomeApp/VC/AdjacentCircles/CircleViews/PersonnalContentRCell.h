//
//  PersonnalContentRCell.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonnalContentRCell : UICollectionReusableView
@property (nonatomic,copy) NSIndexPath * indexPath;

@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (nonatomic ,copy) CellEventBlock block;
@property (weak, nonatomic) IBOutlet UIImageView *lineImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIButton *rightArrowBtn;

@end
