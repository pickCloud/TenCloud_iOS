//
//  TCServerUsage1Cell.m
//  TenCloud
//
//  Created by huangdx on 2018/3/14.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCServerUsage1Cell.h"
#import "TCServerUsage+CoreDataClass.h"
#import "TCServerPerformance+CoreDataClass.h"
#import "TCServerCPU+CoreDataClass.h"
#import "TCServerMemory+CoreDataClass.h"
#import "TCServerDisk+CoreDataClass.h"
#import "TCServerNet+CoreDataClass.h"
#import <WYChart/WYLineChartView.h>
#import <WYChart/WYLineChartPoint.h>
#import <WYChart/WYLineChartCalculator.h>
#import "TCServerPerformanceRequest.h"
#import "NSString+Extension.h"

@interface TCServerUsage1Cell()<WYLineChartViewDelegate,WYLineChartViewDatasource>
@property (nonatomic, strong)   TCServerPerformance     *performance;
@property (nonatomic, strong)   NSMutableArray          *cpuPoints;
@property (nonatomic, strong)   NSMutableArray          *memoryPoints;
@property (nonatomic, strong)   NSMutableArray          *diskPoints;
@property (nonatomic, strong)   NSMutableArray          *netPoints;
@property (nonatomic, strong)   NSMutableArray          *diskUtilPoints;
@property (nonatomic, weak)     IBOutlet    WYLineChartView *cpuChartView;
@property (nonatomic, weak)     IBOutlet    WYLineChartView *memoryChartView;
@property (nonatomic, weak)     IBOutlet    WYLineChartView *diskChartView;
@property (nonatomic, weak)     IBOutlet    WYLineChartView *netChartView;
@property (nonatomic, weak)     IBOutlet    WYLineChartView *diskUtilChartView;
@property (nonatomic, weak)     IBOutlet    UIPageControl   *pageControl;
@property (nonatomic, weak)     IBOutlet    UIScrollView    *scrollView;
- (void) initChartUI;
- (void) updateChartUI;
- (void) reloadChartData;
- (IBAction) onServerProfilePage:(id)sender;
@end

@implementation TCServerUsage1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _cpuPoints = [NSMutableArray new];
    _memoryPoints = [NSMutableArray new];
    _diskPoints = [NSMutableArray new];
    _netPoints = [NSMutableArray new];
    _diskUtilPoints = [NSMutableArray new];
    [self initChartUI];
}

- (void) setUsage:(TCServerUsage*)usage
{
    [super setUsage:usage];
    [self reloadChartData];
}

