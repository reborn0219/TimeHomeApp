//
//  RentalAndSalesDetailVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/10.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RentalAndSalesDetailVC.h"
#import "ChatViewController.h"
#import "SysPresenter.h"
#import "DateUitls.h"

#import "YYCollectionPresent.h"

@interface RentalAndSalesDetailVC ()
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;
/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Price;
/**
 *  日期
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Date;
/**
 *  面积视图，用于隐藏面积部分
 */
@property (weak, nonatomic) IBOutlet UIView *view_Area;
/**
 *  厅室
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Rooms;
/**
 *  面积
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Area;
/**
 *  区
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_District;
/**
 *  详细描述
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Detail;
/**
 *  姓名电话
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_NamePhone;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nslayRoomHeight;
@property (weak, nonatomic) IBOutlet UIButton *collection_Button;

@property (weak, nonatomic) IBOutlet UIView *firstLineView;

@end

@implementation RentalAndSalesDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --------初始化----------
-(void)initView
{
    if(_jmpCode==0)//求租
    {
        self.view_Area.hidden=YES;
        self.nslayRoomHeight.constant=SCREEN_WIDTH-80;
    }
    if(self.publishRoom)
    {
        self.lab_Title.text=self.publishRoom.title;
        
        if (_jmpCode == 1) {
            if (self.publishRoom.moneyend.intValue == 0) {
                
                self.lab_Price.text = [NSString stringWithFormat:@"%@万元以上",[self.publishRoom.moneybegin stringByReplacingOccurrencesOfString:@".0" withString:@""]];
                
            }else if (self.publishRoom.moneybegin.intValue == 0) {
                
                self.lab_Price.text = [NSString stringWithFormat:@"%@万元以下",[self.publishRoom.moneyend stringByReplacingOccurrencesOfString:@".0" withString:@""]];
            }else {
                
                self.lab_Price.text = [NSString stringWithFormat:@"%@-%@万元",[self.publishRoom.moneybegin stringByReplacingOccurrencesOfString:@".0" withString:@""],[self.publishRoom.moneyend stringByReplacingOccurrencesOfString:@".0" withString:@""]];
            }
        }else {
            if (self.publishRoom.moneyend.intValue == 0) {
                self.lab_Price.text = [NSString stringWithFormat:@"%@元以上/月",[self.publishRoom.moneybegin stringByReplacingOccurrencesOfString:@".0" withString:@""]];
            }else if (self.publishRoom.moneybegin.intValue == 0) {
                self.lab_Price.text = [NSString stringWithFormat:@"%@元以下/月",[self.publishRoom.moneyend stringByReplacingOccurrencesOfString:@".0" withString:@""]];
            }else {
                self.lab_Price.text = [NSString stringWithFormat:@"%@-%@元/月",[self.publishRoom.moneybegin stringByReplacingOccurrencesOfString:@".0" withString:@""],[self.publishRoom.moneyend stringByReplacingOccurrencesOfString:@".0" withString:@""]];
            }
        }
        
//        NSString * pirce=[NSString stringWithFormat:@"%@元/月",self.publishRoom.money];
        if(_jmpCode==1)
        {
//            pirce=[NSString stringWithFormat:@"%@万",self.publishRoom.money];
            self.lab_Area.text=[NSString stringWithFormat:@"%@平米",self.publishRoom.area];
            NSMutableString * room=[NSMutableString new];
            if([self.publishRoom.bedroom integerValue]>0)
            {
                [room appendString:self.publishRoom.bedroom];
                [room appendString:@"室"];
            }
            if([self.publishRoom.livingroom integerValue]>0)
            {
                [room appendString:self.publishRoom.livingroom];
                [room appendString:@"厅"];
            }
            if([self.publishRoom.toilef integerValue]>0)
            {
                [room appendString:self.publishRoom.toilef];
                [room appendString:@"卫"];
            }
            self.lab_Rooms.text=room;
        }
        else
        {
            NSArray * tmp=@[@"整租一室",@"整租两室",@"整租三室",@"整租四室及以上",@"单间合租"];
            if([self.publishRoom.bedroom integerValue]==99)
            {
                self.lab_Rooms.text=@"单间合租";
            }
            else{
                if([self.publishRoom.bedroom integerValue]-1>=0&&[self.publishRoom.bedroom integerValue]-1<tmp.count)
                {
                    self.lab_Rooms.text=[tmp objectAtIndex:[self.publishRoom.bedroom integerValue]-1];
                }
                
            }
            if([self.publishRoom.bedroom integerValue]==0)
            {
                self.lab_Rooms.text=@"";
            }

        }
//        self.lab_Price.text=pirce;
        self.lab_Date.text=[DateUitls stringFromDate:[DateUitls DateFromString:self.publishRoom.releasedate DateFormatter:@"yyyy-MM-dd HH:mm:ss"] DateFormatter:@"yyyy-MM-dd HH:mm"];
        self.lab_District.text=self.publishRoom.countyname;
        self.lab_Detail.text=[XYString isBlankString:self.publishRoom.descriptionString]?@"暂无":self.publishRoom.descriptionString;
        self.lab_NamePhone.text=[NSString stringWithFormat:@"%@\n%@",self.publishRoom.linkman,self.publishRoom.linkphone];
        
        AppDelegate *appDelegate = GetAppDelegates;
        
        if (![XYString isBlankString:self.publishRoom.userid]) {
            
            if (self.publishRoom.userid.intValue != appDelegate.userData.userID.intValue) {
                
                _collection_Button.hidden = NO;
                _firstLineView.hidden = NO;
                if ([_publishRoom.isfollow isEqualToString:@"1"]) {
                    
                    [_collection_Button setImage:[UIImage imageNamed:@"已收藏_房源详情_图标-拷贝"] forState:UIControlStateNormal];
                    
                }else {
                    
                    [_collection_Button setImage:[UIImage imageNamed:@"收藏_房源详情_图标"] forState:UIControlStateNormal];
                    
                }
                
            }else {
                _collection_Button.hidden = YES;
                _firstLineView.hidden = YES;
            }
            
        }else {
            
            _collection_Button.hidden = YES;
            _firstLineView.hidden = YES;
            
        }
        

    }
}



#pragma mark --------事件处理----------
/**
 *  聊天
 *
 *  @param sender
 */
