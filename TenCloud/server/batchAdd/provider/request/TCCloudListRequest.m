//
//  TCCloudListRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCCloudListRequest.h"
#import "TCCloud+CoreDataClass.h"

@interface TCCloudListRequest()
@end

@implementation TCCloudListRequest

/*
- (instancetype) initWithStatus:(NSInteger)status
{
    self = [super init];
    if (self)
    {
        _status = status;
        //self.ignoreCache = YES;
    }
    return self;
}
 
- (instancetype) init
{
    self = [super init];
    if (self)
    {
        _status = -1;
        _page = -1;
        _page_num = -1;
    }
    return self;
}
*/

- (void) startWithSuccess:(void(^)(NSArray<TCCloud*> *cloudArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *resArray = [self resultCloudArray];
        success ? success(resArray) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSArray<TCCloud*> *)resultCloudArray
{
    NSDictionary *arrayDict = [self.responseJSONObject objectForKey:@"data"];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSArray *resArray = [TCCloud mj_objectArrayWithKeyValuesArray:arrayDict context:context];
    return resArray;
}

- (NSString *)requestUrl {
    /*
    NSMutableString *url = [NSMutableString new];
    [url appendString:@"/api/application?"];
    if (_status >= 0) {
        //[url appendString:@"status"]
        [url appendFormat:@"status=%ld&",_status];
    }
    if (_page >= 0)
    {
        [url appendFormat:@"page=%ld&",_page];
    }
    if (_page_num >= 0)
    {
        [url appendFormat:@"page_num=%ld&",_page_num];
    }
    if (_label && _label.length > 0)
    {
        [url appendFormat:@"label=%@",_label];
    }
    */
    //NSString *url = [NSString stringWithFormat:@"/api/companies/list/%ld",_status];
    return @"/api/clouds";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

//- (NSInteger)cacheTimeInSeconds
//{
//    return  NSIntegerMax;
//}

@end
