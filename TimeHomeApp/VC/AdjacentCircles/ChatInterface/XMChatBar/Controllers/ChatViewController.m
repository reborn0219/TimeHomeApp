#import "ChatViewController.h"
#import "UIImageView+WebCache.h"
#import "XMSystemMessageCell.h"
#import "XMTextMessageCell.h"
#import "XMImageMessageCell.h"
#import "XMLocationMessageCell.h"
#import "XMVoiceMessageCell.h"
#import "XMChatBar.h"
#import "ChatPresenter.h"
#import "XMAVAudioPlayer.h"
#import "UITableView+FDTemplateLayoutCell.h"
#define kSelfName @"XMFraker"
#import "DataOperation.h"
#import "Gam_Chat.h"
#import "ChatPresenter.h"
#import "DateUitls.h"
#import "AppSystemSetPresenters.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
//#import "FriendInfomationVC.h"
#import "THMyInfoPresenter.h"
#import "UserInfoModel.h"
#import "PersonalDataVC.h"
#import "DateTimeUtils.h"
#import "THMySettingsVC.h"
#import "GoodsHeaderView.h"
#import "XMMImageTextMessageCell.h"
#import "WebViewVC.h"

#import "personListViewController.h"

@interface ChatViewController ()<XMMessageDelegate,XMChatBarDelegate,XMAVAudioPlayerDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSString * kSelfThumb;
    UIImageView * tempImgV;
    BOOL iSelectImg;
    dispatch_queue_t queue;
    CGRect  updateFrame;
    int page;
    CGRect  tableFrame;
    CGRect  chatBarFrame;
    NSArray * temPicArr;
    AppDelegate * appDelegate;
    Gam_Chat * tempMeg;
    BOOL islastOne;
    
    GoodsHeaderView * ghView;
    
}
@property (strong, nonatomic) UITableView    * tableView;
@property (strong, nonatomic) XMChatBar      * chatBar;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (weak, nonatomic) NSIndexPath *voicePlayingIndexPath; /**< 正在播放的列表,用来标注正在播放的语音cell,修复复用产生的状态不正确问题 */
@property (assign, nonatomic) XMMessageChatType messageChatType;
@end
@implementation ChatViewController

