//
//  SolicitingHouseVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SolicitingHouseVC.h"
#import "BMRoomPresenter.h"
#import "BMCityPresenter.h"
#import "LifeSelectListVC.h"
#import "LifeEditVC.h"
#import "RegularUtils.h"
#import "RentalAndSalesTableVC.h"

/**
 *  城市区域请求
 */
#import "AppSystemSetPresenters.h"
/**
 *  地图
 */
#import "GetAddressMapVC.h"
/**
 *  定位
 */
#import "BDMapFWPresenter.h"
@interface SolicitingHouseVC ()
{
    ///选择的区ID
    NSString * districtID;
    ///城市区
    NSMutableArray * arrayDistrict;
    
     AppDelegate * appDlt;
    ///选择价格开始
    NSString * selectStartPirce;
    ///选择价格结束
    NSString * selectEndPirce;
    ///选择的厅室
    NSString *selectRoomHall;
    /**
     *  定位功能
     */
    BDMapFWPresenter * bdmap;
    /**
     *  定位数据
     */
    LocationInfo * locationInfo;
    
    ///描述
    NSString * msh;
}

/**
 *  选择区域
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_District;
/**
 *  室
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Room;
/**
 *  厅
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Hall;
/**
 *  卫
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Toilet;
/**
 *  面积
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Area;

/**
 *  白色背景高度，用于发布求租时隐藏
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NsLay_botmHeigth;

/**
 *  顶部高度，用于发布求租时隐藏
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NSLay_HouseTypeTop;

/**
 *  户型视图高度，用于发布求租时隐藏
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NSLay_HouseType;

/**
 *  户型视图，用于发布求租时隐藏
 */
@property (weak, nonatomic) IBOutlet UIView *view_HouseType;

/**
 *  面积视图，用于发布求租时隐藏
 */
@property (weak, nonatomic) IBOutlet UIView *view_AreaView;
/**
 *  期望厅室视图，用于发布求购时隐藏
 */
