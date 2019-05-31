//
//  LS_VistorDetailsVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/8/21.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LS_VistorDetailsVC.h"
#import "LS_VistorDescribeCell.h"
#import "LS_UpDownLabelCell.h"
#import "UserTrafficPresenter.h"
#import "LS_VistorPhoneCell.h"
#import "LS_UpCtDownLbCell.h"
#import "SharePresenter.h"
#import "DateUitls.h"

#define header_img_h  40.0f
#define header_img_w  389.0f/114.0f*header_img_h


@implementation UpDownModel
@end

@interface LS_VistorDetailsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableString * shareContent;
    NSString * miaoshu;
    
}
@property (nonatomic, copy) NSMutableArray * cellIDArr;
@property (nonatomic, copy) NSMutableArray * upDownArr;
@property (nonatomic, copy) UITableView *table;
@property (nonatomic, copy) UIView *footView;
@property (nonatomic, copy) UserVisitor *visitorModel;
@property (nonatomic, copy) UIView * headerView;
@property (nonatomic, copy) UIView * complete_View;
@property (nonatomic, copy) UIView * cancel_View;

@end

@implementation LS_VistorDetailsVC

#pragma mark - LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    miaoshu = @"删除";
    
    [self.view addSubview:self.table];
    self.navigationItem.title = @"访客详情";
    self.table.tableHeaderView = self.headerView;
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"我的帖子_删除"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarItemClick:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [self requestVisitorDetails];

    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark --requestData
