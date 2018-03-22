//
//  TCServerConfigInfoViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/3/16.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCServerConfigInfoViewController.h"
#import "TCServerConfig+CoreDataClass.h"
#import "TCServerSystemConfig+CoreDataClass.h"
#import "TCServerSystemInfo+CoreDataClass.h"
#import "TCServerBusinessInfo+CoreDataClass.h"
#import "TCServerBusinessContract+CoreDataClass.h"
#import "TCServerDiskInfoCell.h"
#import "TCDiskInfo+CoreDataClass.h"
#define SERVER_CONFIG_DISK_CELL_ID     @"SERVER_CONFIG_DISK_CELL_ID"

@interface TCServerConfigInfoViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet    UILabel     *cpuAmountLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *memorySizeLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *systemLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *mirrorIDLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *mirrorNameLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *mirrorVersionLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *diskTypeLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *diskSizeLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *netTypeLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *payMethodLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *inBandLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *outBandLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *securityIDLabel;
@property (nonatomic, strong)   TCServerConfig      *config;
@property (nonatomic, weak) IBOutlet    UITableView *diskTableView;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *diskTableHeight;
@end

@implementation TCServerConfigInfoViewController

- (id) initWithConfig:(TCServerConfig*)config
{
    self = [super init];
    if (self)
    {
        _config = config;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"配置信息";
    
    TCServerSystemConfig *sysConfig = _config.system_info.config;
    NSString *cpuAmountStr = [NSString stringWithFormat:@"%d",(int)sysConfig.cpu];
    _cpuAmountLabel.text = cpuAmountStr;
    NSString *memoryStr = [NSString stringWithFormat:@"%dG",(int)(sysConfig.memory/1024.0)];
    _memorySizeLabel.text = memoryStr;
    _systemLabel.text = sysConfig.os_name;
    _netTypeLabel.text = sysConfig.instance_network_type;
    _payMethodLabel.text = _config.business_info.contract.charge_type;
    _inBandLabel.text = sysConfig.max_bandwidth_in;
    _outBandLabel.text = sysConfig.max_bandwidth_out;
    _securityIDLabel.text = sysConfig.security_group_ids;
    /*
    NSString *imageName = sysConfig.image_name;
    if (imageName == nil || imageName.length == 0)
    {
        imageName = @"暂无";
    }
    _mirrorNameLabel.text = imageName;
    NSString *imageVersion = sysConfig.image_version;
    if (imageVersion == nil || imageVersion.length == 0)
    {
        imageVersion = @"暂无";
    }
    _mirrorVersionLabel.text = imageVersion;
     */
    
    //pending delete
    //_mirrorIDLabel.text = _config.
    //_diskTypeLabel.text = sysConfig.system_disk_type;
    //_diskSizeLabel.text = sysConfig.system_disk_size;
    UINib *diskCellNib = [UINib nibWithNibName:@"TCServerDiskInfoCell" bundle:nil];
    [_diskTableView registerNib:diskCellNib forCellReuseIdentifier:SERVER_CONFIG_DISK_CELL_ID];
    _diskTableView.tableFooterView = [UIView new];
    _diskTableView.delegate = self;
    _diskTableView.dataSource = self;
    
    NSInteger diskRow = sysConfig.disk_info.count;
    CGFloat height = 43 * diskRow;//TCSCALE(48) * diskRow;
    _diskTableHeight.constant = height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _diskTableView)
    {
        NSLog(@"hhhh:%ld",_config.system_info.config.disk_info.count);
        if (_config) {
            return _config.system_info.config.disk_info.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCServerDiskInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_CONFIG_DISK_CELL_ID forIndexPath:indexPath];
    NSArray *infoArray = _config.system_info.config.disk_info;
    if (infoArray && (indexPath.row < infoArray.count))
    {
        BOOL showNumber = infoArray.count > 1;
        TCDiskInfo *info = [infoArray objectAtIndex:indexPath.row];
        if (showNumber)
        {
            [cell setDiskInfo:info withNumber:indexPath.row+1];
        }else
        {
            [cell setDiskInfo:info withNumber:0];
        }
    }
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