@property (weak, nonatomic) IBOutlet UIView *view_Room;
/**
 *  价格标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_PriceTitle;
/**
 *  选择价格
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Price;

///选择厅室
@property (weak, nonatomic) IBOutlet UIButton *btn_RoomHall;


/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Title;
/**
 *  描述
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Describe;

/**
 *  联系人
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Contact;
/**
 *  手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_PhoneNum;

@end

@implementation SolicitingHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    
    if (appDlt.userData.cityid.intValue != 0) {
        [self getDistrictData];
    }else {
        [self getLocation];
    }
}
#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    msh=@"";
    appDlt=GetAppDelegates;
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    if (_jmpCode==0) {//求租
        self.view_HouseType.hidden=YES;
        
        self.NsLay_botmHeigth.constant = self.NsLay_botmHeigth.constant - self.NSLay_HouseType.constant - self.NSLay_HouseTypeTop.constant;
        
        self.NSLay_HouseType.constant=0;
        self.NSLay_HouseTypeTop.constant=0;
        self.view_AreaView.hidden=YES;
    }
    else if (_jmpCode==1)//求购
    {
        self.view_Room.hidden=YES;
    }
//    selectStartPirce=@"";
//    selectEndPirce=@"";
//    selectRoomHall=@"";
    
    arrayDistrict=[NSMutableArray new];
    [self.btn_District setTitle:appDlt.userData.countyname forState:UIControlStateNormal];
    districtID=appDlt.userData.countyid;
    self.TF_PhoneNum.text=appDlt.userData.phone;
    
    ///修改数据赋值
    if(self.changeCdoe==1)
    {

        [self.btn_District setTitle:self.room.countyname forState:UIControlStateNormal];
        districtID=self.room.countyid;
        
 
        self.TF_Title.text=self.room.title;
        msh=self.room.descriptionString;
        [self.btn_Describe setTitle:self.room.descriptionString forState:UIControlStateNormal];
        if(msh==nil||msh.length==0)
        {
            [self.btn_Describe setTitle:@"10字以上" forState:UIControlStateNormal];
        }
        
        self.TF_Contact.text=self.room.linkman;
        self.TF_PhoneNum.text=self.room.linkphone;
        
        selectStartPirce=self.room.moneybegin;
        selectEndPirce=self.room.moneyend;
        
        if(self.jmpCode==1)//求购
        {

            if (![XYString isBlankString:self.room.bedroom]) {
                if (self.room.bedroom.intValue == -1) {
                    self.TF_Room.text = @"";
                }else {
                    self.TF_Room.text = [NSString stringWithFormat:@"%@",self.room.bedroom];
                }
            }else {
                self.TF_Room.text = @"";
            }
            
            if (![XYString isBlankString:self.room.livingroom]) {
                if (self.room.livingroom.intValue == -1) {
                    self.TF_Hall.text = @"";
                }else {
                    self.TF_Hall.text = [NSString stringWithFormat:@"%@",self.room.livingroom];
                }
            }else {
                self.TF_Hall.text = @"";
            }
            
            if (![XYString isBlankString:self.room.toilef]) {
                if (self.room.toilef.intValue == -1) {
                    self.TF_Toilet.text = @"";
                }else {
                    self.TF_Toilet.text = [NSString stringWithFormat:@"%@",self.room.toilef];
                }
            }else {
                self.TF_Toilet.text = @"";
            }
            
            if (![XYString isBlankString:self.room.area]) {
                if (self.room.area.intValue == 0) {
                    self.TF_Area.text = @"";
                }else {
                    self.TF_Area.text = [NSString stringWithFormat:@"%@",self.room.area];
                }
            }else {
                self.TF_Area.text = @"";
            }
//            self.TF_Room.text=(self.room.bedroom==nil?@"":self.room.bedroom);
//            self.TF_Hall.text=(self.room.livingroom==nil?@"":self.room.livingroom);
//            self.TF_Toilet.text=(self.room.toilef==nil?@"":self.room.toilef);
//            self.TF_Area.text=(self.room.area==nil?@"":self.room.area);
            
            //设置价格
            if(selectEndPirce!=nil&&selectStartPirce!=nil)
            {
                if ([selectEndPirce integerValue]==0 && [selectStartPirce integerValue]==0) {

                }else {
                    if([selectEndPirce integerValue]==0)
                    {
                        [self.btn_Price setTitle:@"500万元以上" forState:UIControlStateNormal];
                    }
                    else if([selectStartPirce integerValue]==0)
                    {
                        [self.btn_Price setTitle:@"50万元以下" forState:UIControlStateNormal];
                    }
                    else if([selectEndPirce integerValue]>0&&[selectStartPirce integerValue]>0)
                    {
                        [self.btn_Price setTitle:[NSString stringWithFormat:@"%ld-%ld万元",[selectStartPirce integerValue],[selectEndPirce integerValue]] forState:UIControlStateNormal];
                    }
                }
                

            }

        }
        else
        {
            NSArray * array=@[@"整租一室", @"整租两室", @"整租三室", @"整租四室及以上", @"单间合租"];
            NSInteger index=0;
            selectRoomHall=self.room.bedroom;
            if(selectRoomHall!=nil)
            {
                //则 1 2 3 4 99 分别表示 整租一室，整租两室，整租三室，整租四室及以上，单间合租
                if([selectRoomHall integerValue]==99)
                {
                    [self.btn_RoomHall setTitle:[array lastObject] forState:UIControlStateNormal];
                }
                else
                {
                    if (self.room.bedroom.intValue != -1) {
                        if([self.room.bedroom integerValue]-1>0)
                        {
                            index=[self.room.bedroom integerValue]-1;
                        }
                        [self.btn_RoomHall setTitle:[array objectAtIndex:index] forState:UIControlStateNormal];
                    }
                    
                }
            }
            //设置价格
            if(selectEndPirce!=nil&&selectStartPirce!=nil)
            {
                if ([selectEndPirce integerValue]==0 && [selectStartPirce integerValue]==0) {

                }else {
                    if([selectEndPirce integerValue]==0)
                    {
                        [self.btn_Price setTitle:@"5000元以上/月" forState:UIControlStateNormal];
                    }
                    else if([selectStartPirce integerValue]==0)
                    {
                        [self.btn_Price setTitle:@"500元以下/月" forState:UIControlStateNormal];
                    }
                    else if([selectEndPirce integerValue]>0&&[selectStartPirce integerValue]>0)
                    {
                        [self.btn_Price setTitle:[NSString stringWithFormat:@"%ld-%ld元/月",[selectStartPirce integerValue],[selectEndPirce integerValue]] forState:UIControlStateNormal];
                    }
                }
                

            }
            
        }
        
    }

    
    
}





#pragma mark ----------事件处理--------------

///选择市区
- (IBAction)btn_DistrictEvent:(UIButton *)sender {
    if(arrayDistrict==nil)
    {
        return;
    }
    LifeSelectListVC * selectListVC= [self.storyboard instantiateViewControllerWithIdentifier:@"LifeSelectListVC"];
    selectListVC.listData=arrayDistrict;
    NSInteger selectRow=-1;
    NSDictionary * dic;
    for(int i=0;i<arrayDistrict.count;i++)
    {
        dic=[arrayDistrict objectAtIndex:i];
        if([[dic objectForKey:@"id"] integerValue]==[districtID integerValue])
        {
            selectRow=i;
            break;
        }
        
    }
    selectListVC.indexSelected=selectRow;
    selectListVC.title=@"选择区域";
    //列表视图
    selectListVC.cellViewBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        UITableViewCell *cell=(UITableViewCell *)view;
        NSDictionary *dic=(NSDictionary *)data;
        cell.textLabel.text=[dic objectForKey:@"name"];
    };
    //事件
    selectListVC.cellEventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        NSDictionary *dic=(NSDictionary *)data;
        [self.btn_District setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        districtID=[dic objectForKey:@"id"];
    };
    [self.navigationController pushViewController:selectListVC animated:YES];
}

///室输入改变
- (IBAction)TFRoomChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>1)
        {
            sender.text=[sender.text substringToIndex:1];
        }
    }
}
///厅输入改变
- (IBAction)TFHallChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>1)
        {
            sender.text=[sender.text substringToIndex:1];
        }
    }
}

///卫输入改变
- (IBAction)TFToiletChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>1)
        {
            sender.text=[sender.text substringToIndex:1];
        }
    }
}
///选择厅室
- (IBAction)btnSelectRoomEvent:(UIButton *)sender {
    
    NSArray * array=@[@"整租一室", @"整租两室", @"整租三室", @"整租四室及以上", @"单间合租"];
    LifeSelectListVC * selectListVC= [self.storyboard instantiateViewControllerWithIdentifier:@"LifeSelectListVC"];
    if(!selectListVC.listData)
    {
        selectListVC.listData=[NSMutableArray new];
    }
    [selectListVC.listData addObjectsFromArray:array];
    
    NSInteger select=-1;
    for(int i=0;i<array.count;i++)
    {
        if([[array objectAtIndex:i] isEqualToString:self.btn_RoomHall.titleLabel.text])
        {
            select=i;
            break;
        }
    }
    selectListVC.indexSelected=select;
    selectListVC.title=@"选择厅室";
    //列表视图
    selectListVC.cellViewBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        UITableViewCell *cell=(UITableViewCell *)view;
        NSString *dic=(NSString *)data;
        cell.textLabel.text=dic;
    };
    //事件
    selectListVC.cellEventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        NSString *dic=(NSString *)data;
        [self.btn_RoomHall setTitle:dic forState:UIControlStateNormal];
        //则 1 2 3 4 99 分别表示 整租一室，整租两室，整租三室，整租四室及以上，单间合租
        if(index.row==4)
        {
            selectRoomHall=@"99";
        }
        else
        {
            selectRoomHall=[NSString stringWithFormat:@"%ld",(index.row+1)];
        }
        
    };
    [self.navigationController pushViewController:selectListVC animated:YES];

}


///选择价格
- (IBAction)btnPriceEvent:(UIButton *)sender {
    NSArray * array;
    if(self.jmpCode==0)
    {
        array=@[@"500元以下/月",@"500-1000元/月",@"1000-1500元/月",@"1500-2000元/月",@"2000-3000元/月",@"3000-5000元/月",@"5000元以上/月"];
    }
    else
    {
        array=@[@"50万元以下", @"50-100万元", @"100-150万元",
               @"150-200万元", @"200-300万元", @"300-500万元", @"500万元以上"];
    }
    
    LifeSelectListVC * selectListVC= [self.storyboard instantiateViewControllerWithIdentifier:@"LifeSelectListVC"];
    if(!selectListVC.listData)
    {
        selectListVC.listData=[NSMutableArray new];
    }
    [selectListVC.listData addObjectsFromArray:array];
    NSInteger select=-1;
    for(int i=0;i<array.count;i++)
    {
        if([[array objectAtIndex:i] isEqualToString:self.btn_Price.titleLabel.text])
        {
            select=i;
            break;
        }
    }
    selectListVC.indexSelected=select;
    selectListVC.title=@"选择金额";
    //列表视图
    selectListVC.cellViewBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        UITableViewCell *cell=(UITableViewCell *)view;
        NSString *dic=(NSString *)data;
        cell.textLabel.text=dic;
    };
    //事件
    selectListVC.cellEventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        NSString *dic=(NSString *)data;
        [self.btn_Price setTitle:dic forState:UIControlStateNormal];
        if(self.jmpCode==0)//求租
        {
            if(index.row==0)
            {
                selectStartPirce=@"0";
                selectEndPirce=@"500";
            }
            else if (index.row==(array.count-1))
            {
                selectStartPirce=@"5000";
                selectEndPirce=@"0";
            }
            else
            {
                NSString *tmp=[dic stringByReplacingOccurrencesOfString:@"元/月" withString:@""];
                NSArray *ar=[tmp componentsSeparatedByString:@"-"];
                selectStartPirce=[ar objectAtIndex:0];
                selectEndPirce=[ar objectAtIndex:1];
            }
        }
        else if (_jmpCode==1)//求购
        {
            if(index.row==0)
            {
                selectStartPirce=@"0";
                selectEndPirce=@"50";
            }
            else if (index.row==(array.count-1))
            {
                selectStartPirce=@"500";
                selectEndPirce=@"0";
            }
            else
            {
                NSString *tmp=[dic stringByReplacingOccurrencesOfString:@"万元" withString:@""];
                NSArray *ar=[tmp componentsSeparatedByString:@"-"];
                selectStartPirce=[ar objectAtIndex:0];
                selectEndPirce=[ar objectAtIndex:1];
            }

        }
        
        
    };
    [self.navigationController pushViewController:selectListVC animated:YES];

}

///进入描述
- (IBAction)btn_DescribeEvent:(UIButton *)sender {
    LifeEditVC * editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LifeEditVC"];
    editVC.content      = self.btn_Describe.titleLabel.text;
    editVC.tishi        = self.btn_Describe.titleLabel.text;
    editVC.minLenght    = 10;
    editVC.maxLenght    = 500;
    editVC.jmpCode      = self.jmpCode;
    editVC.viewBlock    = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
    {
        [self.btn_Describe setTitle:(NSString *)data forState:UIControlStateNormal];
        msh=(NSString *)data;
    };
    [self.navigationController pushViewController:editVC animated:YES];

}
///名字输入变化
- (IBAction)TF_ContactChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>4)
        {
            sender.text=[sender.text substringToIndex:4];
        }
    }
}
///手机号输入变化
- (IBAction)TFPhoneNumChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>11)
        {
            sender.text=[sender.text substringToIndex:11];
        }
    }
}
///标题输入变化
- (IBAction)TFTitleChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>20)
        {
            sender.text=[sender.text substringToIndex:20];
        }
    }

}
///面积输入变化
- (IBAction)TFAreaChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>6)
        {
            sender.text=[sender.text substringToIndex:6];
        }
    }

}

/**
 *  保存事件
 *
 *  @param sender sender description
 */
