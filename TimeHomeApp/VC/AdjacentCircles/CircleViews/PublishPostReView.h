//
//  PublishPostReView.h
//  TimeHomeApp
//
//  Created by UIOS on 16/4/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishPostReView : UICollectionReusableView

@property (nonatomic ,copy)UpDateViewsBlock imgBlock;
@property (nonatomic , copy)UpDateViewsBlock followBlock;

@property (weak, nonatomic) IBOutlet UILabel *IntroductionLB;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
- (IBAction)selectImgAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
- (IBAction)addFollowAction:(id)sender;

@end