-(void)requestVisitorDetails
{
    
    @WeakObj(self);
    
    THIndicatorVCStart
    [UserTrafficPresenter getUserTrafficInfoForID:_vistorID upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            THIndicatorVCStopAnimating
            if (resultCode == SucceedCode) {
                
                [selfWeak assignmentWithModel:data];
                
            }else
            {
                [selfWeak showToastMsg:data Duration:2.5f];
                
            }
            
        });
        
    }];
    
    
}
-(void)assignmentWithModel:(UserVisitor *)UV
{
    
    _visitorModel = UV;
    self.table.tableFooterView = self.footView;
    
    
    AppDelegate * appDlg = GetAppDelegates;
    shareContent=[NSMutableString new];
    [shareContent appendString:@""];
    NSMutableString * shm=[NSMutableString new];
    [shm appendFormat:@"说明\n1. 门禁和车库权限自%@ 00:00生效，%@ 23:59失效；\n",[XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"],[DateUitls stringFromDateToStr:UV.visitdate DateFormatter:@"yyyy-MM-dd"]];
    if(![XYString isBlankString:UV.residencename])
    {
        
        [shareContent appendFormat:@"您的朋友邀您去%@小区%@",appDlg.userData.communityname,UV.residencename];
        
    }
    else
    {
        
        [shareContent appendFormat:@"您的朋友邀您去%@小区",appDlg.userData.communityname];
    }
    

    if ([_ls_type isEqualToString:@"0"]) {
        
        
        if (![XYString isBlankString:UV.visitname]) {
            
            ///完成
            self.navigationItem.title = @"申请成功";
            [self.cellIDArr addObject:@"LS_UpDownLabelCell"];
            UpDownModel * UDML = [[UpDownModel alloc]init];
            UDML.title =  @"访客姓名";
            UDML.coutent = UV.visitname;
            [self.upDownArr addObject:UDML];

            
        }
        
//        }else if(![XYString isBlankString:UV.permissions])
//        {
//            self.downLb.text = UV.permissions;
//            UV.permissions = @"";
//            self.upLb.text = @"门禁权限";
//            
//        }

        self.navigationItem.rightBarButtonItem = nil;
        [self.table setFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)-50)];
        [self.view addSubview:self.complete_View];
        
    }else if([_ls_type isEqualToString:@"1"])
    {
        ///我收到的
        [self.cellIDArr addObject:@"LS_VistorPhoneCell"];
        UpDownModel * UDML = [[UpDownModel alloc]init];
        [self.upDownArr addObject:UDML];

        if ([UV.isinvalid isEqualToString:@"0"]) {
            self.navigationItem.rightBarButtonItem = nil;
        }

    }else if([_ls_type isEqualToString:@"2"])
    {
        
        ///我发出的
        if (![XYString isBlankString:UV.visitname]) {

            [self.cellIDArr addObject:@"LS_UpDownLabelCell"];
            UpDownModel * UDML = [[UpDownModel alloc]init];
            UDML.title =  @"访客姓名";
            UDML.coutent = UV.visitname;
            [self.upDownArr addObject:UDML];
        }
        
        if ([UV.isinvalid isEqualToString:@"0"]) {
            self.navigationItem.rightBarButtonItem = nil;
            [self.table setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)-50)];
            [self.view addSubview:self.cancel_View];
            miaoshu = @"撤销";
        }
    
    }
    
    NSString * string4 = @"";
    string4 = [XYString IsNotNull:UV.visitphone];
    if (![XYString isBlankString:string4]) {
        if(![_ls_type isEqualToString:@"1"]){
            UpDownModel * UDML = [[UpDownModel alloc]init];
            UDML.title =  @"访客电话";
            UDML.coutent = UV.visitphone;
            [self.upDownArr addObject:UDML];
            [self.cellIDArr addObject:@"LS_UpDownLabelCell"];
        }
    }

    [self.cellIDArr addObject:@"LS_UpCtDownLbCell"];
    UpDownModel * UDML = [[UpDownModel alloc]init];
    [self.upDownArr addObject:UDML];
    
    NSString *string1 = @"";
    string1 = [XYString IsNotNull:UV.communityname];
    string1 = [string1 stringByAppendingFormat:@" %@",[XYString IsNotNull:UV.residencename]];
    UV.friendaddress = string1;
    
    if (![XYString isBlankString:string1]) {
        
        UpDownModel * UDML = [[UpDownModel alloc]init];
        UDML.title =  @"到访地址";
        UDML.coutent = UV.friendaddress;
        [self.upDownArr addObject:UDML];
        [self.cellIDArr addObject:@"LS_UpDownLabelCell"];
        
    }

    NSString *string2 = @"";
    string2 = [XYString IsNotNull:UV.visitcard];
    if (![XYString isBlankString:string2]) {
        
        UpDownModel * UDML = [[UpDownModel alloc]init];
        UDML.title =  @"车牌号码";
        UDML.coutent = UV.visitcard;
        [self.upDownArr addObject:UDML];
        [self.cellIDArr addObject:@"LS_UpDownLabelCell"];
    }
    
    NSString *string3 = @"";
    if (UV.power.intValue == 0) {
        string3 = @"小区门";
    }
    if (UV.power.intValue == 1) {
        string3 = @"小区门 单元门";
    }
    if (UV.power.intValue == 2) {
        string3 = @"小区门 单元门 电梯门";
    }
    UV.permissions = string3;
    if (![XYString isBlankString:string3]) {
        
        UpDownModel * UDML = [[UpDownModel alloc]init];
        UDML.title =  @"门禁权限";
        UDML.coutent = UV.permissions;
        [self.upDownArr addObject:UDML];

        [self.cellIDArr addObject:@"LS_UpDownLabelCell"];
    }


    if (![XYString isBlankString:UV.leavemsg]) {
        
        UpDownModel * UDML = [[UpDownModel alloc]init];
        [self.upDownArr addObject:UDML];
        [self.cellIDArr addObject:@"LS_VistorDescribeCell"];
        
    }
    
    [self.table reloadData];
    
}
#pragma mark --RightBarAction
-(void)rightBarItemClick:(id)sender
{
    [self cxsqButtonClick];

}
#pragma mark --分享微信
-(void)shareWeiXin:(id)sender
{
    //分享应用

    ShareContentModel * SCML = [[ShareContentModel alloc]init];
    SCML.shareTitle = @"平安社区";
    SCML.shareImg =  SHARE_LOGO_IMAGE;
    SCML.shareContext = shareContent;
    SCML.shareUrl     = _visitorModel.gotourl;
    SCML.shareSuperView = self.view;
    SCML.type=3;
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:SCML.shareContext
                                     images:SCML.shareImg
                                        url:[NSURL URLWithString:SCML.shareUrl]
                                      title:SCML.shareTitle
                                       type:SCML.shareType];
    
    [ShareSDK share:SSDKPlatformSubTypeWechatSession
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         
     }];

}
#pragma mark --撤销申请
-(void)cancelRequest:(id)sender
{
    [self cxsqButtonClick];
}
#pragma mark -- bottomView
-(UIView *)complete_View
{
    if (!_complete_View) {
        
        _complete_View = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-(44+statuBar_Height)-50, SCREEN_WIDTH,50)];
        [_complete_View setBackgroundColor:[UIColor whiteColor]];
        
        
        UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH/2,_complete_View.frame.size.height)];
        [leftView setBackgroundColor:[UIColor whiteColor]];

        UIImageView * imgV = [[UIImageView alloc]initWithFrame:CGRectMake(20, (_complete_View.frame.size.height-20)/2., 20, 20)];
        UIImage *image = [UIImage imageNamed:@"weixintubiao"];
        image = [image imageWithColor:kNewRedColor];
        [imgV setImage:image];

        UILabel * lb = [[UILabel alloc]initWithFrame:CGRectMake(50,0,168,_complete_View.frame.size.height)];
        lb.text = @"发送给您的朋友";
        lb.textAlignment = NSTextAlignmentCenter;
        lb.textColor = kNewRedColor;
        lb.font = [UIFont boldSystemFontOfSize:14.];
        [leftView addSubview:imgV];
        [leftView addSubview:lb];
        
        UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, _complete_View.frame.size.height);
        [leftBtn addTarget:self action:@selector(shareWeiXin:) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:leftBtn];
        leftBtn.layer.borderColor = kNewRedColor.CGColor;
        leftBtn.layer.borderWidth = 1.;
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, _complete_View.frame.size.height);
        rightBtn.backgroundColor = kNewRedColor;
        [rightBtn setTitle:@"邀请朋友下载APP" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.];
        [rightBtn addTarget:self action:@selector(shareToDownloadApp) forControlEvents:UIControlEventTouchUpInside];
        
        [_complete_View addSubview:leftView];
        [_complete_View addSubview:rightBtn];

        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(leftView.mas_centerY);
            make.centerX.equalTo(leftView.mas_centerX).offset(10);
            make.width.equalTo(@130);
            make.height.equalTo(@20);
            
        }];
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(leftView.mas_centerY);
            make.centerX.equalTo(leftView.mas_centerX).offset(-60);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            
        }];
        
    }
    
    return _complete_View;
}