- (IBAction)btn_SaveEvent:(UIButton *)sender {
    if(self.changeCdoe==1)
    {
        [self sumbitChangeData:@"1"];
        return;
    }
    [self sumbitData:@"1"];
}
/**
 *  发布事件
 *
 *  @param sender sender description
 */
- (IBAction)btn_ReleaseHouse:(UIButton *)sender {
    if(self.changeCdoe==1)
    {
        [self sumbitChangeData:@"0"];
        return;
    }

    [self sumbitData:@"0"];
    
}
#pragma mark -----------网络------------
/**
 sertype	信息类型：2 求租 3 求购
 countyid	区域id
 title	标题
 description	描述
 bedroom	卧室数
 livingroom	客厅数
 area	面积  求租没有则传递0
 moneybegin	金额区间开始 求购求组使用
 moneyend	金额区间结束 求购求租使用
 linkman	联系人
 linkphone	联系电话
 flag	0 已发布 1 已保存
 */
-(void)sumbitData:(NSString *)flag
{
    NSDictionary * dic;
    if(self.jmpCode==0)//求租
    {
        if([flag isEqualToString:@"0"])
        {
            
            if(self.TF_Title.text.length==0)
            {
                [self showToastMsg:@"您还没有填写标题" Duration:5.0];
                return;
            }
            if(self.TF_PhoneNum.text.length==0)
            {
                [self showToastMsg:@"您还没有填写手机号" Duration:5.0];
                return;
            }
            if(selectStartPirce==nil||selectEndPirce==nil)
            {
                [self showToastMsg:@"您还没有选价格" Duration:5.0];
                return;
            }
            if(selectRoomHall==nil)
            {
                [self showToastMsg:@"您还没有选厅室" Duration:5.0];
                return;
            }
            if(self.TF_Contact.text.length==0)
            {
                [self showToastMsg:@"您还没有填写姓名" Duration:5.0];
                return;
            }
            if(self.TF_Title.text.length<4)
            {
                [self showToastMsg:@"标题不能少于4个字" Duration:5.0];
                return;
            }
            if(self.TF_Contact.text.length<2)
            {
                [self showToastMsg:@"姓名不能少于2个字" Duration:5.0];
                return;
            }
            
            if(![RegularUtils isPhoneNum:self.TF_PhoneNum.text])
            {
                [self showToastMsg:@"手机号格式错误" Duration:5.0];
                return;
            }
            
        }
        else
        {
            if(selectStartPirce==nil||selectEndPirce==nil)
            {
                selectStartPirce=@"";
                selectEndPirce=@"";
            }
            if(selectRoomHall==nil)
            {
                selectRoomHall=@"";
            }

        }
        dic=@{@"sertype":@"2",
                             @"countyid":districtID,
                             @"title":self.TF_Title.text,
                             @"description":msh,
                             @"bedroom":selectRoomHall,
                             @"livingroom":@"",
                             @"toilef":@"",
                             @"area":@"",
                             @"moneybegin":selectStartPirce,
                             @"moneyend":selectEndPirce,
                             @"linkman":self.TF_Contact.text,
                             @"linkphone":self.TF_PhoneNum.text,
                             @"flag":flag};
 
    }
    else if (self.jmpCode==1)//求购
    {
        
        if([flag isEqualToString:@"0"])
        {
            
            
            if(self.TF_Room.text.length==0)
            {
                [self showToastMsg:@"您还没有填写室" Duration:5.0];
                return;
            }
            if(self.TF_Hall.text.length==0)
            {
                [self showToastMsg:@"您还没有填写厅" Duration:5.0];
                return;
            }
            if(self.TF_Toilet.text.length==0)
            {
                [self showToastMsg:@"您还没有填写卫" Duration:5.0];
                return;
            }
            if(self.TF_Area.text.length==0)
            {
                [self showToastMsg:@"您还没有填写面积" Duration:5.0];
                return;
            }
            if(selectStartPirce==nil||selectEndPirce==nil)
            {
                [self showToastMsg:@"您还没有选价格" Duration:5.0];
                return;
            }
            if(self.TF_Title.text.length==0)
            {
                [self showToastMsg:@"您还没有填写标题" Duration:5.0];
                return;
            }
            if(self.TF_Contact.text.length==0)
            {
                [self showToastMsg:@"您还没有填写联系人" Duration:5.0];
                return;
            }
            if(self.TF_PhoneNum.text.length==0)
            {
                [self showToastMsg:@"您还没有填写手机号" Duration:5.0];
                return;
            }
            
            if([self.TF_Room.text hasPrefix:@"0"])
            {
                [self showToastMsg:@"室不能为0" Duration:5.0];
                return;
            }
            if([self.TF_Hall.text hasPrefix:@"0"])
            {
                [self showToastMsg:@"厅不能为0" Duration:5.0];
                return;
            }
            if([self.TF_Toilet.text hasPrefix:@"0"])
            {
                [self showToastMsg:@"卫不能为0" Duration:5.0];
                return;
            }
            if([self.TF_Area.text hasPrefix:@"0"])
            {
                [self showToastMsg:@"面积不能为0" Duration:5.0];
                return;
            }
            
            if(self.TF_Title.text.length<4)
            {
                [self showToastMsg:@"标题不能少于4个字" Duration:5.0];
                return;
            }
            if(self.TF_Contact.text.length<2)
            {
                [self showToastMsg:@"联系人不能少于2个字" Duration:5.0];
                return;
            }
            
            if(![RegularUtils isPhoneNum:self.TF_PhoneNum.text])
            {
                [self showToastMsg:@"手机号格式错误" Duration:5.0];
                return;
            }
            

        }
        else
        {
            if(selectStartPirce==nil||selectEndPirce==nil)
            {
                selectStartPirce=@"";
                selectEndPirce=@"";
            }
            if(selectRoomHall==nil)
            {
                selectRoomHall=@"";
            }
        }
        
        dic=@{@"sertype":@"3",
              @"countyid":districtID,
              @"title":self.TF_Title.text,
              @"description":msh,
              @"bedroom":self.TF_Room.text,
              @"livingroom":self.TF_Hall.text,
              @"toilef":self.TF_Toilet.text,
              @"area":self.TF_Area.text,
              @"moneybegin":selectStartPirce,
              @"moneyend":selectEndPirce,
              @"linkman":self.TF_Contact.text,
              @"linkphone":self.TF_PhoneNum.text,
              @"flag":flag};
    }
       [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];

    [BMRoomPresenter addResidenceWant:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                [self showToastMsg:@"提交成功" Duration:5.0];
                if(self.changeCdoe==1)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    if([flag isEqualToString:@"0"])//发布
                    {
                        RentalAndSalesTableVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RentalAndSalesTableVC"];
                        htVc.jmpCode=_jmpCode;
                        htVc.isFromeRelease=YES;
                        htVc.title=_jmpCode==0?@"求租":@"求购";
                        [self.navigationController pushViewController:htVc animated:YES];
                        
                    }
                    else//保存
                    {
                        //我发布的房源
//                        THMyPublishHouseListViewController *houseVC = [[THMyPublishHouseListViewController alloc]init];
//                        houseVC.isFromeRelease=YES;
//                        houseVC.publishType = 0;
//                        [self.navigationController pushViewController:houseVC animated:YES];
                    }
                    
                }


            }
            else
            {
                [self showToastMsg:data Duration:5.0];
                
            }
            
        });
    } withInfo:dic];

}
/**
 id	记录id
 countyid	区域id
 title	标题
 description	描述
 bedroom	卧室数
 livingroom	客厅数 则 1 2 3 4 99 分别表示 整租一室，整租两室，整租三室，整租四室及以上，单间合租
 area	面积
 moneybegin	金额区间开始 求购求组使用
 moneyend	金额区间结束 求购求租使用
 linkman	联系人
 linkphone	联系电话
 flag	0 已发布 1 已保存
 */
