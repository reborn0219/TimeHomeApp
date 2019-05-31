//
//  VisitorCompleteVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "VisitorCompleteVC.h"
#import "VisitorCompleteFooterView.h"
#import "VisitorCompleteCell.h"
#import "TableViewDataSource.h"
#import "UserTrafficPresenter.h"
#import "UserVisitor.h"
#import "ShowMapVC.h"
#import "BMKPoiInfo+AddModels.h"
#import "SharePresenter.h"
#import "DateUitls.h"

@interface VisitorCompleteVC ()<FooterEventDelegate>
{
    /**
     *  列表数据源
     */
    TableViewDataSource * dataSource;
    /**
     *  列表页脚视图
     */
    VisitorCompleteFooterView * footerView;
    ///列表数据
    NSMutableArray * listData;
    ///访客通行
    UserVisitor * userVisitor;
    NSMutableString * shareContent;
}
/**
 *  列表用于显示完成信息
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation VisitorCompleteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate markStatistics:FangKeTongXing];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":FangKeTongXing}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(userVisitor==nil)
    {
        [self getDetailData];
    }
    
}
-(void)backButtonClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    

    [self.tableView registerNib:[UINib nibWithNibName:@"VisitorCompleteCell" bundle:nil] forCellReuseIdentifier:@"VisitorCompleteCell"];
    self.tableView.allowsSelection = NO;//列表不可选择
    @WeakObj(self);
    listData=[NSMutableArray new];
    /**
     初始化列表数据源
     */
    dataSource=[[TableViewDataSource alloc]initWithItems:listData cellIdentifier:@"VisitorCompleteCell" configureCellBlock:^(id cell, id item, NSIndexPath *indexPath) {
        [selfWeak setData:item withCell:cell withIndexPath:indexPath];
    }];
    dataSource.isSection=NO;
    self.tableView.dataSource=dataSource;
    [self setExtraCellLineHidden:self.tableView];
    footerView=[VisitorCompleteFooterView instanceFooterView];
    footerView.frame=CGRectMake(0, 0, self.tableView.frame.size.width, 400);
    footerView.delegate=self;
}

#pragma mark ----------关于列表数据及协议处理--------------
/**
 *  设置隐藏列表分割线
 *
 *  @param tableView tableView description
 */
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

/**
 *  设置列表数据
 *
 *  @param data      <#data description#>
 *  @param cell      cell description
 *  @param indexPath indexPath description
 */
