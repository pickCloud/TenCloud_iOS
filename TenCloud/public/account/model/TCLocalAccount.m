//
//  TCLocalAccount.m
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCLocalAccount.h"
#import "TCUser+CoreDataClass.h"

#define ACCOUNT_USERID      @"ACCOUNT_USERID"
#define ACCOUNT_NAME        @"ACCOUNT_NAME"
#define ACCOUNT_MOBILE      @"ACCOUNT_MOBILE"
#define ACCOUNT_TOKEN       @"ACCOUNT_TOKEN"
#define ACCOUNT_AVATAR      @"ACCOUNT_AVATAR"
#define ACCOUNT_EMAIL       @"ACCOUNT_EMAIL"
#define ACCOUNT_GENDER      @"ACCOUNT_GENDER"
#define ACCOUNT_BIRTHDAY    @"ACCOUNT_BIRTHDAY"
#define ACCOUNT_CREATE_TIME @"ACCOUNT_CREATE_TIME"

@interface TCLocalAccount ()
{
    NSMutableArray      *mObserverArray;
}
@end

@implementation TCLocalAccount

+ (TCLocalAccount *) shared
{
    static TCLocalAccount *instance;
    static dispatch_once_t accountDisp;
    dispatch_once(&accountDisp, ^{
        instance = [[TCLocalAccount alloc] init];
    });
    return instance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        mObserverArray = [NSMutableArray new];
        NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *fileName = [array.firstObject stringByAppendingPathComponent:@"accountArchiverModel"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
        {
            NSData *undata = [[NSData alloc] initWithContentsOfFile:fileName];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:undata];
            self = [unarchiver decodeObjectForKey:@"account_model"];
            [unarchiver finishDecoding];
        }
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        mObserverArray = [NSMutableArray new];
        self.userID = [aDecoder decodeIntegerForKey:ACCOUNT_USERID];
        self.name = [aDecoder decodeObjectForKey:ACCOUNT_NAME];
        self.mobile = [aDecoder decodeObjectForKey:ACCOUNT_MOBILE];
        self.token = [aDecoder decodeObjectForKey:ACCOUNT_TOKEN];
        self.avatar = [aDecoder decodeObjectForKey:ACCOUNT_AVATAR];
        self.email = [aDecoder decodeObjectForKey:ACCOUNT_EMAIL];
        self.gender = [aDecoder decodeIntegerForKey:ACCOUNT_GENDER];
        self.birthday = [aDecoder decodeIntegerForKey:ACCOUNT_BIRTHDAY];
        self.createTime = [aDecoder decodeObjectForKey:ACCOUNT_CREATE_TIME];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.userID forKey:ACCOUNT_USERID];
    [aCoder encodeObject:self.name forKey:ACCOUNT_NAME];
    [aCoder encodeObject:self.mobile forKey:ACCOUNT_MOBILE];
    [aCoder encodeObject:self.token forKey:ACCOUNT_TOKEN];
    [aCoder encodeObject:self.avatar forKey:ACCOUNT_AVATAR];
    [aCoder encodeObject:self.email forKey:ACCOUNT_EMAIL];
    [aCoder encodeInteger:self.gender forKey:ACCOUNT_GENDER];
    [aCoder encodeInteger:self.birthday forKey:ACCOUNT_BIRTHDAY];
    [aCoder encodeObject:self.createTime forKey:ACCOUNT_CREATE_TIME];
}

- (void) addObserver:(id<TCLocalAccountDelegate>)obs
{
    if (obs)
    {
        [mObserverArray addObject:obs];
    }
}

- (void) removeObserver:(id<TCLocalAccountDelegate>)obs
{
    if (obs)
    {
        [mObserverArray removeObject:obs];
    }
}

- (BOOL) isLogin
{
    return ((self.token != nil) && (self.token.length > 0));
}

- (void) loginSuccess:(TCUser*)user
{
    NSLog(@"login success, prepare send notification");
    TCLocalAccount *account = [TCLocalAccount shared];
    account.userID = user.userID;
    account.name = user.name;
    account.mobile = user.mobile;
    account.token = user.token;
    account.avatar = user.image_url;
    account.email = user.email;
    account.gender = user.gender;
    account.birthday = user.birthday;
    account.createTime = user.create_time;
    
    if (!account.name || account.name.length == 0)
    {
        account.name = [NSString stringWithFormat:@"用户%lld",user.userID];
    }
    [account save];
    
    for (id<TCLocalAccountDelegate> obs in mObserverArray)
    {
        if ([obs respondsToSelector:@selector(accountLoggedIn:)])
        {
            [obs accountLoggedIn:account];
        }
    }
}

- (void) modified
{
    TCLocalAccount *account = [TCLocalAccount shared];
    for (id<TCLocalAccountDelegate> obs in mObserverArray)
    {
        if ([obs respondsToSelector:@selector(accountModified:)])
        {
            [obs accountModified:account];
        }
    }
}

- (NSString *) hiddenMobile
{
    if (_mobile.length >= 11)
    {
        NSRange replaceRange = NSMakeRange(3, 4);
        NSString *filteredPhone = [_mobile stringByReplacingCharactersInRange:replaceRange withString:@"****"];
        return filteredPhone;
    }
    return _mobile;
}

- (void) logout
{
    TCLocalAccount *account = [TCLocalAccount shared];
    account.name = @"";
    account.mobile = @"";
    account.token = @"";
    account.avatar = @"";
    account.email = @"";
    account.gender = 0;
    account.birthday = 0;
    account.createTime = @"";
    [account save];
    for (id<TCLocalAccountDelegate> obs in mObserverArray)
    {
        if ([obs respondsToSelector:@selector(accountLogout:)])
        {
            [obs accountLogout:account];
        }
    }
}

- (void) save
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:[TCLocalAccount shared] forKey:@"account_model"];
    [archiver finishEncoding];
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [array.firstObject stringByAppendingPathComponent:@"accountArchiverModel"];
    if([data writeToFile:fileName atomically:YES]){
        NSLog(@"归档成功");
    }
}

@end
