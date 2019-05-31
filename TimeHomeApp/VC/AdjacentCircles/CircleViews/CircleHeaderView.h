//
//  CircleHeaderView.h
//  TimeHomeApp
//
//  Created by UIOS on 16/2/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *xiaoquLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (strong,nonatomic)CellEventBlock headerBlock;
@property (strong,nonatomic)CellEventBlock contentBlock;
@property (copy,nonatomic)NSIndexPath * indexPath;
@property (weak, nonatomic) IBOutlet UIView *sexAgeView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *ageLb;
@property (weak, nonatomic) IBOutlet UIView *touchView;

@end