-(void)setData:(id) data withCell:(id) cell withIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic=(NSDictionary *)data;
    VisitorCompleteCell * vcCell=(VisitorCompleteCell *)cell;
    vcCell.img_Addr.hidden=YES;
    if(indexPath.row==0)
    {
        if([[dic objectForKey:@"title"] isEqualToString:@"访问地址 :"])
        {
           vcCell.img_Addr.hidden=NO;
        }
        vcCell.cellEventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
        {
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"BDMapViews" bundle:nil];
            ShowMapVC * showMap = [secondStoryBoard instantiateViewControllerWithIdentifier:@"ShowMapVC"];
            showMap.poiInfo=[BMKPoiInfo new];
            CLLocationCoordinate2D lcd;
            if([XYString isBlankString:userVisitor.positiony])
            {
                 AppDelegate * appDlg=GetAppDelegates;
                lcd.latitude=[appDlg.userData.lat doubleValue];
                lcd.longitude=[appDlg.userData.lng doubleValue];
            }
            else
            {
                lcd.latitude=[userVisitor.positiony doubleValue];
                lcd.longitude=[userVisitor.positionx doubleValue];
            }
            
            showMap.poiInfo.pt=lcd;
            showMap.poiInfo.address=userVisitor.residencename;
            showMap.title=@"查看地图";
            [self.navigationController pushViewController:showMap animated:YES];
        };
    }
    vcCell.lab_Title.text=[dic objectForKey:@"title"];
    
    vcCell.lab_Content.text=[dic objectForKey:@"content"];
    vcCell.lab_Content.numberOfLines=0;
}
/**
 *  设置列表高度
 *
 *  @param tableView tableView description
 *  @param indexPath indexPath description
 *
 *  @return return value description
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}



#pragma mark -------网络数据------

-(void)getDetailData
{

    [UserTrafficPresenter getUserTrafficInfoForID:self.ID  upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            AppDelegate * appDlg=GetAppDelegates;
            if(resultCode==SucceedCode)
            {
                userVisitor=(UserVisitor *)data;
                if(userVisitor!=nil)
                {
                    
                    shareContent=[NSMutableString new];
                    [shareContent appendString:@""];
                    NSMutableString * shm=[NSMutableString new];
                    [shm appendFormat:@"说明\n1. 门禁和车库权限自%@ 00:00生效，%@ 23:59失效；\n",[XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"],[DateUitls stringFromDateToStr:userVisitor.visitdate DateFormatter:@"yyyy-MM-dd"]];
                    BOOL isShm=NO;
                    if(![XYString isBlankString:userVisitor.residencename])
                    {
                        
                        [listData addObject:@{@"title":@"访问地址 :",@"content":[NSString stringWithFormat:@"%@",userVisitor.residencename]}];
                        [shm appendString:@"2. 访客需使用申请时填写的手机号登录才可拥有门禁权限。\n"];
                        [shareContent appendFormat:@"您的朋友邀您去%@小区%@",appDlg.userData.communityname,userVisitor.residencename];
                        isShm=NO;
                        
                    }
                    else
                    {
                        [listData addObject:@{@"title":@"访问地址 :",@"content":appDlg.userData.communityname}];
                        isShm=YES;
                        [shareContent appendFormat:@"您的朋友邀您去%@小区",appDlg.userData.communityname];
                    }
                    [listData addObject:@{@"title":@"到访日期 :",@"content":[DateUitls stringFromDateToStr:userVisitor.visitdate DateFormatter:@"yyyy-MM-dd"]}];
                    NSString * carnum=userVisitor.visitcard;
                    if(![XYString isBlankString:carnum])
                    {
                        [listData addObject:@{@"title":@"到访车辆 :",@"content":userVisitor.visitcard}];
                        if(isShm)
                        {
                            [shm appendString:@"2. 访客到访时您有空置车位，访客的车才可正常驶入车库。"];
                        }
                        else
                        {
                            [shm appendString:@"3. 访客到访时您有空置车位，访客的车才可正常驶入车库。"];
                        }
                        
                    }
                    NSString * power=userVisitor.power;
                    if([power integerValue]==0)
                    {
                        [listData addObject:@{@"title":@"拥有权限 :",@"content":@"小区"}];
                    }
                    else if ([power integerValue]==1)
                    {
                        [listData addObject:@{@"title":@"拥有权限 :",@"content":@"小区  单元门"}];
                    }
                    else if ([power integerValue]==2)
                    {
                        [listData addObject:@{@"title":@"拥有权限 :",@"content":@"小区  单元门  电梯"}];
                    }
                    
                    if(![XYString isBlankString:userVisitor.visitname])
                    {
                        [listData addObject:@{@"title":@"访客姓名 :",@"content":userVisitor.visitname}];
                    }
                    if(![XYString isBlankString:userVisitor.visitphone])
                    {
                       [listData addObject:@{@"title":@"访客手机 :",@"content":userVisitor.visitphone}];
                    }
                    
                    
                    
                    
                    footerView.lab_Description.text=shm;
                    // 调整行间距
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:footerView.lab_Description.text];
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    [paragraphStyle setLineSpacing:6];
                    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [footerView.lab_Description.text length])];
                    footerView.lab_Description.attributedText = attributedString;
                    [self.tableView reloadData];
                    [self.tableView setTableFooterView:footerView];
                }
                else
                {
                   [self showToastMsg:@"获取数据异常" Duration:5.0];
                }
                
            }
            else
            {
                [self showToastMsg:data Duration:5.0];
            }
            
        });

    }];
}
///分享
-(void)btnEvent
{
    //分享应用
    ShareContentModel * SCML = [[ShareContentModel alloc]init];
    SCML.shareTitle = @"平安社区";
    SCML.shareImg=SHARE_LOGO_IMAGE;
    SCML.shareContext = shareContent;
    SCML.shareUrl=userVisitor.gotourl;
    SCML.shareSuperView = self.view;
    SCML.type=3;
    SCML.shareList=@[@(SSDKPlatformTypeQQ),
                     @(SSDKPlatformSubTypeQQFriend),
                     @(SSDKPlatformSubTypeWechatSession)];
    SCML.shareType = SSDKContentTypeWebPage;
//    SCML.shareType = SSDKContentTypeAuto;
    [SharePresenter creatShareSDKcontent:SCML];
    
    
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