#pragma mark - 邀请朋友下载APP

- (void)shareToDownloadApp {
    
    //分享应用
    ShareContentModel * SCML = [[ShareContentModel alloc]init];
    SCML.shareTitle          = @"平安社区";
    SCML.shareImg            = SHARE_LOGO_IMAGE;
    SCML.shareContext        = [NSString stringWithFormat:@"平安社区 你的智能管家!"];
    SCML.shareUrl            = [NSString stringWithFormat:@"%@/20170907/index.html",kH5_SEVER_URL];
    SCML.type                = 0;
    SCML.shareSuperView      = self.view;
    SCML.shareType           = SSDKContentTypeAuto;
    [SharePresenter creatShareSDKcontent:SCML];
    
}

#pragma mark -- bottomView
-(UIView *)cancel_View
{
    if (!_cancel_View) {
        
        _cancel_View = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-(44+statuBar_Height)-50, SCREEN_WIDTH,50)];
        [_cancel_View setBackgroundColor:[UIColor whiteColor]];
        
        UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.,0,SCREEN_WIDTH/2.,_cancel_View.frame.size.height)];
        [rightView setBackgroundColor:kNewRedColor];

//        UIImageView * rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20,(_cancel_View.frame.size.height-20)/2.,20,20)];
        UIImageView * rightImageView = [[UIImageView alloc]init];
        [rightImageView setImage:[UIImage imageNamed:@"weixintubiao"]];
        
//        UILabel * rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(50,0,125,_cancel_View.frame.size.height)];
        UILabel * rightLabel = [[UILabel alloc]init];
        rightLabel.text = @"发送给您的朋友";
        rightLabel.font = [UIFont boldSystemFontOfSize:14];
        
        rightLabel.textAlignment = NSTextAlignmentCenter;
        rightLabel.textColor = [UIColor whiteColor];
        
        [rightView addSubview:rightImageView];
        [rightView addSubview:rightLabel];
        
        
        UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH/2.,_cancel_View.frame.size.height)];
        leftView.backgroundColor = [UIColor whiteColor];
        
