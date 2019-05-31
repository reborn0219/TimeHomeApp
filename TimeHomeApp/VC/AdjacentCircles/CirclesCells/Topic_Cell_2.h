//
//  Topic_Cell_2.h
//  TimeHomeApp
//
//  Created by UIOS on 16/2/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RecommendTopicModel.h"
//@protocol TopicCellDelegate
//
//-(void)topicCellTowCallBlack:(NSIndexPath *)index andButton:(UIButton *)btn;
//
//@end

@interface Topic_Cell_2 : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLb;

@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;
- (IBAction)guanZhuAction:(id)sender;
@property(nonatomic,copy)CellEventBlock block;
@property(nonatomic,strong)NSIndexPath * indexPath;
@end