- (instancetype)initWithChatType:(XMMessageChatType)messageChatType{
    if (self = [super init]) {
        self.messageChatType = messageChatType;
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;


    self.hidesBottomBarWhenPushed = YES;
    [[XMAVAudioPlayer sharedInstance] stopSound];
    [[DataOperation sharedDataOperation]queryData:@"Gam_Chat" withIsRead:YES andChatID:_ReceiveID andLastObject:[self.dataArray lastObject]];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
//    if (_isGoods) {
//        ghView = [[[NSBundle mainBundle]loadNibNamed:@"GoodsHeaderView" owner:self options:nil]lastObject];
//
//        [ghView.goosImg sd_setImageWithURL:[NSURL URLWithString:_goodPicURL] placeholderImage:PLACEHOLDER_IMAGE];
//        ghView.goodsLb.text = _goodTitle;
//        
//    }
    
    
    appDelegate = GetAppDelegates;
    updateFrame=self.view.frame;
    iSelectImg=NO;
    tempImgV = [[UIImageView alloc]init];
    //self.view.backgroundColor = UIColorFromRGB(0xEBEBEB);
    self.view.backgroundColor = UIColorFromRGB(0xF1F1F1);

    [[XMAVAudioPlayer sharedInstance] setDelegate:self];
    [self.view addSubview:self.tableView];
    
 
    NSLog(@"----%f---",SCREEN_HEIGHT);
    
    if (SCREEN_HEIGHT==812.00){
        
        self.chatBar = [[XMChatBar alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-64-34-kMinHeight,SCREEN_WIDTH, kMinHeight)];

    }else
    {
        self.chatBar = [[XMChatBar alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-64-kMinHeight,SCREEN_WIDTH, kMinHeight)];

        
    }
    
    
    //chatBarFrame = self.chatBar.frame;
    self.chatBar.delegate = self;
    [self.view addSubview:self.chatBar];
    
    //kSelfThumb = @"罗小黑";
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:10];
    __weak ChatViewController * weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];


    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
        make.top.equalTo(self.view.mas_top).offset(-8);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);

    }];
}
#pragma mark - 极光消息推送
-(void)subReceivePushMessages:(NSNotification *)aNotification
{
    NSDictionary *dic=(NSDictionary *)aNotification.object;
    NSLog(@"新消息---%@===%@",dic,_ReceiveID);
    if ([[[dic objectForKey:@"map"] objectForKey:@"userid"] isEqualToString:_ReceiveID]) {
        
        NSArray  * newArr = [[DataOperation sharedDataOperation]queryData:@"Gam_Chat" withCurrentPage:0 withChatID:_ReceiveID];
        
       [self.dataArray addObject: [[NSMutableArray arrayWithArray:newArr]lastObject]];
        
        
        [self.tableView reloadData];
        
        [self scrollToBottom];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    @WeakObj(self)
    [IQKeyboardManager sharedManager].enable = NO;

    [THMyInfoPresenter getOneUserInfoUserID:_ReceiveID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
       
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if(resultCode == SucceedCode)
            {
                UserInfoModel * UIML = data;
                page = 0;
                NSString * sendname;
                NSString * picurl = [[UIML.piclist firstObject]objectForKey:@"fileurl"];
                _chatterThumb = picurl;
                if ([XYString isBlankString:UIML.remarkname]) {
                    sendname =  UIML.nickname;
                }else
                {
                    sendname =  UIML.remarkname;
                }
                if([XYString isBlankString:sendname])
                {
                    self.navigationItem.title = @"邻友";

                }else
                {
                    self.navigationItem.title = sendname;

                }

                [self loadOne];
                
            }else if (resultCode == FailureCode)
            {
            
                self.navigationItem.title = _chatterName;
                [self loadOne];

            }
            
        });
        
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return ghView;
        
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (_isGoods) {
//        return  126;
//    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Gam_Chat * GC = [self.dataArray objectAtIndex:indexPath.row];
        NSLog(@"%@",GC.content);
    XMMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:[XMMessageCell cellIndetifyForMessage:GC.cellIdentifier]];
    
  
    messageCell.indexPath = indexPath;
    messageCell.backgroundColor = tableView.backgroundColor;
    messageCell.messageDelegate = self;
    
    [self configureCell:messageCell atIndex:indexPath];

    return messageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Gam_Chat * GC = self.dataArray[indexPath.row];
    
    return [tableView fd_heightForCellWithIdentifier:[XMMessageCell cellIndetifyForMessage:GC.cellIdentifier] cacheByIndexPath:indexPath configuration:^(id cell) {
        
        [self configureCell:cell atIndex:indexPath];
        
    }];
    
}

- (void)configureCell:(XMMessageCell *)cell atIndex:(NSIndexPath *)indexPath{
    Gam_Chat * GC = self.dataArray[indexPath.row];
    
    if (indexPath.row-1>=0||(indexPath.row-1)<self.dataArray.count) {
        
        Gam_Chat * beforeGC = [self.dataArray objectAtIndex:indexPath.row - 1];
        if(beforeGC)
        {
          cell.systimeShow = @([DateTimeUtils isfiveminutes:GC.systime fromLastDate:beforeGC.systime]);
        }
        
    }else
    {
        cell.systimeShow = @(YES);
    }
    
    [cell setMessage:GC];

    if (GC.ownerType.integerValue == XMMessageOwnerTypeSelf) {
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:appDelegate.userData.userpic] placeholderImage:kHeaderPlaceHolder];

    }else if(GC.ownerType.integerValue == XMMessageOwnerTypeOther) {
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:GC.headPicUrl] placeholderImage:kHeaderPlaceHolder];

    }
    
    if ([cell isKindOfClass:[XMVoiceMessageCell class]] && self.voicePlayingIndexPath && self.voicePlayingIndexPath.row == indexPath.row) {
        [(XMVoiceMessageCell *)cell startPlaying];
    }
}