#pragma mark - extension
- (void) initChartUI
{
    //UIColor *axisColor = [UIColor colorWithRed:102/255.0 green:112/255.0 blue:130/255.0 alpha:1.0];
    UIColor *axisColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    
    //设置CPU曲线图
    _cpuChartView.backgroundColor = [UIColor clearColor];
    _cpuChartView.delegate = self;
    _cpuChartView.datasource = self;
    _cpuChartView.clipsToBounds = NO;
    
    _cpuChartView.lineLeftMargin = 0;
    _cpuChartView.lineRightMargin = 0;
    _cpuChartView.lineTopMargin = 0;
    _cpuChartView.lineBottomMargin = 0;
    
    _cpuChartView.animationDuration = 1.0;
    _cpuChartView.animationStyle = kWYLineChartAnimationDrawing;
    _cpuChartView.scrollable = NO;
    _cpuChartView.pinchable = NO;
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSArray *tmpPoints = [WYLineChartPoint pointsFromValueArray:@[@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(1.0)]];
    [mutableArray addObject:tmpPoints];
    _cpuPoints = mutableArray;
    _cpuChartView.points = [NSArray arrayWithArray:_cpuPoints];
    
    _cpuChartView.touchPointColor = [UIColor redColor];
    _cpuChartView.labelsFont = [UIFont systemFontOfSize:TCSCALE(10)];
    
    _cpuChartView.verticalReferenceLineColor = [UIColor clearColor];
    _cpuChartView.horizontalRefernenceLineColor = [UIColor clearColor];
    _cpuChartView.axisColor = axisColor;
    _cpuChartView.labelsColor = axisColor;
    
    
    //设置内存曲线图
    _memoryChartView.backgroundColor = [UIColor clearColor];
    _memoryChartView.delegate = self;
    _memoryChartView.datasource = self;
    _memoryChartView.lineLeftMargin = 0;
    _memoryChartView.lineRightMargin = 0;
    _memoryChartView.lineTopMargin = 0;
    _memoryChartView.lineBottomMargin = 0;
    _memoryChartView.animationDuration = 1.0;
    _memoryChartView.animationStyle = kWYLineChartAnimationDrawing;
    _memoryChartView.scrollable = NO;
    _memoryChartView.pinchable = NO;
    _memoryPoints = mutableArray;
    _memoryChartView.points = [NSArray arrayWithArray:_memoryPoints];
    _memoryChartView.labelsFont = [UIFont systemFontOfSize:TCSCALE(10)];
    _memoryChartView.verticalReferenceLineColor = [UIColor clearColor];
    _memoryChartView.horizontalRefernenceLineColor = [UIColor clearColor];
    _memoryChartView.axisColor = axisColor;
    _memoryChartView.labelsColor = axisColor;
    
    //设置硬盘使用情况曲线图
    _diskChartView.backgroundColor = [UIColor clearColor];
    _diskChartView.delegate = self;
    _diskChartView.datasource = self;
    _diskChartView.lineLeftMargin = 0;
    _diskChartView.lineRightMargin = 0;
    _diskChartView.lineTopMargin = 0;
    _diskChartView.lineBottomMargin = 0;
    _diskChartView.animationDuration = 1.0;
    _diskChartView.animationStyle = kWYLineChartAnimationDrawing;
    _diskChartView.scrollable = NO;
    _diskChartView.pinchable = NO;
    _diskPoints = mutableArray;
    _diskChartView.points = [NSArray arrayWithArray:_diskPoints];
    _diskChartView.labelsFont = [UIFont systemFontOfSize:TCSCALE(10)];
    _diskChartView.verticalReferenceLineColor = [UIColor clearColor];
    _diskChartView.horizontalRefernenceLineColor = [UIColor clearColor];
    _diskChartView.axisColor = axisColor;
    _diskChartView.labelsColor = axisColor;

    //设置网络曲线图
    _netChartView.backgroundColor = [UIColor clearColor];
    _netChartView.delegate = self;
    _netChartView.datasource = self;
    _netChartView.lineLeftMargin = 0;
    _netChartView.lineRightMargin = 0;
    _netChartView.lineTopMargin = 0;
    _netChartView.lineBottomMargin = 0;
    _netChartView.animationDuration = 1.0;
    _netChartView.animationStyle = kWYLineChartAnimationDrawing;
    _netChartView.scrollable = NO;
    _netChartView.pinchable = NO;
    _netPoints = mutableArray;
    _netChartView.points = [NSArray arrayWithArray:_netPoints];
    _netChartView.labelsFont = [UIFont systemFontOfSize:TCSCALE(10)];
    _netChartView.verticalReferenceLineColor = [UIColor clearColor];
    _netChartView.horizontalRefernenceLineColor = [UIColor clearColor];
    _netChartView.axisColor = axisColor;
    _netChartView.labelsColor = axisColor;
    
    //设置硬盘使用率曲线图
    _diskUtilChartView.backgroundColor = [UIColor clearColor];
    _diskUtilChartView.delegate = self;
    _diskUtilChartView.datasource = self;
    _diskUtilChartView.lineLeftMargin = 0;
    _diskUtilChartView.lineRightMargin = 0;
    _diskUtilChartView.lineTopMargin = 0;
    _diskUtilChartView.lineBottomMargin = 0;
    _diskUtilChartView.animationDuration = 1.0;
    _diskUtilChartView.animationStyle = kWYLineChartAnimationDrawing;
    _diskUtilChartView.scrollable = NO;
    _diskUtilChartView.pinchable = NO;
    _diskUtilPoints = mutableArray;
    _diskUtilChartView.points = [NSArray arrayWithArray:_diskUtilPoints];
    _diskUtilChartView.labelsFont = [UIFont systemFontOfSize:TCSCALE(10)];
    _diskUtilChartView.verticalReferenceLineColor = [UIColor clearColor];
    _diskUtilChartView.horizontalRefernenceLineColor = [UIColor clearColor];
    _diskUtilChartView.axisColor = axisColor;
    _diskUtilChartView.labelsColor = axisColor;
}

