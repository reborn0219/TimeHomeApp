//
//  PublishTopicVC.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/7.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface PublishTopicVC : THBaseViewController
- (IBAction)selectedImageAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextView *contentTextV;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
