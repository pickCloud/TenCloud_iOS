//
//  TCModifyServerNameRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCModifyServerNameRequest.h"

@interface TCModifyServerNameRequest()
@property (nonatomic, assign)       NSInteger       serverID;
@property (nonatomic, strong)       NSString        *name;
@end

@implementation TCModifyServerNameRequest

- (instancetype) initWithServerID:(NSInteger)sid name:(NSString*)name
{
    self = [super init];
    if (self)
    {
        _serverID = sid;
        _name = name;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSString *status))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *status = [request.responseJSONObject objectForKey:@"data"];
        success ? success(status) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        //NSString *message = [request.responseJSONObject objectForKey:@"message"];
        //failure ? failure(message) : nil;
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/server/update";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    return @{@"id":@(_serverID),
             @"name":_name
             };
}
@end
