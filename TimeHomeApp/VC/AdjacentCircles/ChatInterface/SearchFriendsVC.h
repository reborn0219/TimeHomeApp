//
//  SearchFriendsVC.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/15.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchFriendsVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *searchV;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)backAction:(id)sender;
- (IBAction)editingChanged:(id)sender;

@end
