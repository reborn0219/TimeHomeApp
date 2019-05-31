//
//  MessageInputAlert.h
//  TimeHomeApp
//
//  Created by 优思科技 on 16/8/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageInputAlert : UIViewController
- (IBAction)closeAction:(id)sender;
- (IBAction)comfirmAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *backV;
@property (weak, nonatomic) IBOutlet UITextView *textV;
+(instancetype)shareMessageInputAlert;
@property (nonatomic,copy)UpDateViewsBlock block;
-(void)show:(UIViewController * )VC;
-(void)dismiss;

@end