- (IBAction)btn_CallPhone:(UIButton *)sender {
    AppDelegate *appDelegate = GetAppDelegates;
    
    if (![XYString isBlankString:self.publishRoom.userid]) {

        if (self.publishRoom.userid.intValue != appDelegate.userData.userID.intValue) {
            ChatViewController *chatC =[[ChatViewController alloc] initWithChatType:XMMessageChatSingle];
            chatC.navigationItem.title = @"";
            chatC.ReceiveID = self.publishRoom.userid;
            chatC.chatterThumb = @"";
            [self.navigationController pushViewController:chatC animated:YES];
        }else {
            [self showToastMsg:@"不能和自己聊天" Duration:3.0];
        }
        
    }else {
        [self showToastMsg:@"不能和自己聊天" Duration:3.0];
    }

}
/**
 *  打电话
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_ChatEvent:(UIButton *)sender {
//    SysPresenter * sysPresenter=[SysPresenter new];
    NSString * phone=self.publishRoom.linkphone;
//    [sysPresenter callMobileNum:phone superview:self.view];
    [SysPresenter callPhoneStr:phone withVC:self];
    
}
/**
 *  收藏
 *
 *  @param sender 
 */
- (IBAction)btn_Collect:(id)sender {
    
    NSLog(@"收藏");
    
    if (self.refreshDataBlock) {
        self.refreshDataBlock();
    }
    

    @WeakObj(self);
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    
    
    if ([_publishRoom.isfollow isEqualToString:@"1"]) {
        
        [YYCollectionPresent removeSerfollowWithID:_publishRoom.theID type:@"1" UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [indicator stopAnimating];
                if(resultCode == SucceedCode)
                {
                    [selfWeak showToastMsg:@"取消成功" Duration:3.0];
                    _publishRoom.isfollow = @"0";
                    [sender setImage:[UIImage imageNamed:@"收藏_房源详情_图标"] forState:UIControlStateNormal];
                    
                }else {
                    if ([data isKindOfClass:[NSString class]]) {
                        if (![XYString isBlankString:data]) {
                            [selfWeak showToastMsg:data Duration:3.0];
                            return ;
                        }
                    }
                    [selfWeak showToastMsg:@"取消失败" Duration:3.0];
                    
                }
                
            });
            
        }];
        
    }else {
        
        //0 二手信息 1 二手房产 2 二手车位
        [YYCollectionPresent addSerfollowWithID:_publishRoom.theID type:@"1" UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [indicator stopAnimating];
                if(resultCode == SucceedCode)
                {
                    [selfWeak showToastMsg:@"收藏成功" Duration:3.0];
                    _publishRoom.isfollow = @"1";
                    [sender setImage:[UIImage imageNamed:@"已收藏_房源详情_图标-拷贝"] forState:UIControlStateNormal];
                    
                }else {
                    if ([data isKindOfClass:[NSString class]]) {
                        if (![XYString isBlankString:data]) {
                            [selfWeak showToastMsg:data Duration:3.0];
                            return ;
                        }
                    }
                    [selfWeak showToastMsg:@"收藏失败" Duration:3.0];
                    
                }
                
            });
            
        }];
        
    }
    

}


@end