- (void) updateChartUI
{
    //重新计算cpu points
    [_cpuPoints removeAllObjects];
    NSMutableArray *rawPoints = [NSMutableArray new];
    for (int i = 0; i < self.performance.cpu.count; i++)
    {
        TCServerCPU *cpu = [self.performance.cpu objectAtIndex:i];
        [rawPoints addObject:@(cpu.percent.floatValue)];
    }
    
    if (rawPoints.count == 1)
    {
        NSNumber *cpuNum1 = rawPoints.firstObject;
        NSNumber *cpuNum2 = [NSNumber numberWithFloat:cpuNum1.floatValue];
        [rawPoints addObject:cpuNum2];
    }
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSArray *tmpPoints = [WYLineChartPoint pointsFromValueArray:rawPoints];
    [mutableArray addObject:tmpPoints];
    [_cpuPoints addObjectsFromArray:mutableArray];
    self.cpuChartView.points = [NSArray arrayWithArray:_cpuPoints];
    [self.cpuChartView updateGraph];
    
    
    //重新计算内存points
    [_memoryPoints removeAllObjects];
    NSMutableArray *rawMemoryPoints = [NSMutableArray new];
    for (int i = 0; i < self.performance.memory.count; i++)
    {
        TCServerMemory *memory = [self.performance.memory objectAtIndex:i];
        [rawMemoryPoints addObject:@(memory.percent.floatValue)];
    }
    if (rawMemoryPoints.count == 1)
    {
        NSNumber *memoryNum1 = rawMemoryPoints.firstObject;
        NSNumber *memoryNum2 = [NSNumber numberWithFloat:memoryNum1.floatValue];
        [rawMemoryPoints addObject:memoryNum2];
    }
    
    NSMutableArray *memoryPointArray = [NSMutableArray array];
    NSArray *tmpMemoryPoints = [WYLineChartPoint pointsFromValueArray:rawMemoryPoints];
    [memoryPointArray addObject:tmpMemoryPoints];
    [_memoryPoints addObjectsFromArray:memoryPointArray];
    self.memoryChartView.points = [NSArray arrayWithArray:_memoryPoints];
    [self.memoryChartView updateGraph];
    
    //重新计算硬盘points
    [_diskPoints removeAllObjects];
    [_diskUtilPoints removeAllObjects];     //重新计算磁盘使用率
    NSMutableArray *rawDiskPoints = [NSMutableArray new];
    NSMutableArray *rawDiskUtilPoints = [NSMutableArray new];
    for (int i = 0; i < self.performance.disk.count; i++)
    {
        TCServerDisk *disk = [self.performance.disk objectAtIndex:i];
        [rawDiskPoints addObject:@(disk.percent.floatValue)];
        [rawDiskUtilPoints addObject:@(disk.utilize)];
    }
    if (rawDiskPoints.count == 1)
    {
        NSNumber *diskPoint1 = rawDiskPoints.firstObject;
        NSNumber *diskPoint2 = [NSNumber numberWithFloat:diskPoint1.floatValue];
        [rawDiskPoints addObject:diskPoint2];
    }
    NSMutableArray *diskPointArray = [NSMutableArray array];
    NSArray *tmpDiskPoints = [WYLineChartPoint pointsFromValueArray:rawDiskPoints];
    [diskPointArray addObject:tmpDiskPoints];
    [_diskPoints addObjectsFromArray:diskPointArray];
    self.diskChartView.points = [NSArray arrayWithArray:_diskPoints];
    [self.diskChartView updateGraph];
    
    NSMutableArray *diskUtilPointArray = [NSMutableArray new];
    NSArray *tmpDiskUtilPoints = [WYLineChartPoint pointsFromValueArray:rawDiskUtilPoints];
    [diskUtilPointArray addObject:tmpDiskUtilPoints];
    [_diskUtilPoints addObjectsFromArray:diskUtilPointArray];
    self.diskUtilChartView.points = [NSArray arrayWithArray:_diskUtilPoints];
    [self.diskUtilChartView updateGraph];
    
    //重新计算网络points
    [_netPoints removeAllObjects];
    NSMutableArray *rawNetOutputPoints = [NSMutableArray new];
    NSMutableArray *rawNetInputPoints = [NSMutableArray new];
    for (int i = 0; i < self.performance.net.count; i++)
    {
        TCServerNet *net = [self.performance.net objectAtIndex:i];
        [rawNetOutputPoints addObject:@(net.output)];
        [rawNetInputPoints addObject:@(net.input)];
    }
    if (rawNetInputPoints.count == 1)
    {
        NSNumber *inputNum1 = rawNetInputPoints.firstObject;
        NSNumber *inputNum2 = [NSNumber numberWithInteger:inputNum1.integerValue];
        [rawNetInputPoints addObject:inputNum2];
        NSNumber *outputNum1 = rawNetOutputPoints.firstObject;
        NSNumber *outputNum2 = [NSNumber numberWithInteger:outputNum1.integerValue];
        [rawNetOutputPoints addObject:outputNum2];
    }
    NSMutableArray *outputPointArray = [NSMutableArray array];
    NSArray *tmpNetOutputPoints = [WYLineChartPoint pointsFromValueArray:rawNetOutputPoints];
    [outputPointArray addObject:tmpNetOutputPoints];
    NSArray *tmpNetInputPoints = [WYLineChartPoint pointsFromValueArray:rawNetInputPoints];
    [outputPointArray addObject:tmpNetInputPoints];
    [_netPoints addObjectsFromArray:outputPointArray];
    

    
    
    self.netChartView.points = [NSArray arrayWithArray:_netPoints];
    [self.netChartView updateGraph];
}

