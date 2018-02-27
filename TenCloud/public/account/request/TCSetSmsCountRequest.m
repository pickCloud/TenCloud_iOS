//
//  TCSetSmsCountRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCSetSmsCountRequest.h"

@interface TCSetSmsCountRequest()
@property (nonatomic, assign)   NSInteger   count;
@end

@implementation TCSetSmsCountRequest

- (instancetype) initWithCount:(NSInteger)count
{
    self = [super init];
    if (self)
    {
        _count = count;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success ? success(@"修改成功"):nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/api/tmp/user/sms/count/%ld",_count];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