#pragma mark - XMMessageDelegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.chatBar.state) {
        [self.chatBar endInputing];
    }
    self.chatBar.state = NO;

}
- (void)XMMessageBankTapped:(Gam_Chat *)message{
    NSLog(@"点击了空白区域");
    [self.chatBar endInputing];
    self.chatBar.state = NO;
}
-(void)XMImageTextMessageTapped:(Gam_Chat *)imageTextMessage
{
    [self.chatBar endInputing];
    self.chatBar.state = NO;
    NSLog(@"点击跳转房产详情");
}
- (void)XMMessageAvatarTapped:(Gam_Chat *)message{
    
    NSLog(@"点击了头像---%@",message.sendID);
    if([appDelegate.userData.userID isEqualToString:message.sendID])
    {
        THMySettingsVC *mySettingVC  = [[THMySettingsVC alloc]init];
        [mySettingVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:mySettingVC animated:YES];
        
    }else{
        
        if ([XYString isBlankString:message.sendID]) {
            return;
        }
        
        //头像点击
        personListViewController *personList = [[personListViewController alloc]init];
        [personList getuserID:message.sendID];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personList animated:YES];

    }
    
}

- (void)XMImageMessageTapped:(Gam_Chat *)imageMessage withImgView:(UIImageView *)imgV{
    
    NSLog(@"you tap imageMessage you can show imageBrowser");
    [self tapPicture:imageMessage withImgView:imgV];

}
-(void)XMMessageLongTapAction:(Gam_Chat *)message withIndex:(NSIndexPath *)index
{
    
    [[DataOperation sharedDataOperation] deleteObj:[self.dataArray objectAtIndex:index.row]];
    [self.dataArray removeObjectAtIndex:index.row];
    [self.tableView reloadData];
    
}
//!!!修复语音播放复用问题,使用voicePlayIndexPath来
- (void)XMVoiceMessageTapped:(Gam_Chat *)voiceMessage voiceStatus:(id<XMVoiceMessageStatus>)voiceStatus{

    NSIndexPath *currentIndexPath = [self.tableView indexPathForCell:(XMVoiceMessageCell *)voiceStatus];
    XMVoiceMessageCell *lastVoiceMessageCell = [self.tableView cellForRowAtIndexPath:self.voicePlayingIndexPath];
    voiceMessage.voiceUnRead = @(NO);
    [[DataOperation sharedDataOperation]save];
    if (lastVoiceMessageCell) {
        [lastVoiceMessageCell stopPlaying];
        [[XMAVAudioPlayer sharedInstance] stopSound];
    }
    if (currentIndexPath.row == self.voicePlayingIndexPath.row) {
        self.voicePlayingIndexPath = nil;
        return;
    }
    self.voicePlayingIndexPath = nil;
    [voiceStatus startPlaying];
    if (voiceMessage.voiceData) {
        [[XMAVAudioPlayer sharedInstance] playSongWithData:voiceMessage.voiceData];
    }else{
        [[XMAVAudioPlayer sharedInstance] playSongWithUrl:voiceMessage.voiceUrl];
        NSLog(@"录音文件－－－%@",voiceMessage.voiceUrl);

    }
    self.voicePlayingIndexPath = currentIndexPath;
}


