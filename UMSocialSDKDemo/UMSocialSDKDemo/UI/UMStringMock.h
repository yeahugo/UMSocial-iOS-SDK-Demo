//
//  UMStringMock.h
//  SocialSDK
//
//  Created by Aladdin Zhang on 5/7/12.
//  Copyright (c) 2012 innovation-works. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kShortWordsMinimal 4
#define kShortWordsMaximal 7

#define kMiddleWordsMinimal 8
#define kMiddleWordsMaximal 12

#define kLongWordsMinimal 14
#define kLongWordsMaximal 18


@interface UMStringMock : NSObject
+ (NSString *) nameMockString;
+ (NSString *) statusMockString;
+ (NSString *) commentMockString;
+ (NSString *) titleMockString;
+ (NSString *) shortDescriptionMockString;
+ (NSString *) longDescriptionMockString;
+ (NSString *) dateMockString;
+ (NSString *) urlMockString;
+ (NSString *) chineseNameMockString;
+ (NSString *) latitudeString;
+ (NSString *) longitudeString;

@end
