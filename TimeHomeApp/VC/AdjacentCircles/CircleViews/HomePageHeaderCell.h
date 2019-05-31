//
//  HomePageHeaderCell.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageHeaderCell : UICollectionReusableView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_1_H;
@property (weak, nonatomic) IBOutlet UIView *lineUpView;
@property (weak, nonatomic) IBOutlet UIView *view_1;
@property (weak, nonatomic) IBOutlet UIView *ageV;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *ageLb;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *levelLb;
@property (weak, nonatomic) IBOutlet UILabel *signatureLb;
- (IBAction)chatAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
- (IBAction)followAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (nonatomic , copy)UpDateViewsBlock block;
@property (nonatomic , copy)CellEventBlock contentBlock;
@property (nonatomic , copy)NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@end