#pragma mark - XMChatBarDelegate
#pragma mark - 发送文本
- (void)chatBar:(XMChatBar *)chatBar sendMessage:(NSString *)message{
    
    @WeakObj(self)

   [ChatPresenter sendChatMsg:^(id  _Nullable data, ResultCode resultCode) {
       
       dispatch_sync(dispatch_get_main_queue(), ^{

               Gam_Chat * GC = (Gam_Chat *)[[DataOperation sharedDataOperation]creatManagedObj:@"Gam_Chat"];
               GC.chatID = _ReceiveID;
               GC.userID = appDelegate.userData.userID;
               GC.sendID = appDelegate.userData.userID;
               GC.receiveID = _ReceiveID;

               GC.content = message;
               GC.systime = [DateUitls DateFromString:data DateFormatter:@"YYYY-MM-dd HH:mm:ss"];
               
               GC.ownerType = @(XMMessageOwnerTypeSelf);
               GC.cellIdentifier = @"XMTextMessageCell";
               GC.sendName = self.navigationItem.title;
               GC.headPicUrl = self.chatterThumb;
               GC.msgType = @(0);
               [selfWeak.dataArray addObject:GC];
               [[DataOperation sharedDataOperation]save];
               [selfWeak.tableView beginUpdates];
               [selfWeak.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
               [selfWeak.tableView endUpdates];
               [selfWeak scrollToBottom];
           
       });
       
   } withUserID:_ReceiveID andMsgType:@"0" andContent:message andResourcesID:@""];
    
}
#pragma mark - 发送语音
- (void)chatBar:(XMChatBar *)chatBar sendVoice:(NSData *)voiceData seconds:(NSTimeInterval)seconds {
    
    NSLog(@"-----%f",seconds);
    
//    voiceMessage.senderAvatarThumb = kSelfThumb;
//    voiceMessage.senderNickName = kSelfName;
//    voiceMessage.messageChatType = self.messageChatType;
    [AppSystemSetPresenters upLoadVoiceFile:voiceData UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        NSLog(@"%@",data);
        NSString * resourcesID = data;
        if(resultCode==SucceedCode)
        {
            [ChatPresenter sendChatMsg:^(id  _Nullable data, ResultCode resultCode) {
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    Gam_Chat * GC = (Gam_Chat *)[[DataOperation sharedDataOperation]creatManagedObj:@"Gam_Chat"];
                    GC.systime = [DateUitls DateFromString:data DateFormatter:@"YYYY-MM-dd HH:mm:ss"];
                    GC.ownerType = @(XMMessageOwnerTypeSelf);
                    GC.voiceData = voiceData;
                    GC.seconds = @(seconds);
                    GC.cellIdentifier = @"XMVoiceMessageCell";
                    GC.sendName = self.navigationItem.title;
                    GC.headPicUrl = self.chatterThumb;
                    GC.chatID = _ReceiveID;
                    GC.content = @"[语音]";
                    GC.msgType = @(2);
                    GC.userID = appDelegate.userData.userID;
                    GC.sendID = appDelegate.userData.userID;
                    GC.receiveID = _ReceiveID;

                    [self.dataArray addObject:GC];
                    [[DataOperation sharedDataOperation]save];
                    
                    [self.tableView beginUpdates];
                    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
                    [self.tableView endUpdates];
                    [self scrollToBottom];
                    
                });
                
            } withUserID:_ReceiveID andMsgType:@"2" andContent:[NSString stringWithFormat:@"%d",(int)seconds] andResourcesID:resourcesID];
            
        }else
        {
            
        }

        
    }];
    
}
-(void)tapPicture:(Gam_Chat *)tapView withImgView:(UIImageView *)imgV
{
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:0];
    //        XMImageMessage * PML = [self.dataArray objectAtIndex:index.row];
    NSString *url;
    MJPhoto *photo = [[MJPhoto alloc] init];
    url = tapView.contentPicUrl;
    photo.placeholder = imgV.image;
    photo.url = [NSURL URLWithString:url];
    photo.srcImageView = imgV; // 来源于哪个UIImageView
    [photos addObject:photo];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
}
#pragma mark - 发送图片
- (void)chatBar:(XMChatBar *)chatBar sendPictures:(NSArray *)pictures{
   
        [self scrollToBottom];
        @WeakObj(self)
        UIImage * newImg = pictures[0];
        [AppSystemSetPresenters upLoadPicFile:newImg UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            NSLog(@"%@",data);
            NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
            
            NSString * resourcesID = picID;
                if(resultCode==SucceedCode)
                {
                    [ChatPresenter sendChatMsg:^(id  _Nullable data, ResultCode resultCode) {
                        
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            
                            Gam_Chat * GC = (Gam_Chat *)[[DataOperation sharedDataOperation]creatManagedObj:@"Gam_Chat"];
                            GC.chatID = _ReceiveID;
                            GC.content = @"10";
                            GC.systime = [DateUitls DateFromString:data DateFormatter:@"YYYY-MM-dd HH:mm:ss"];
                            GC.contentPicData = UIImageJPEGRepresentation(newImg, 1);
                            GC.ownerType = @(XMMessageOwnerTypeSelf);
                            GC.cellIdentifier = @"XMImageMessageCell";
                            GC.sendName = self.navigationItem.title;
                            GC.headPicUrl = self.chatterThumb;
                            GC.content = @"[图片]";
                            GC.sendID = appDelegate.userData.userID;
                            GC.receiveID = _ReceiveID;
                            GC.msgType = @(1);
                            GC.userID = appDelegate.userData.userID;
                            [selfWeak.dataArray addObject:GC];
                            [[DataOperation sharedDataOperation]save];
                            [selfWeak.tableView beginUpdates];
                            [selfWeak.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
                            [selfWeak.tableView endUpdates];
                            [selfWeak scrollToBottom];
                            
                        });
                        
                    } withUserID:_ReceiveID andMsgType:@"1" andContent:@"[图片]" andResourcesID:resourcesID];
                    
                }else
                {
            
                }
                
           
        }];
}
#pragma mark - 发送图文消息