- (void) reloadChartData
{
    NSInteger endTime = [[NSDate date] timeIntervalSince1970];
    NSInteger startTime = endTime - 3600;
    //startTime = endTime - 86400;  //24hour
    //startTime = endTime - 604800;   //one week
    //startTime = endTime - 18144000;   //one month
    __weak __typeof(self) weakSelf = self;
    TCServerPerformanceRequest *request = [[TCServerPerformanceRequest alloc] initWithServerID:self.usage.serverID type:0 startTime:startTime endTime:endTime];
    [request startWithSuccess:^(TCServerPerformance *performance) {
        weakSelf.performance = performance;
        [weakSelf updateChartUI];
    } failure:^(NSString *message) {
        NSLog(@"fail message:%@",message);
        [MBProgressHUD showError:message toView:nil];
    }];
}

- (IBAction) onServerProfilePage:(id)sender
{
    if (self.nextBlock)
    {
        self.nextBlock(self);
    }
}


#pragma mark - WYLineChartViewDelegate

- (NSInteger)numberOfLabelOnXAxisInLineChartView:(WYLineChartView *)chartView {
    if (chartView == _memoryChartView)
    {
        return [_memoryPoints[0] count];
    }else if(chartView == _diskChartView)
    {
        return [_diskPoints[0] count];
    }else if(chartView == _netChartView)
    {
        return [_netPoints[0] count];
    }else if(chartView == _diskUtilChartView)
    {
        return [_diskUtilPoints[0] count];
    }
    return [_cpuPoints[0] count];
}

- (NSInteger)numberOfLabelOnYAxisInLineChartView:(WYLineChartView *)chartView {
    return 8;
}

- (CGFloat)gapBetweenPointsHorizontalInLineChartView:(WYLineChartView *)chartView {
    return 0.0f;
}

- (NSInteger)numberOfReferenceLineVerticalInLineChartView:(WYLineChartView *)chartView {
    if (chartView == _memoryChartView)
    {
        return [_memoryPoints[0] count];
    }else if(chartView == _diskChartView)
    {
        return [_diskPoints[0] count];
    }else if(chartView == _netChartView)
    {
        return [_netPoints[0] count];
    }else if(chartView == _diskUtilChartView)
    {
        return [_diskUtilPoints[0] count];
    }
    return [_cpuPoints[0] count];
}

- (NSInteger)numberOfReferenceLineHorizontalInLineChartView:(WYLineChartView *)chartView {
    if (chartView == _memoryChartView)
    {
        return [_memoryPoints[0] count];
    }else if(chartView == _diskChartView)
    {
        return [_diskPoints[0] count];
    }else if(chartView == _netChartView)
    {
        return [_netPoints[0] count];
    }else if(chartView == _diskUtilChartView)
    {
        return [_diskUtilPoints[0] count];
    }
    return [_cpuPoints[0] count];
}


#pragma mark - WYLineChartViewDatasource

