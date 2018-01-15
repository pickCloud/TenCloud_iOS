//
//  TCCompleteInviteRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCCompleteInviteRequest.h"

@interface TCCompleteInviteRequest()
@end

@implementation TCCompleteInviteRequest

- (instancetype) initWithCode:(NSString*)code
{
    self = [super init];
    if (self)
    {
        _code = code;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        //NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        success ? success(@"完成接受邀请") : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/company/application";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    if (_code == nil)
    {
        _code = @"";
    }
    if (_mobile == nil)
    {
        _mobile = @"";
    }
    if (_name == nil)
    {
        _name = @"";
    }
    if (_idCard == nil)
    {
        _idCard = @"";
    }
    return @{@"code":_code,
             @"mobile":_mobile,
             @"name":_name,
             @"id_card":_idCard
             };
}
@end