-(NSDictionary *)toDealroomData:(NSDictionary *)contentDic
{
    NSString *  livingroom = [contentDic objectForKey:@"livingroom"];//客厅
    NSString *  allfloornum = [contentDic objectForKey:@"allfloornum"];//总楼层
    NSString *  bedroom = [contentDic objectForKey:@"bedroom"];//卧室
    NSString *  floornum = [contentDic objectForKey:@"floornum"];//楼层
    NSString *  money = [contentDic objectForKey:@"money"];//金额
    NSString *  price = [contentDic objectForKey:@"price"];//单价
    NSString *  area = [contentDic objectForKey:@"area"];//面积
    NSString *  toilef = [contentDic objectForKey:@"toilef"];//卫数
    ///车位信息
    NSString *  decorattype = [contentDic objectForKey:@"decorattype"];//装修
    NSString *  underground = [contentDic objectForKey:@"underground"];//地上地下
    NSString *  fixed = [contentDic objectForKey:@"fixed"];//固定与否
    NSString * housetype = [NSString stringWithFormat:@"%@",[contentDic objectForKey:@"housetype"]];//房产贴类型：10 房产出售 11 房产出租30 车位出售 31 车位出租
    
    NSString * describe;//帖子描述
    NSDictionary * chatGoodDic;//传递参数
    NSDictionary * tempDic;//图片
    NSArray * picList = [contentDic objectForKey:@"piclist"];
    
   
    switch (housetype.integerValue) {
        case 10:
        {
            describe = [NSString stringWithFormat:@"户型 | %@室%@厅%@卫\n面积 | %@㎡\n楼层 | %@/%@层\n单价 | %@ 元/㎡",bedroom,livingroom,toilef,area,floornum,allfloornum,price];
            //图片赋值
            if (picList.count) {
                tempDic = [picList firstObject];
            }else
            {
                tempDic = @{@"picid":House_sell_id,@"picurl":House_sell_url};
            }
        }
            break;
        case 11:
        {
            if(decorattype.integerValue == 1)
            {
                decorattype = @"拎包入住";
            }else{
                decorattype = @"简装装修";
            }
            describe = [NSString stringWithFormat:@"装修 | %@\n面积 | %@㎡\n楼层 | %@/%@层\n单价 | %@ 元/㎡",decorattype,area,floornum,allfloornum,price];
            //图片赋值
            if (picList.count) {
                tempDic = [picList firstObject];
            }else
            {
                tempDic = @{@"picid":House_rent_id,@"picurl":House_rent_url};
            }

        }
            break;
        case 30:
        {
            if(fixed.integerValue==0){
                fixed = @"非固定";
            }else
            {
                fixed = @"固定";
            }
            if (underground.integerValue==0) {
                underground = @"地上";
            }else
            {
                underground = @"地下";

            }
            describe = [NSString stringWithFormat:@"出售价格：\n       %@元\n车位类型：\n       %@、%@",price,underground,fixed];
            //图片赋值
            if (picList.count) {
                tempDic = [picList firstObject];
            }else
            {
                tempDic = @{@"picid":Parking_sell_id,@"picurl":Parking_sell_url};
            }

        }
            break;
        case 31:
        {
           
            if(fixed.integerValue==0){
                fixed = @"非固定";
            }else
            {
                fixed = @"固定";
            }
            if (underground.integerValue==0) {
                underground = @"地上";
            }else
            {
                underground = @"地下";
                
            }
            describe = [NSString stringWithFormat:@"出租价格：\n       %@元/月\n车位类型：\n       %@、%@",price,underground,fixed];

            //图片赋值
            if (picList.count) {
                tempDic = [picList firstObject];
            }else
            {
                tempDic = @{@"picid":Parking_rent_id,@"picurl":Parking_rent_url};
            }

        }
            break;
        default:
            break;
    }
  
    chatGoodDic = @{@"content":describe,@"picid":tempDic[@"picid"],@"picurl":tempDic[@"picurl"],@"money":money};

    
    return chatGoodDic;
}
- (void)sendPicturesText:(id)parame{
    
    [self scrollToBottom];
    _isGoods = NO;
    @WeakObj(self)
    NSDictionary * tempDic = [self toDealroomData:_goodsDic];
    
    if (tempDic==nil) {
        NSLog(@"传值为空");
        return;
    }
    
    [ChatPresenter sendChatMsg:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            Gam_Chat * GC = (Gam_Chat *)[[DataOperation sharedDataOperation]creatManagedObj:@"Gam_Chat"];
            
            GC.chatID = _ReceiveID;
            GC.systime = [DateUitls DateFromString:data DateFormatter:@"YYYY-MM-dd HH:mm:ss"];
#warning 本地数据
//            UIImage * newImg = [UIImage imageNamed:@"发帖-车位图片"];
//            GC.contentPicData = UIImageJPEGRepresentation(newImg, 1);
            GC.contentPicUrl = [tempDic objectForKey:@"picurl"];
            GC.ownerType = @(XMMessageOwnerTypeSelf);
            GC.cellIdentifier = @"XMMImageTextMessageCell";
            GC.sendName = self.navigationItem.title;
            GC.headPicUrl = self.chatterThumb;
            GC.content = tempDic[@"content"];
            GC.sendID = appDelegate.userData.userID;
            GC.receiveID = _ReceiveID;
            GC.msgType = @(3);
            GC.userID = appDelegate.userData.userID;
            [selfWeak.dataArray addObject:GC];
            [[DataOperation sharedDataOperation]save];
            [selfWeak.tableView beginUpdates];
            [selfWeak.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [selfWeak.tableView endUpdates];
            [selfWeak scrollToBottom];
        });
        
    } withUserID:_ReceiveID andMsgType:@"3" andContent:tempDic[@"content"]andResourcesID:tempDic[@"picid"]];
    
}
#pragma mark - 发送定位
- (void)chatBar:(XMChatBar *)chatBar sendLocation:(CLLocationCoordinate2D)locationCoordinate locationText:(NSString *)locationText{
    
    XMLocationMessage *locationMessage = [XMMessage locationMessage:@{@"messageOwner":@(XMMessageOwnerTypeSelf),@"messageTime":@([[NSDate date] timeIntervalSince1970]),@"address":locationText,@"lat":@(locationCoordinate.latitude),@"lng":@(locationCoordinate.longitude)}];
    
//  locationMessage.senderAvatarThumb = kSelfThumb;
    locationMessage.senderNickName = kSelfName;
    locationMessage.messageChatType = self.messageChatType;
    [self.dataArray addObject:locationMessage];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    [self scrollToBottom];
    
}
#pragma mark - 修改tableview坐标
- (void)chatBarFrameDidChange:(XMChatBar *)chatBar frame:(CGRect)frame{
    

    if (frame.origin.y == self.tableView.frame.size.height) {
        return;
    }
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-SCREEN_HEIGHT+frame.origin.y+64);
        

    }];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        [NSThread sleepForTimeInterval:0.05f];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [self scrollToBottom];

            });
       
    });
    
}

