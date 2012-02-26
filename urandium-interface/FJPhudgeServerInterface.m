//
//  FJPhudgeServerInterface.m
//  urandium-interface
//
//  Created by Engin Kurutepe on 2/26/12.
//  Copyright (c) 2012 Fifteen Jugglers Software. All rights reserved.
//

#import "FJPhudgeServerInterface.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "NSObject+SBJson.h"

static FJPhudgeServerInterface * __sharedInterface = nil;

@implementation FJPhudgeServerInterface

+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ;
}

+ (FJPhudgeServerInterface*) sharedInterface
{
    if (__sharedInterface == nil) {
        __sharedInterface = [[FJPhudgeServerInterface alloc] init];
    }
    
    return __sharedInterface;
}

- (void) getImageWithBlock:(FJImageAction)finished
{
    NSString * path = [SERVER_URL stringByAppendingString:@"/photo"];
    

    NSURL * url = [NSURL URLWithString:path];
    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:url];
    
    [request setCompletionBlock:^{
        NSString * response = request.responseString;
        
        NSDictionary * responseDict = [response JSONValue];
        
        NSString * imageUrlString = [responseDict valueForKey:@"url"];
        
        NSURL * imageURL = [NSURL URLWithString:imageUrlString];
        ASIHTTPRequest * imageReq = [[ASIHTTPRequest alloc] initWithURL:imageURL];
        
        [imageReq startSynchronous];
        
        if ([imageReq responseStatusCode] == 200) {
            NSData * imageData = [imageReq responseData];
            
            UIImage * image = [UIImage imageWithData:imageData];
            
            if (image) {
                finished(image);
            }
        }
        else {
            finished(nil);
        }
    }];
    
    [request setFailedBlock:^{
        NSLog(@"get photo failed");
        finished(nil);
    }];
    
    [request startAsynchronous];
}

- (void) uploadImage:(UIImage*)image withType:(NSString*)type andLocation:(CLLocation*)location
{
    NSString * path = [SERVER_URL stringByAppendingString:@"/photo"];
    
    
    NSURL * url = [NSURL URLWithString:path];
    ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    NSData * imageData = UIImageJPEGRepresentation(image, 0.8);
    
    NSString * base64String = [FJPhudgeServerInterface base64forData:imageData];
    
    [request setPostValue:base64String forKey:@"imageData"];
    
    if (location) {
        NSString * latLng = [NSString stringWithFormat:@"%f,%f", 
                             location.coordinate.latitude,
                             location.coordinate.longitude];
        
        [request setPostValue:latLng forKey:@"latLng"];
    }
    
    [request setPostValue:type forKey:@"type"];
    
    [request setCompletionBlock:^{
        NSLog(@"photo submitted successfully");
    }];
    
    [request setFailedBlock:^{
        NSLog(@"post photo failed");
    }];
    
    [request startAsynchronous];
}

@end