-(void)sumbitChangeData:(NSString *)flag
{
    NSDictionary * dic;
    if(self.jmpCode==0)//求租
    {
        if([flag isEqualToString:@"0"])
        {
            
            if(self.TF_Title.text.length==0)
            {
                [self showToastMsg:@"您还没有填写标题" Duration:5.0];
                return;
            }
            if(self.TF_PhoneNum.text.length==0)
            {
                [self showToastMsg:@"您还没有填写手机号" Duration:5.0];
                return;
            }
            if(selectStartPirce==nil||selectEndPirce==nil)
            {
                [self showToastMsg:@"您还没有选价格" Duration:5.0];
                return;
            }
            if(selectRoomHall==nil)
            {
                [self showToastMsg:@"您还没有选厅室" Duration:5.0];
                return;
            }
            if(self.TF_Contact.text.length==0)
            {
                [self showToastMsg:@"您还没有填写联系人" Duration:5.0];
                return;
            }
            if(self.TF_Title.text.length<4)
            {
                [self showToastMsg:@"标题不能少于4个字" Duration:5.0];
                return;
            }
            if(self.TF_Contact.text.length<2)
            {
                [self showToastMsg:@"联系人不能少于2个字" Duration:5.0];
                return;
            }
            
            if(![RegularUtils isPhoneNum:self.TF_PhoneNum.text])
            {
                [self showToastMsg:@"手机号格式错误" Duration:5.0];
                return;
            }
            
        }
        else
        {
            if(selectStartPirce==nil||selectEndPirce==nil)
            {
                selectStartPirce=@"";
                selectEndPirce=@"";
            }
            if(selectRoomHall==nil)
            {
                selectRoomHall=@"";
            }
        }
        dic=@{@"id":self.room.theID,
              @"countyid":districtID,
              @"title":self.TF_Title.text,
              @"description":msh,
              @"bedroom":selectRoomHall,
              @"livingroom":@"",
              @"toilef":@"",
              @"area":@"",
              @"moneybegin":selectStartPirce,
              @"moneyend":selectEndPirce,
              @"linkman":self.TF_Contact.text,
              @"linkphone":self.TF_PhoneNum.text,
              @"flag":flag};
        
    }
    else if (self.jmpCode==1)//求购
    {
        
        if([flag isEqualToString:@"0"])
        {
            
            
            if(self.TF_Room.text.length==0)
            {
                [self showToastMsg:@"您还没有填写室" Duration:5.0];
                return;
            }
            if(self.TF_Hall.text.length==0)
            {
                [self showToastMsg:@"您还没有填写厅" Duration:5.0];
                return;
            }
            if(self.TF_Toilet.text.length==0)
            {
                [self showToastMsg:@"您还没有填写卫" Duration:5.0];
                return;
            }
            if(self.TF_Area.text.length==0)
            {
                [self showToastMsg:@"您还没有填写面积" Duration:5.0];
                return;
            }
            if(selectStartPirce==nil||selectEndPirce==nil)
            {
                [self showToastMsg:@"您还没有选价格" Duration:5.0];
                return;
            }
            if(self.TF_Title.text.length==0)
            {
                [self showToastMsg:@"您还没有填写标题" Duration:5.0];
                return;
            }
            if(self.TF_Contact.text.length==0)
            {
                [self showToastMsg:@"您还没有填写联系人" Duration:5.0];
                return;
            }
            if(self.TF_PhoneNum.text.length==0)
            {
                [self showToastMsg:@"您还没有填写手机号" Duration:5.0];
                return;
            }
            
            if([self.TF_Room.text hasPrefix:@"0"])
            {
                [self showToastMsg:@"室不能为0" Duration:5.0];
                return;
            }
            if([self.TF_Hall.text hasPrefix:@"0"])
            {
                [self showToastMsg:@"厅不能为0" Duration:5.0];
                return;
            }
            if([self.TF_Toilet.text hasPrefix:@"0"])
            {
                [self showToastMsg:@"卫不能为0" Duration:5.0];
                return;
            }
            if([self.TF_Area.text hasPrefix:@"0"])
            {
                [self showToastMsg:@"面积不能为0" Duration:5.0];
                return;
            }
            
            if(self.TF_Title.text.length<4)
            {
                [self showToastMsg:@"标题不能少于4个字" Duration:5.0];
                return;
            }
            if(self.TF_Contact.text.length<2)
            {
                [self showToastMsg:@"联系人不能少于2个字" Duration:5.0];
                return;
            }
            
            if(![RegularUtils isPhoneNum:self.TF_PhoneNum.text])
            {
                [self showToastMsg:@"手机号格式错误" Duration:5.0];
                return;
            }
            
        }
        else
        {
            if(selectStartPirce==nil||selectEndPirce==nil)
            {
                selectStartPirce=@"";
                selectEndPirce=@"";
            }
            if(selectRoomHall==nil)
            {
                selectRoomHall=@"";
            }
        }

        
        dic=@{@"id":self.room.theID,
              @"countyid":districtID,
              @"title":self.TF_Title.text,
              @"description":msh,
              @"bedroom":self.TF_Room.text,
              @"livingroom":self.TF_Hall.text,
              @"toilef":self.TF_Toilet.text,
              @"area":self.TF_Area.text,
              @"moneybegin":selectStartPirce,
              @"moneyend":selectEndPirce,
              @"linkman":self.TF_Contact.text,
              @"linkphone":self.TF_PhoneNum.text,
              @"flag":flag};
    }
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    [BMRoomPresenter changeResidenceWant:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                [self showToastMsg:@"提交成功" Duration:5.0];
                if(self.changeCdoe==1)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    if([flag isEqualToString:@"0"])//发布
                    {
                        RentalAndSalesTableVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RentalAndSalesTableVC"];
                        htVc.jmpCode=_jmpCode;
                        htVc.isFromeRelease=YES;
                        htVc.title=_jmpCode==0?@"求租":@"求购";
                        [self.navigationController pushViewController:htVc animated:YES];
                        
                    }
                    else//保存
                    {
                        //我发布的房源
//                        THMyPublishHouseListViewController *houseVC = [[THMyPublishHouseListViewController alloc]init];
//                        houseVC.isFromeRelease=YES;
//                        houseVC.publishType = 0;
//                        [self.navigationController pushViewController:houseVC animated:YES];
                    }

                }
            }
            else
            {
                [self showToastMsg:data Duration:5.0];
                
            }
            
        });
    } withInfo:dic];

}