#pragma mark - XMAVAudioPlayerDelegate

- (void)audioPlayerBeginLoadVoice{
    
    NSLog(@"正在从网络加载录音文件");
    
}

- (void)audioPlayerBeginPlay{

}

- (void)audioPlayerDidFinishPlay{
    
    XMVoiceMessageCell *voicePlayingCell = [self.tableView cellForRowAtIndexPath:self.voicePlayingIndexPath];
    [voicePlayingCell stopPlaying];
    self.voicePlayingIndexPath = nil;
}

#pragma mark - Private Methods


-(void)loadOne
{
    [self.dataArray removeAllObjects];
    if ([XYString isBlankString:_ReceiveID]) {
        [self showToastMsg:@"该邻友ID不存在！" Duration:2.5f];
        return;
    }
    NSArray * dataArr = [[DataOperation sharedDataOperation]queryData:@"Gam_Chat" withCurrentPage:0 withChatID:_ReceiveID];
    
    if (dataArr!=nil&&dataArr.count>0) {
        
        NSRange range = NSMakeRange(0, [dataArr count]);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.dataArray insertObjects:dataArr atIndexes:indexSet];
        NSLog(@"%@",self.dataArray);
        [self.tableView reloadData];
        [self scrollToBottom];
    }
    ///发送图文消息
    if (self.isGoods) {
        if(_goodsDic==nil)
        {
            NSLog(@"图文消息传值为空");
            return;
        }
        [self sendPicturesText:_goodsDic];
    }
}
- (void)loadData{
    
    if ([XYString isBlankString:_ReceiveID]) {
        [self showToastMsg:@"该邻友ID不存在！" Duration:2.5f];
        return;
    }
    
    page++;

    NSArray * dataArr = [[DataOperation sharedDataOperation]queryData:@"Gam_Chat" withCurrentPage:page withChatID:_ReceiveID];
    [self.tableView.mj_header endRefreshing];
    
    if (dataArr!=nil&&dataArr.count>0) {
        
    
        if (dataArr.count==1&&page!=0) {
            
        }else
        {
            NSRange range = NSMakeRange(0, [dataArr count]);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.dataArray insertObjects:dataArr atIndexes:indexSet];
            NSLog(@"%@",self.dataArray);
            [self.tableView reloadData];
            if (page == 0){
                [self scrollToBottom];
            }
        }
        
    }
}