- (NSString *)lineChartView:(WYLineChartView *)chartView contextTextForPointAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSString *)lineChartView:(WYLineChartView *)chartView contentTextForXAxisLabelAtIndex:(NSInteger)index {
    if (_performance)
    {
        if (chartView == _cpuChartView)
        {
            if (index < _performance.cpu.count)
            {
                TCServerCPU *cpuItem = [_performance.cpu objectAtIndex:index];
                return [NSString timeStringFromInteger:cpuItem.created_time];
            }
        }else if(chartView == _memoryChartView)
        {
            if (index < _performance.memory.count)
            {
                TCServerMemory *memoryItem = [_performance.memory objectAtIndex:index];
                return [NSString timeStringFromInteger:memoryItem.created_time];
            }
        }else if(chartView == _diskChartView)
        {
            if (index < _performance.disk.count)
            {
                TCServerDisk *diskItem = [_performance.disk objectAtIndex:index];
                return [NSString timeStringFromInteger:diskItem.created_time];
            }
        }else if(chartView == _netChartView)
        {
            if (index < _performance.net.count)
            {
                TCServerNet *netItem = [_performance.net objectAtIndex:index];
                return [NSString timeStringFromInteger:netItem.created_time];
            }
        }else if(chartView == _diskUtilChartView)
        {
            if (index < _performance.disk.count)
            {
                TCServerDisk *diskItem = [_performance.disk objectAtIndex:index];
                return [NSString timeStringFromInteger:diskItem.created_time];
            }
        }
    }
    return [NSString stringWithFormat:@"%lu月", index+1];
}

- (WYLineChartPoint *)lineChartView:(WYLineChartView *)chartView pointReferToXAxisLabelAtIndex:(NSInteger)index {
    if (chartView == _memoryChartView)
    {
        return _memoryPoints[0][index];
    }else if(chartView == _diskChartView)
    {
        return _diskPoints[0][index];
    }else if(chartView == _netChartView)
    {
        return _netPoints[0][index];
    }else if(chartView == _diskUtilChartView)
    {
        return _diskUtilPoints[0][index];
    }
    return _cpuPoints[0][index];
}

- (WYLineChartPoint *)lineChartView:(WYLineChartView *)chartView pointReferToVerticalReferenceLineAtIndex:(NSInteger)index {
    if (chartView == _memoryChartView)
    {
        return _memoryPoints[0][index];
    }else if(chartView == _diskChartView)
    {
        return _diskPoints[0][index];
    }else if(chartView == _netChartView)
    {
        return _netPoints[0][index];
    }else if(chartView == _diskUtilChartView)
    {
        return _diskUtilPoints[0][index];
    }
    return _cpuPoints[0][index];
}

