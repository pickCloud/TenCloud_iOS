//
//  TCMessageCountRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCMessageCountRequest.h"

@interface TCMessageCountRequest()
@property (nonatomic, assign)       NSInteger        status;
@end

@implementation TCMessageCountRequest

- (instancetype) initWithStatus:(NSInteger)status
{
    self = [super init];
    if (self)
    {
        _status = status;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSInteger count))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        if (dataDict)
        {
            NSNumber *msgNum = [dataDict objectForKey:@"num"];
            if (msgNum)
            {
                success ? success (msgNum.integerValue) : nil;
            }
        }
        //success ? success(status) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/messages/count";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument
{
    //NSString *idStr = [NSString stringWithFormat:@"%ld",_status];
    return @{@"status":@(_status)};
}
@end