- (void)scrollToBottom {
    
    if ((self.dataArray.count - 1)>2&&(self.dataArray.count != 0)) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
}

#pragma mark - Getters

+ (NSString *)generateRandomStr:(NSUInteger)length{
    
    NSString *sourceStr = @"0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (int i = 0; i < length; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,-10,SCREEN_WIDTH,SCREEN_HEIGHT - kMinHeight) style:UITableViewStylePlain];
        _tableView.tableHeaderView = [UIView new];
        tableFrame=_tableView.frame;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        [_tableView registerClass:[XMSystemMessageCell class] forCellReuseIdentifier:@"XMSystemMessageCell"];
        [_tableView registerClass:[XMTextMessageCell class] forCellReuseIdentifier:@"XMTextMessageCell"];
        [_tableView registerClass:[XMImageMessageCell class] forCellReuseIdentifier:@"XMImageMessageCell"];
        [_tableView registerClass:[XMLocationMessageCell class] forCellReuseIdentifier:@"XMLocationMessageCell"];
        [_tableView registerClass:[XMVoiceMessageCell class] forCellReuseIdentifier:@"XMVoiceMessageCell"];
        [_tableView registerClass:[XMMImageTextMessageCell class] forCellReuseIdentifier:@"XMMImageTextMessageCell"];
        
        _tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
