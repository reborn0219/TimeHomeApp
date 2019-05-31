//
//  ReviewDetailVC.h
//  TimeHomeApp
//
//  Created by us on 16/6/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "UserTopicModel.h"
#import "RecommendTopicModel.h"

@interface ReviewDetailVC : THBaseViewController
@property (nonatomic,strong)RecommendTopicModel * RTML;
@property (nonatomic,copy)NSString * topicID;
@property (weak, nonatomic) IBOutlet UILabel *topicContentLb;
@property (weak, nonatomic) IBOutlet UIImageView *topicImgView;
@property (weak, nonatomic) IBOutlet UIView *noPassView;
@property (weak, nonatomic) IBOutlet UIView *reviewingView;
@property (weak, nonatomic) IBOutlet UILabel *reasonLb;

@end