///获取城市区域
-(void)getDistrictData
{
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [BMCityPresenter getCityCounty:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                NSArray * array=(NSArray *)data;
                [arrayDistrict removeAllObjects];
                [arrayDistrict addObjectsFromArray:array];
            }
            else
            {
                [self showToastMsg:data Duration:5.0];
                
            }
        });
    } withCityID:appDlt.userData.cityid];
}
/**
 *  定位
 */
- (void)getLocation {
    @WeakObj(self);
    
    bdmap=[BDMapFWPresenter new];

    [bdmap getLocationInfoForupDateViewsBlock:^(id  _Nullable data, ResultCode resultCode) {
        [bdmap stopLocation];
        
        if (resultCode==SucceedCode) {
            locationInfo = (LocationInfo *)data;
            
            if(appDlt.userData.cityid.intValue == 0)
            {
                [AppSystemSetPresenters getCityIDName:locationInfo.cityName UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if(resultCode==SucceedCode)
                        {
                            appDlt.userData.cityid = data;
                            [appDlt saveContext];
                            [selfWeak getDistrictData];
                        }
                        else
                        {
                            [selfWeak showToastMsg:data Duration:5.0];
                        }
                        
                    });
                    
                }];
            }
            
        }else{
            [selfWeak showToastMsg:@"定位失败,请在设置中开启定位!" Duration:5.0];
        }
    }];
    
}


@end
