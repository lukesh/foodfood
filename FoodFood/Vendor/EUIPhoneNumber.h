//
//  PhoneNumber.h
//  Strine
//
//  Created by Jason Kichline on 12/22/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	EUIPhoneNumberFormatNone,
	EUIPhoneNumberFormatDashed,
	EUIPhoneNumberFormatDotted,
	EUIPhoneNumberFormatCallable,
	EUIPhoneNumberFormatStandard
} EUIPhoneNumberFormat;

@interface EUIPhoneNumber : NSObject {
	
}

+(NSString*)formatPhoneNumber:(id)phoneNumber;
+(NSString*)formatPhoneNumber:(id)phoneNumber withStyle:(EUIPhoneNumberFormat)format;
+(NSString*)removeNonPhoneCharacters:(NSString*)number;
+(NSDictionary*)phoneNumberToDictionary:(id)phoneNumber;
+(void)parsePhoneNumber:(id)phoneNumber intoDictionary:(NSMutableDictionary*)data;
+(void)call:(id)phoneNumber;
+(void)sms:(id)phoneNumber;

@end