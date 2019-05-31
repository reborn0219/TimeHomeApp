//
//  ParkingDetailVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ParkingDetailVC.h"
#import "SysPresenter.h"
#import "ChatViewController.h"
#import "ShowMapVC.h"
#import "DateUitls.h"

#import "YYCollectionPresent.h"

@interface ParkingDetailVC ()

/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;

/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Price;
/**
 *  是否露天
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_OpenAir;
/**
 *  是否固定
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_IsFixed;
/**
 *  日期
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Date;

/**
 *  区
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_District;
/**
 *  小区
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Biotope;
/**
 *  地址
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Addr;

/**
 *  详细描述
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Detail;
/**
 *  姓名电话
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_NamePhone;

/**
 *  地址视图，用于隐藏
 */
@property (weak, nonatomic) IBOutlet UIView *view_Addrs;

/**
 *  小区视图，用于限藏
 */
@property (weak, nonatomic) IBOutlet UIView *view_Biotope;
/**
 *  小区视图高度，用于限藏
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_BiotopeHeight;
/**
 *  地址视图高度，用于隐藏
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_AddrHeight;
/**
 *  地址信息高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_AddrInfoHeight;
/**
 *  内容高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_Content;

@property (weak, nonatomic) IBOutlet UIButton *collection_Button;

@property (weak, nonatomic) IBOutlet UIView *firstLineView;



@end

@implementation ParkingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    [self initView];
}

#pragma mark --------初始化----------
-(void)initView
{
   if(_jmpCode==1)//车位求租购
   {
       self.view_Biotope.hidden=YES;
       self.view_Addrs.hidden=YES;
       self.nsLay_Content.constant-=102;
       
       self.nsLay_AddrInfoHeight.constant=self.nsLay_AddrInfoHeight.constant-self.nsLay_BiotopeHeight.constant-self.nsLay_AddrHeight.constant-2;
       
   }
    
    _lab_Title.text = _userPublishCar.title;
    if (_userPublishCar.sertype.intValue == 0) {
        _lab_Price.text=[NSString stringWithFormat:@"%@元/月",[_userPublishCar.money stringByReplacingOccurrencesOfString:@".0" withString:@""]];
    }
    if (_userPublishCar.sertype.intValue == 1) {
        _lab_Price.text=[NSString stringWithFormat:@"%@万元",[_userPublishCar.money stringByReplacingOccurrencesOfString:@".0" withString:@""]];
    }
    if (_userPublishCar.sertype.intValue == 2) {
        if (_userPublishCar.moneybegin.intValue == 0) {
            _lab_Price.text = [NSString stringWithFormat:@"%d 元以下/月",_userPublishCar.moneyend.intValue];
        }else if (_userPublishCar.moneyend.intValue == 0) {
            _lab_Price.text = [NSString stringWithFormat:@"%d 元以上/月",_userPublishCar.moneybegin.intValue];
        }else {
            _lab_Price.text = [NSString stringWithFormat:@"%d - %d元/月",_userPublishCar.moneybegin.intValue,_userPublishCar.moneyend.intValue];
        }
    }
    if (_userPublishCar.sertype.intValue == 3) {
        if (_userPublishCar.moneybegin.intValue == 0) {
            _lab_Price.text = [NSString stringWithFormat:@"%d 万元以下",_userPublishCar.moneyend.intValue];
        }else if (_userPublishCar.moneyend.intValue == 0) {
            _lab_Price.text = [NSString stringWithFormat:@"%d 万元以上",_userPublishCar.moneybegin.intValue];
        }else {
            _lab_Price.text = [NSString stringWithFormat:@"%d - %d 万元",_userPublishCar.moneybegin.intValue,_userPublishCar.moneyend.intValue];
        }
    }

    if (_userPublishCar.underground.intValue == 0) {
        _lab_OpenAir.text = @"露天";
    }else {
        _lab_OpenAir.text = @"地下";
    }
    if (_userPublishCar.fixed.intValue == 0) {
        _lab_IsFixed.text = @"不固定";
    }else {
        _lab_IsFixed.text = @"固定";
    }
    if (![XYString isBlankString:_userPublishCar.releasedate]) {
        _lab_Date.text =[DateUitls stringFromDate:[DateUitls DateFromString: _userPublishCar.releasedate DateFormatter:@"yyyy-MM-dd HH:mm:ss"] DateFormatter:@"yyyy-MM-dd HH:mm"];;
    }
    
    if (![XYString isBlankString:_userPublishCar.countyname]) {
        _lab_District.text = _userPublishCar.countyname;
    }
    
    if (![XYString isBlankString:_userPublishCar.communityname]) {
        _lab_Biotope.text = _userPublishCar.communityname;
    }
    
    if (![XYString isBlankString:_userPublishCar.address]) {
        _lab_Addr.text = _userPublishCar.address;
    }
    
    if (![XYString isBlankString:_userPublishCar.descriptionString]) {
        _lab_Detail.text = _userPublishCar.descriptionString;
    }
    NSString *string = @"";
    if (![XYString isBlankString:_userPublishCar.linkman]) {
        string = [string stringByAppendingFormat:@"%@",_userPublishCar.linkman];
    }
    if (![XYString isBlankString:_userPublishCar.linkphone]) {
        string = [string stringByAppendingFormat:@"\n%@",_userPublishCar.linkphone];
    }
    _lab_NamePhone.text = string;
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    if (![XYString isBlankString:self.userPublishCar.userid]) {
        
        if (self.userPublishCar.userid.intValue != appDelegate.userData.userID.intValue) {
            
            _collection_Button.hidden = NO;
            _firstLineView.hidden = NO;
            if ([_userPublishCar.isfollow isEqualToString:@"1"]) {
                
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
#pragma mark --------事件处理----------
/**
 *  进入地图事件
 *
 *  @param sender
 */
