//
//  PANewHomeNoticeCell.m
//  TimeHomeApp
//
//  Created by ning on 2018/7/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHomeNoticeCell.h"
#import "PAHomeNoticeLabel.h"
#import "NotificationVC.h"
#import "PANewHomeNoticeModel.h"
#import "PANewNoticeViewController.h"
#import "PANewNoticeModel.h"


@interface PANewHomeNoticeCell()

@property (weak, nonatomic) IBOutlet PAHomeNoticeLabel *noticeLabel;

@end

@implementation PANewHomeNoticeCell

#pragma mark - Lifecycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setNotificArray:(NSArray *)notificArray{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSInteger i=0; i<notificArray.count; i++) {
        
        PANewHomeNoticeModel *model = notificArray[i];
        NSDictionary *dict = [model yy_modelToJSONObject];
        [tempArray addObject:dict];
    }
    [self.noticeLabel setNotificArray:tempArray];
}

#pragma mark - Actions
- (IBAction)noticeButtonClick:(id)sender {
    AppDelegate * appDlt = GetAppDelegates;
    if(appDlt.userData.openmap!=nil){
        NSInteger flag=[[appDlt.userData.openmap objectForKey:@"pronotice"] integerValue];
        if(flag==0){
            //[self showToastMsg:@"您的社区暂未开通该服务" Duration:5];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD showErrorWithStatus:@"您的社区暂未开通该服务"];
            [SVProgressHUD dismissWithDelay:5.0];
            return;
        }
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
    NotificationVC *notice = [storyboard instantiateViewControllerWithIdentifier:@"NotificationVC"];
    //PANewNoticeViewController * notice = [[PANewNoticeViewController alloc]init];
    if (self.callback) {
        self.callback(notice);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
