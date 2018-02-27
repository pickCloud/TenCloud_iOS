//
//  TCModifyUserProfileRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCModifyCorpProfileRequest.h"
#import "TCCurrentCorp.h"

@interface TCModifyCorpProfileRequest()
@property (nonatomic, assign)   NSInteger   cid;
@property (nonatomic, strong)   NSString    *key;
@property (nonatomic, strong)   NSString    *value;
@end

@implementation TCModifyCorpProfileRequest

- (instancetype) initWithCid:(NSInteger)cid key:(NSString*)keyName value:(id)value
{
    self = [super init];
    if (self)
    {
        _cid = cid;
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
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/company/update";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}


- (id)requestArgument
{
    _key = _key ? _key : @"";
    _value = _value ? _value : @"";
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *name = [[TCCurrentCorp shared] name];
    NSString *mobile = [[TCCurrentCorp shared] mobile];
    NSString *contact = [[TCCurrentCorp shared] contact];
    [params setObject:name forKey:@"name"];
    [params setObject:contact forKey:@"contact"];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:@"1" forKey:@"image_url"];
    [params setObject:_value forKey:_key];
    [params setObject:@(_cid) forKey:@"cid"];
    //[params setObject:_value forKey:@"image_url"];
    return params;
}
@end