//        UIImageView * canimgV = [[UIImageView alloc]initWithFrame:CGRectMake(20,(_cancel_View.frame.size.height-20)/2.,20, 20)];
        UIImageView * canimgV = [[UIImageView alloc]init];
        [canimgV setImage:[UIImage imageNamed:@"chexiaoshenqing"]];
        
//        UILabel * canlb = [[UILabel alloc]initWithFrame:CGRectMake(60,0,130,_cancel_View.frame.size.height)];
        UILabel * canlb = [[UILabel alloc]init];
        canlb.text = @"撤销申请";
        canlb.font = [UIFont boldSystemFontOfSize:14.];
        canlb.textColor = kNewRedColor;

        canlb.textAlignment = NSTextAlignmentCenter;
        [leftView addSubview:canimgV];
        [leftView addSubview:canlb];

        
        UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, rightView.frame.size.width, rightView.frame.size.height);
        [rightBtn addTarget:self action:@selector(shareWeiXin:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 0, leftView.frame.size.width, leftView.frame.size.height);
        [leftBtn addTarget:self action:@selector(cancelRequest:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.layer.borderWidth = 1.;
        leftBtn.layer.borderColor = kNewRedColor.CGColor;
        
        [rightView addSubview:rightBtn];
        [leftView addSubview:leftBtn];
        
        [_cancel_View addSubview:leftView];
        [_cancel_View addSubview:rightView];
        
        [canlb mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(leftView.mas_centerY);
            make.centerX.equalTo(leftView.mas_centerX).offset(10);
            make.width.equalTo(@130);
            make.height.equalTo(@20);
            
        }];
        
        [canimgV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(leftView.mas_centerY);
            make.centerX.equalTo(leftView.mas_centerX).offset(-50);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            
        }];
        
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(rightView.mas_centerY);
            make.centerX.equalTo(rightView.mas_centerX).offset(10);
            make.width.equalTo(@130);
            make.height.equalTo(@20);
            
        }];
        
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(rightView.mas_centerY);
            make.centerX.equalTo(rightView.mas_centerX).offset(-60);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            
        }];

    }
    
    return _cancel_View;
}

#pragma mark --headerView
-(UIView *)headerView
{
    if (!_headerView) {
        
        if ([_ls_type isEqualToString:@"0"]) {
            
            _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,90 + 60)];
            [_headerView setBackgroundColor:[UIColor whiteColor]];

            UIView *titleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
            titleBgView.backgroundColor = UIColorFromRGB(0xF7EBB4);
            
            UILabel *title_Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40., 60)];
            
            NSString *msgStr = @"如您邀请的朋友已 安装使用 平安社区APP,则无需再通过微信发送邀请函,可直接使用摇摇通行出入您的社区。";
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:msgStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
            [attributeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xBD6025) range:NSMakeRange(0,attributeString.length)];
            [attributeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xC0480F) range:NSMakeRange(9, 4)];
            
            [attributeString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(9, 4)];
            
            title_Label.attributedText = attributeString;
            title_Label.numberOfLines = 0;
            title_Label.textAlignment = NSTextAlignmentCenter;
            
            [titleBgView addSubview:title_Label];
            [_headerView addSubview:titleBgView];

            UIImageView * headerImg = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-header_img_w)/2,60+30,header_img_w,header_img_h)];
            [headerImg setImage:[UIImage imageNamed:@"invitation"]];
            [_headerView addSubview:headerImg];
            
        }else {
            _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,80)];
            [_headerView setBackgroundColor:[UIColor whiteColor]];
            UIImageView * headerImg = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-header_img_w)/2,30,header_img_w,header_img_h)];
            [headerImg setImage:[UIImage imageNamed:@"invitation"]];
            [_headerView addSubview:headerImg];
        }
        
    }
    return _headerView;
}

