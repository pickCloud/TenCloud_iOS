//
//  TCModifyUserProfileRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCModifyUserProfileRequest.h"

@interface TCModifyUserProfileRequest()
@property (nonatomic, strong)   NSString    *key;
@property (nonatomic, strong)   NSString    *value;
@end

@implementation TCModifyUserProfileRequest

- (instancetype) initWithKey:(NSString*)keyName value:(NSString*)value
{
    self = [super init];
    if (self)
    {
        _key = keyName;
        _value = value;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success ? success(@"修改成功") : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/user/update";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}


- (id)requestArgument
{
    _key = _key ? _key : @"";
    _value = _value ? _value : @"";
    return @{_key : _value};
}
@end
