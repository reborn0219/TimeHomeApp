//
//  PublishPostVC.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/30.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface PublishPostVC : THBaseViewController

@property (copy, nonatomic) NSString * topicID;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
- (IBAction)publishAction:(id)sender;

@end