- (NSString *)lineChartView:(WYLineChartView *)chartView contentTextForYAxisLabelAtIndex:(NSInteger)index {
    if (chartView == _memoryChartView)
    {
        CGFloat maxValue = [self.memoryChartView.calculator maxValuePointsOfLinesPointSet:self.memoryChartView.points].value;
        CGFloat minValue = [self.memoryChartView.calculator minValuePointsOfLinesPointSet:self.memoryChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.memoryChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        CGFloat value = minValue + interval * index;
        return [NSString stringWithFormat:@"%.02f",value];
    }else if(chartView == _diskChartView)
    {
        CGFloat maxValue = [self.diskChartView.calculator maxValuePointsOfLinesPointSet:self.diskChartView.points].value;
        CGFloat minValue = [self.diskChartView.calculator minValuePointsOfLinesPointSet:self.diskChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.diskChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        CGFloat value = minValue + interval * index;
        return [NSString stringWithFormat:@"%.02f",value];
    }else if(chartView == _netChartView)
    {
        CGFloat maxValue = [self.netChartView.calculator maxValuePointsOfLinesPointSet:self.netChartView.points].value;
        CGFloat minValue = [self.netChartView.calculator minValuePointsOfLinesPointSet:self.netChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.netChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        CGFloat value = minValue + interval * index;
        return [NSString stringWithFormat:@"%.02f",value];
    }else if(chartView == _diskUtilChartView)
    {
        CGFloat maxValue = [self.diskUtilChartView.calculator maxValuePointsOfLinesPointSet:self.diskUtilChartView.points].value;
        CGFloat minValue = [self.diskUtilChartView.calculator minValuePointsOfLinesPointSet:self.diskUtilChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.diskUtilChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        CGFloat value = minValue + interval * index;
        return [NSString stringWithFormat:@"%.02f",value];
    }
    CGFloat maxValue = [self.cpuChartView.calculator maxValuePointsOfLinesPointSet:self.cpuChartView.points].value;
    CGFloat minValue = [self.cpuChartView.calculator minValuePointsOfLinesPointSet:self.cpuChartView.points].value;
    NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.cpuChartView];
    CGFloat interval = 5.0;
    if (yPointNum > 0)
    {
        interval = (maxValue - minValue) / yPointNum;
    }
    CGFloat value = minValue + interval * index;
    return [NSString stringWithFormat:@"%.02f",value];
}

- (CGFloat)lineChartView:(WYLineChartView *)chartView valueReferToYAxisLabelAtIndex:(NSInteger)index {
    if (chartView == _memoryChartView)
    {
        CGFloat maxValue = [self.memoryChartView.calculator maxValuePointsOfLinesPointSet:self.memoryChartView.points].value;
        CGFloat minValue = [self.memoryChartView.calculator minValuePointsOfLinesPointSet:self.memoryChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.memoryChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        return (minValue + interval * index);
    }else if(chartView == _diskChartView)
    {
        CGFloat maxValue = [self.diskChartView.calculator maxValuePointsOfLinesPointSet:self.diskChartView.points].value;
        CGFloat minValue = [self.diskChartView.calculator minValuePointsOfLinesPointSet:self.diskChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.diskChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        return (minValue + interval * index);
    }else if(chartView == _netChartView)
    {
        CGFloat maxValue = [self.netChartView.calculator maxValuePointsOfLinesPointSet:self.netChartView.points].value;
        CGFloat minValue = [self.netChartView.calculator minValuePointsOfLinesPointSet:self.netChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.netChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        return (minValue + interval * index);
    }else if(chartView == _diskUtilChartView)
    {
        CGFloat maxValue = [self.diskUtilChartView.calculator maxValuePointsOfLinesPointSet:self.diskUtilChartView.points].value;
        CGFloat minValue = [self.diskUtilChartView.calculator minValuePointsOfLinesPointSet:self.diskUtilChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.diskUtilChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        return (minValue + interval * index);
    }
    CGFloat maxValue = [self.cpuChartView.calculator maxValuePointsOfLinesPointSet:self.cpuChartView.points].value;
    CGFloat minValue = [self.cpuChartView.calculator minValuePointsOfLinesPointSet:self.cpuChartView.points].value;
    NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.cpuChartView];
    CGFloat interval = 5.0;
    if (yPointNum > 0)
    {
        interval = (maxValue - minValue) / yPointNum;
    }
    CGFloat value = minValue + interval * index;
    return value;
}

- (CGFloat)lineChartView:(WYLineChartView *)chartView valueReferToHorizontalReferenceLineAtIndex:(NSInteger)index {
    return 0.0;
}

- (NSDictionary *)lineChartView:(WYLineChartView *)chartView attributesForLineAtIndex:(NSUInteger)index {
    NSMutableDictionary *resultAttributes = [NSMutableDictionary dictionary];
    resultAttributes[kWYLineChartLineAttributeLineStyle] = @(kWYLineChartMainBezierWaveLine);
    resultAttributes[kWYLineChartLineAttributeDrawGradient] = @(true);
    resultAttributes[kWYLineChartLineAttributeJunctionStyle] = @(kWYLineChartJunctionShapeSolidCircle);
    
    UIColor *lineColor;
    /*
    if (chartView == _diskChartView)
    {
        lineColor = [UIColor colorWithRed:151/255.f green:186/255.f blue:147/255.f alpha:1.0];
    }else if(chartView == _memoryChartView)
    {
        lineColor = [UIColor colorWithRed:216/255.f green:91/255.f blue:98/255.f alpha:1.0];
    }else if(chartView == _netChartView)
    {
        if (index == 0)
        {
            lineColor = [UIColor colorWithRed:151/255.f green:186/255.f blue:147/255.f alpha:1.0];
        }else
        {
            lineColor = [UIColor colorWithRed:216/255.f green:91/255.f blue:98/255.f alpha:1.0];
        }
    }else
    {
        lineColor = [UIColor colorWithRed:119/255.f green:215/255.f blue:220/255.f alpha:1.0];
    }
     */
    if (chartView == _netChartView)
    {
        if (index == 0)
        {
            lineColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        }else
        {
            lineColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        }
    }else
    {
        lineColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    }
    resultAttributes[kWYLineChartLineAttributeLineColor] = lineColor;
    resultAttributes[kWYLineChartLineAttributeJunctionColor] = lineColor;
    return resultAttributes;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView)
    {
        CGRect scrollViewRect = _scrollView.bounds;
        int pageIndex = round(scrollView.contentOffset.x / scrollViewRect.size.width);
        [_pageControl setCurrentPage:pageIndex];
    }
}
@end
