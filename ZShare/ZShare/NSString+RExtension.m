//
//  NSString+RExtension.m
//  RTUsefulExtension
//
//  Created by ricky on 13-4-27.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import "NSString+RExtension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (RExtension)

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

- (NSData*)base64DecodedData
{
    unsigned long ixtext, lentext;
    uint8_t ch, inbuf[4], outbuf[3];
    short i, ixinbuf;
    BOOL flignore, flendtext = false;
    const uint8_t *tempcstring;
    NSMutableData *theData;
    
    tempcstring = (const uint8_t *)[self UTF8String];
    
    lentext = [self length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    for (ixtext = 0; ixtext < lentext; ixtext++) {
        ch = tempcstring [ixtext];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z'))
        {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z'))
        {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9'))
        {
            ch = ch - '0' + 52;
        }
        else if (ch == '+')
        {
            ch = 62;
        }
        else if (ch == '/')
        {
            ch = 63;
        }
        else if (ch == '=')
        {
            flendtext = true;
        }
        else
        {
            flignore = true;
        }
        
        if (!flignore)
        {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext)
            {
                if (ixinbuf == 0)
                {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2))
                {
                    ctcharsinbuf = 1;
                }
                else
                {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4)
            {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++)
                {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak)
            {
                break;
            }
        }
    }
    
    return theData;
}

+ (NSString*) uniqueString
{
	CFUUIDRef uuidObj = CFUUIDCreate(nil);
	NSString *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	return uuidString;
}

+ (NSString*)documentsPath
{
    static NSString *documentsPath = nil;
    if (documentsPath)
        return documentsPath;
    
    NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsPath = [[pathes objectAtIndex:0] retain];
    return documentsPath;
}

+ (NSString*)libraryPath
{
    static NSString *libraryPath = nil;
    if (libraryPath)
        return libraryPath;
    
    NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    libraryPath = [[pathes objectAtIndex:0] retain];
    return libraryPath;
}

+ (NSString*)cachePath
{
    static NSString *cachePath = nil;
    if (cachePath)
        return cachePath;
    
    NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    cachePath = [[pathes objectAtIndex:0] retain];
    return cachePath;
}

+ (NSString*)downloadPath
{
    static NSString *downloadPath = nil;
    if (downloadPath)
        return downloadPath;
    
    NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
    downloadPath = [[pathes objectAtIndex:0] retain];
    return downloadPath;
}

+ (NSString*)tmpPath
{
    return NSTemporaryDirectory();
}

@end
