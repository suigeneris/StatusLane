//
//  ReferAFriendInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 29/09/2015.
//  Copyright © 2015 Sui Generis Innovations. All rights reserved.
//

#import "ReferAFriendInteractor.h"

@interface ReferAFriendInteractor() <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@end

@implementation ReferAFriendInteractor


#pragma mark - MFMailComposeViewControllerDelegate

-(UIViewController *)returnMailViewController{
    
    NSString *emailTitle = @"Status Lane Invitation";
    NSString *messageBody = @"Insert invitation link here";    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    return mc;
    
}

-(UIViewController *)returnSMSViewController{
    
    NSString *messageBody = @"insert invitation link here";
    MFMessageComposeViewController *mc = [[MFMessageComposeViewController alloc] init];
    mc.messageComposeDelegate = self;
    mc.body = messageBody;
    return mc;
    
}

#pragma mark - Mail Composer View Controller Delegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");

            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self.presenter dismissMailComposer];

}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"sms cancelled");
            
            break;
        case MessageComposeResultFailed:
            NSLog(@"sms saved");
            break;
        case MessageComposeResultSent:
            NSLog(@"sms sent");
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self.presenter dismissMailComposer];
    
}


#pragma mark - FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
    NSLog(@"Did complete with results %@", results);
}


- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    
    
    NSLog(@"Did fail with results %@", error);
    
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    
    
    NSLog(@"Did cancel");
    
}

@end
