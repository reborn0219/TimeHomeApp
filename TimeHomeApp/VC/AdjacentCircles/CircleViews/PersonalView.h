//
//  PersonalView.h
//  TimeHomeApp
//
//  Created by UIOS on 16/2/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalView : UIView
@property (weak, nonatomic) IBOutlet UIView *sexAgeV;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIButton *setNoteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
- (IBAction)setNotAction:(id)sender;

@end
