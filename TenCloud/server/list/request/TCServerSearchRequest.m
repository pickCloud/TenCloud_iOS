//
//  TCServerSearchRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerSearchRequest.h"
#import "TCServer+CoreDataClass.h"

@interface TCServerSearchRequest()
@property (nonatomic, assign)   NSInteger   clusterID;
@property (nonatomic, strong)   NSString    *serverName;
@property (nonatomic, strong)   NSArray     *regions;
@property (nonatomic, strong)   NSArray     *providers;
@end

@implementation TCServerSearchRequest

- (instancetype) initWithServerName:(NSString*)name
                            regions:(NSArray*)regions
                          providers:(NSArray*)providers
{
    self = [super init];
    if (self)
    {
        _clusterID = 1;
        _serverName = name;
        _regions = regions;
        _providers = providers;
        _serverName = _serverName != nil ? _serverName : @"";
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSArray<TCServer*> *serverArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *dictArray = [request.responseJSONObject objectForKey:@"data"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        NSArray *resArray = [TCServer mj_objectArrayWithKeyValuesArray:dictArray context:context];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.32 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            success ? success(resArray) : nil;
        });
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/cluster/search";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}


- (id)requestArgument
{
    return @{
             @"cluster_id":@(_clusterID),
             @"server_name":_serverName,
             @"region_name":_regions,
             @"provider_name":_providers
             };
}
@end