#pragma mark --footView
-(UIView *)footView
{
    if (!_footView) {
        
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,200)];
        [_footView setBackgroundColor:[UIColor whiteColor]];
        UITextView * textV = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40,190)];
        textV.font = [UIFont systemFontOfSize:14.0f];
        [textV setBackgroundColor:[UIColor whiteColor]];
        textV.textColor = UIColorFromRGB(0x9A9A9A);
        [textV setEditable:NO];
        textV.scrollEnabled = NO;
        
        textV.text = [NSString stringWithFormat:@"☺温馨提示：\n\n1.门禁和车库权限自%@ 00:00生效%@ 23:59失效\n\n2.访客到访时，您有空置车位，访客的车才可正常驶入车库\n\n3.您可以邀请您的访客下载平安社区App，注册登录后，既可使用摇摇通行进入您的社区",[_visitorModel.visitdate substringToIndex:10],[_visitorModel.visitdate substringToIndex:10]];

        
        [_footView addSubview:textV];
        
    }
    return _footView;
}
#pragma mark -初始化upDownModel
-(NSMutableArray *)upDownArr
{
    if (!_upDownArr) {
        _upDownArr = [[NSMutableArray alloc]initWithCapacity:0];
        
    }
    return _upDownArr;
    
}
#pragma 初始化cellID 数组

-(NSMutableArray *)cellIDArr
{
    if (!_cellIDArr) {
        _cellIDArr = [[NSMutableArray alloc]initWithCapacity:0];
        
    }
    return _cellIDArr;
    
}

#pragma mark - 初始化Tableview
-(UITableView *)table{

    if (!_table) {
        
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height))];
        [_table setBackgroundColor:[UIColor whiteColor]];
        [_table registerNib:[UINib nibWithNibName:@"LS_VistorDescribeCell" bundle:nil] forCellReuseIdentifier:@"LS_VistorDescribeCell"];
        [_table registerNib:[UINib nibWithNibName:@"LS_UpDownLabelCell" bundle:nil] forCellReuseIdentifier:@"LS_UpDownLabelCell"];
        [_table registerNib:[UINib nibWithNibName:@"LS_VistorPhoneCell" bundle:nil] forCellReuseIdentifier:@"LS_VistorPhoneCell"];
        [_table registerNib:[UINib nibWithNibName:@"LS_UpCtDownLbCell" bundle:nil] forCellReuseIdentifier:@"LS_UpCtDownLbCell"];

        [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _table.delegate = self;
        _table.dataSource = self;
//        _table.estimatedRowHeight = UITableViewAutomaticDimension;
        
    }
    return _table;
    
}

#pragma mark - TableViewDelegate/DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * cellID = [_cellIDArr objectAtIndex:indexPath.row];
    LS_VistorBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([cellID isEqualToString:@"LS_UpDownLabelCell"]) {
        [cell assignment:[self.upDownArr objectAtIndex:indexPath.row]];
    }else
    {
        [cell assignmentWithModel:_visitorModel];

    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * cellID = [_cellIDArr objectAtIndex:indexPath.row];
    if ([cellID isEqualToString:@"LS_VistorDescribeCell"]) {
        
        return 140;
        
    }else if ([cellID isEqualToString:@"LS_UpDownLabelCell"])
    {
        return 40;
    }else if ([cellID isEqualToString:@"LS_VistorPhoneCell"])
    {
        return 120;
    }else if ([cellID isEqualToString:@"LS_UpCtDownLbCell"])
    {
        return 40;
    }
    
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
       return 0;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellIDArr.count;
}

#pragma mark -- 撤销或者删除访客通行记录

- (void)cxsqButtonClick {
    
    
    @WeakObj(self);
    
    
    CommonAlertVC *alertVC = [CommonAlertVC getInstance];
    [alertVC ShowAlert:self Title: [NSString stringWithFormat:@"%@申请",miaoshu] Msg:[NSString stringWithFormat:@"是否%@该访客通行申请",miaoshu] oneBtn:@"取消" otherBtn:@"确定"];
    
    alertVC.eventCallBack = ^(id _Nullable data,UIView *_Nullable view,NSInteger index){
        
        if (index == 1000) {
            
            [UserTrafficPresenter removeTrafficForID:_vistorID upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [indicator stopAnimating];
                    if(resultCode == SucceedCode)
                    {
                        [selfWeak showToastMsg:[NSString stringWithFormat:@"%@成功！",miaoshu] Duration:2.0];
                        [selfWeak.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        [selfWeak showToastMsg:(NSString *)data Duration:2.0];
                    }
                });
                
            }];
            
        }
        if (index == 1001) {
            //取消
        }
        
    };
    
}


@end
