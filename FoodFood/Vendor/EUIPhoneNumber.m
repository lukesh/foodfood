//
//  EUIPhoneNumber.m
//  Strine
//
//  Created by Jason Kichline on 12/22/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import "EUIPhoneNumber.h"
#import "EUIUtility.h"

@implementation EUIPhoneNumber

+(NSString*)formatPhoneNumber:(id)phoneNumberValue{
	return [EUIPhoneNumber formatPhoneNumber:phoneNumberValue withStyle:EUIPhoneNumberFormatStandard];
}

+(NSString*)formatPhoneNumber:(id)phoneNumberValue withStyle:(EUIPhoneNumberFormat)format{
	NSDictionary* phoneNumber;
	if([phoneNumberValue isKindOfClass:[NSDictionary class]]) {
		phoneNumber = phoneNumberValue;
	} else {
		phoneNumber = [EUIPhoneNumber phoneNumberToDictionary:phoneNumberValue];
	}
	
	NSMutableString* o = [[NSMutableString alloc] init];
	if([[phoneNumber objectForKey:@"isInternational"] boolValue]) {
		[o appendString: [NSString stringWithFormat:@"%@", [phoneNumber objectForKey:@"international"]]];
	} else {
		switch (format) {
			case EUIPhoneNumberFormatNone:{
				[o appendFormat:@"%@%@%@%@", 
				 [EUIUtility coalesce:[phoneNumber objectForKey:@"areacode"] with:@""], 
				 [EUIUtility coalesce:[phoneNumber objectForKey:@"phone1"] with:@""], 
				 [EUIUtility coalesce:[phoneNumber objectForKey:@"phone2"] with:@""], 
				 [EUIUtility coalesce:[phoneNumber objectForKey:@"extension"] with:@""]];
				break;
			}
			case EUIPhoneNumberFormatCallable:{
				if(![EUIUtility isBlank:[phoneNumber objectForKey:@"areacode"]]) {
					[o appendFormat:@"%@", [phoneNumber objectForKey:@"areacode"]];
				}
				if(![EUIUtility isBlank:[phoneNumber objectForKey:@"phone1"]]) {
					[o appendFormat:@"%@", [phoneNumber objectForKey:@"phone1"]];
				}
				if(![EUIUtility isBlank:[phoneNumber objectForKey:@"phone2"]]) {
					[o appendFormat:@"%@", [phoneNumber objectForKey:@"phone2"]];
				}
				if(![EUIUtility isBlank:[phoneNumber objectForKey:@"extension"]]) {
					[o appendFormat:@",%@", [phoneNumber objectForKey:@"extension"]];
				}
				break;
			}
			case EUIPhoneNumberFormatDashed:{
				if(![EUIUtility isBlank:[phoneNumber objectForKey:@"areacode"]]) {
					[o appendFormat:@"%@", [phoneNumber objectForKey:@"areacode"]];
				}
				if(![EUIUtility isBlank:[phoneNumber objectForKey:@"phone1"]]) {
					[o appendFormat:@"-%@", [phoneNumber objectForKey:@"phone1"]];
				}
				if(![EUIUtility isBlank:[phoneNumber objectForKey:@"phone2"]]) {
					[o appendFormat:@"-%@ ", [phoneNumber objectForKey:@"phone2"]];
				}
				if(![EUIUtility isBlank:[phoneNumber objectForKey:@"extension"]]) {
					[o appendFormat:@" %@", [phoneNumber objectForKey:@"extension"]];
				}
				break;
			}
			case EUIPhoneNumberFormatDotted:{
				if(![EUIUtility isBlank:[phoneNumber objectForKey:@"areacode"]]) {
					[o appendFormat:@"%@", [phoneNumber objectForKey:@"areacode"]];
				}
				if(![EUIUtility isBlank:[phoneNumber objectForKey:@"phone1"]]) {
					[o appendFormat:@".%@", [phoneNumber objectForKey:@"phone1"]];
				}
				if(![EUIUtility isBlank:[phoneNumber objectForKey:@"phone2"]]) {
					[o appendFormat:@".%@ ", [phoneNumber objectForKey:@"phone2"]];
				}
				if(![EUIUtility isBlank:[phoneNumber objectForKey:@"extension"]]) {
					[o appendFormat:@".%@", [phoneNumber objectForKey:@"extension"]];
				}
				break;
			}
			default:{
				if(![EUIUtility isBlank:[phoneNumber objectForKey:@"areacode"]]) {
					[o appendFormat:@"(%@) ", [phoneNumber objectForKey:@"areacode"]];
				}
				if(![EUIUtility isBlank:[phoneNumber objectForKey:@"phone1"]]) {
					[o appendFormat:@"%@", [phoneNumber objectForKey:@"phone1"]];
				}
				if(![EUIUtility isBlank:[phoneNumber objectForKey:@"phone2"]]) {
					[o appendFormat:@"-%@ ", [phoneNumber objectForKey:@"phone2"]];
				}
/*
				if(![EUIUtility isBlank:[phoneNumber objectForKey:@"extension"]]) {
					[o appendFormat:@" %@", [phoneNumber objectForKey:@"extension"]];
				}
*/
				break;
			}
		}
	}
	return [[o autorelease] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+(NSDictionary*)phoneNumberToDictionary:(id)phoneNumber{
	NSMutableDictionary* data = [NSMutableDictionary dictionary];
	[EUIPhoneNumber parsePhoneNumber:phoneNumber intoDictionary:data];
	return data;
}

+(void)parsePhoneNumber:(id)phoneNumber intoDictionary:(NSMutableDictionary*)data{
	NSString* phone;
	if([phoneNumber isKindOfClass:[NSDictionary class]]) {
		phone = [EUIPhoneNumber formatPhoneNumber:phoneNumber withStyle:EUIPhoneNumberFormatNone];
	} else {
		phone = [EUIPhoneNumber removeNonPhoneCharacters:phoneNumber];
	}

	[data setObject:[NSString stringWithFormat:@"%@", phoneNumber] forKey:@"international"];
	if([phone hasPrefix:@"+"]) {
		[data setObject:[NSNumber numberWithBool:YES] forKey:@"isInternational"];
	} else {
		if(phone.length >= 4) {
			[data setObject:[phone substringWithRange:NSMakeRange(phone.length-4, 4)] forKey:@"phone2"];
		}
		if(phone.length >= 7) {
			[data setObject:[phone substringWithRange:NSMakeRange(phone.length-7, 3)] forKey:@"phone1"];
		}
		if(phone.length >= 10) {
			[data setObject:[phone substringWithRange:NSMakeRange(phone.length-10, 3)] forKey:@"areacode"];
		}
		if(phone.length > 10) {
			[data setObject:[phone substringFromIndex:10] forKey:@"extension"];
		}
	}
}
				  
+(NSString*)removeNonPhoneCharacters:(NSString*)phoneNumber{
	NSMutableString* strippedString = [NSMutableString stringWithCapacity:phoneNumber.length];
	for (int i=0; i<[phoneNumber length]; i++) {
        if (isdigit([phoneNumber characterAtIndex:i])) {
			[strippedString appendFormat:@"%c",[phoneNumber characterAtIndex:i]];
        }
	}
	return strippedString;
}

+(void)call:(id)phoneNumber{
	NSURL* url;
	if ([phoneNumber isKindOfClass:[NSDictionary class]]) {
		NSString* phone = [EUIPhoneNumber formatPhoneNumber:phoneNumber withStyle:EUIPhoneNumberFormatCallable];
		url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]];
	} else {
		url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [NSString stringWithFormat:@"%@", phoneNumber]]];
	}
	[[UIApplication sharedApplication] openURL:url];
}

+(void)sms:(id)phoneNumber{
	NSURL* url;
	if ([phoneNumber isKindOfClass:[NSDictionary class]]) {
		NSString* phone = [EUIPhoneNumber formatPhoneNumber:phoneNumber withStyle:EUIPhoneNumberFormatCallable];
		url = [NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", phone]];
	} else {
		url = [NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", [NSString stringWithFormat:@"%@", phoneNumber]]];
	}
	[[UIApplication sharedApplication] openURL:url];
}

@end
