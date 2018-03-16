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

@interface TCServerConfigInfoViewController ()
@property (nonatomic, weak) IBOutlet    UILabel     *cpuAmountLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *memorySizeLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *systemLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *mirrorIDLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *diskTypeLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *diskSizeLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *netTypeLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *payMethodLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *inBandLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *outBandLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *securityIDLabel;
@property (nonatomic, strong)   TCServerConfig      *config;
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
    NSString *memoryStr = [NSString stringWithFormat:@"%dM",(int)sysConfig.memory];
    _memorySizeLabel.text = memoryStr;
    _systemLabel.text = sysConfig.os_name;
    //_mirrorIDLabel.text = _config.
    _diskTypeLabel.text = sysConfig.system_disk_type;
    _diskSizeLabel.text = sysConfig.system_disk_size;
    _netTypeLabel.text = sysConfig.instance_network_type;
    _payMethodLabel.text = _config.business_info.contract.charge_type;
    _inBandLabel.text = sysConfig.max_bandwidth_in;
    _outBandLabel.text = sysConfig.max_bandwidth_out;
    _securityIDLabel.text = sysConfig.security_group_ids;
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

@end
