//
//  QuanZiCell.h
//  TimeHomeApp
//
//  Created by 优思科技 on 16/7/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuanZiCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberLb;

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;
- (IBAction)guanZhuAction:(id)sender;

@property (nonatomic,copy)NSIndexPath * indexPath;
@property (nonatomic,copy)CellEventBlock block;
@property (nonatomic,copy)NSString * ceshiStr;
@end