- (IBAction)btn_InMap:(UIButton *)sender {
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"BDMapViews" bundle:nil];
    ShowMapVC * carMap= [secondStoryBoard instantiateViewControllerWithIdentifier:@"ShowMapVC" ];
    carMap.jumpCode=2;
    carMap.title=@"查看地图";
    BMKPoiInfo * poiInfo=[BMKPoiInfo new];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.userPublishCar.mapy doubleValue];
    coordinate.longitude = [self.userPublishCar.mapx doubleValue];
    poiInfo.pt=coordinate;
    poiInfo.address=self.userPublishCar.address;
    poiInfo.name=self.userPublishCar.communityname;
    carMap.poiInfo=poiInfo;
    [self.navigationController pushViewController:carMap animated:YES];
}
/**
 *  打电话
 *
 *  @param sender sender description
 */
- (IBAction)btn_CallPhone:(UIButton *)sender {
    
//    SysPresenter * sysPresenter=[SysPresenter new];
    NSString * phone=self.userPublishCar.linkphone;
//    [sysPresenter callMobileNum:phone superview:self.view];
    [SysPresenter callPhoneStr:phone withVC:self];
    
}

/**
 *  聊天
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_ChatEvent:(UIButton *)sender {
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    if (![XYString isBlankString:self.userPublishCar.userid]) {
        
        if (self.userPublishCar.userid.intValue != appDelegate.userData.userID.intValue) {
            
            ChatViewController *chatC =[[ChatViewController alloc] initWithChatType:XMMessageChatSingle];
            chatC.navigationItem.title = @"";
            chatC.ReceiveID = self.userPublishCar.userid;
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
    
    if ([_userPublishCar.isfollow isEqualToString:@"1"]) {
        
        [YYCollectionPresent removeSerfollowWithID:_userPublishCar.theID type:@"2" UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                if(resultCode == SucceedCode)
                {
                    [selfWeak showToastMsg:@"取消成功" Duration:3.0];
                    _userPublishCar.isfollow = @"0";
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
        [YYCollectionPresent addSerfollowWithID:_userPublishCar.theID type:@"2" UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                if(resultCode == SucceedCode)
                {
                    [selfWeak showToastMsg:@"收藏成功" Duration:3.0];
                    _userPublishCar.isfollow = @"1";
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
