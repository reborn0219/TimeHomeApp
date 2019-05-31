//
//  LS_BottomEditView.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.


#import <UIKit/UIKit.h>

@interface LS_BottomEditView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *selImgView;
@property (nonatomic, copy) AlertBlock alertblock;
@property (nonatomic, assign) BOOL isAllSelect;
-(void)editBlock:(AlertBlock)block;
- (IBAction)clearBtnAction:(id)sender;
- (IBAction)allSelectBtnAction:(id)sender;

@end
