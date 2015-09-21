//
//  AnonymousUserInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 27/07/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "AnonymousUserInteractor.h"
#import "ChoosePartnerPresenter.h"
#import "NetworkManager.h"
#import "Defaults.h"

@interface AnonymousUserInteractor(){
    
    NSString *partnerStatus;
    NSString *partnerName;
}

@property (nonatomic, strong) id <NetworkProvider> networkProvider;

@end


@implementation AnonymousUserInteractor

-(id<NetworkProvider>)networkProvider{
    
    if (!_networkProvider) {
        
        _networkProvider = [NetworkManager new];
    }
    return _networkProvider;
}



-(void)searchAnonymousUserWithUsername:(NSString *)username andfullName:(NSString *)fullName andStatus:(NSString *)status{
    
    //Search database for anonymous user using the arguments passed in
    //This is method is called from the choose partner interactor class
    
    partnerStatus = status;
    partnerName = fullName;
    
    PFQuery *query = [PFQuery queryWithClassName:@"AnonymousUser"];
    [query whereKey:@"username" equalTo:username];
    
    [self.networkProvider queryDatabaseWithQuery:query
                                         success:^(id responseObject) {
                                             
                                             NSLog(@"This is the response object : %@", responseObject);
                                             NSArray *array = responseObject;
                                             if (array.count == 0) {
                                                 
                                                 //If the array has no objects, that means there is no anonymous user matching the credentials so Create a new annonymous user
                                                 [self createAnonymouseUserWithUsername:username fullName:fullName andStatus:status];
                                                 
                                             }
                                             else{
                                                 
                                                 //If the array has an object (Anonymous user), then we check the status of the anonymous user
                                                 PFObject *object = [array objectAtIndex:0];
                                                 
                                                 if ([object[@"status"] isEqualToString:@"SINGLE"]) {
                                                     
                                                     //If the status of this user is single then we set the anonymous user as the partner with the user
                                                     if ([[Defaults status] isEqualToString:@"SINGLE"]) {
                                                         
                                                         [self setNewPartnerWithAnonymousUser:object];

                                                     }
                                                     else{
                                                         
                                                         [self removePreviousPartner:object];

                                                     }

                                                     
                                                 }
                                                 
                                                 else if ([[[PFUser currentUser] objectId] isEqualToString:[self determinePartnerOfAnonymousUser:object]]){
                                                     
                                                     //This condition is meet if current user already has some relationship with the anonymous user, if so then we do the same as above
                                                     [self setNewPartnerWithAnonymousUser:object];
                                                     
                                                 }
                                                 
                                                 else{
                                                     
                                                     //Otherwise we say this user has some sort of relationship with someone else
                                                     [self.presenter stopAnimatingActivitiyView];
                                                     [self.presenter showErrorView:@"This user is in a relationship with someone else"];
                                                     
                                                 }
                                             }
                                             
                                             
                                         }failure:^(NSError *error) {
                                             
                                             [self.presenter stopAnimatingActivitiyView];
                                             [self.presenter showErrorView:error.localizedDescription];
                                             
                                         }];
    
    
}


-(void)createAnonymouseUserWithUsername:(NSString *)username fullName:(NSString *)fullname andStatus:(NSString *)status{
    
    //Here we want to create a new anonymous user and set the current user as the partner of the anonymous user.
    
    PFObject *partner = [PFObject objectWithClassName:@"AnonymousUser"];
    partner[@"username"] = username;
    partner[@"fullName"] = fullname;
    partner[@"status"] = status;
    
    PFUser *currentUser = [PFUser currentUser];
    NSArray *partnerArray = @[currentUser];
    [partner setObject:partnerArray forKey:@"partner"];
    
    [self.networkProvider saveWithPFObject:partner
                                   success:^(id responseObject) {
                                       
                                       NSNumber *number = responseObject;
                                       BOOL success = [number boolValue];
                                       if (success) {
                                           
                                           //On successful anonymous user creation, we now have to remove the previous partner of the current user and set the previous partner to single
                                           [self removePreviousPartner:partner];
                                           
                                       }
                                       
                                       else{
                                           
                                           [self.presenter stopAnimatingActivitiyView];
                                           [self.presenter showErrorView:@"Could Not Save At This Time Please Try Again Later"];
                                       }
                                       
                                   } failure:^(NSError *error) {
                                       
                                       [self.presenter stopAnimatingActivitiyView];
                                       [self.presenter showErrorView:error.localizedDescription];
                                       
                                       
                                   }];
    
    
}

-(void)removePreviousPartner:(PFObject *)partner{
    
    //We need to remove the currrent partner of the current user in order to update the anonymous user as the new partner.
    PFUser *currentUser = [PFUser currentUser];
    NSArray *arrayWithPreviousUser = currentUser[@"partner"];
    
    if (arrayWithPreviousUser) {
        
        //We need to determine if the current partner is a user or anonymous user.
        if (![[arrayWithPreviousUser objectAtIndex:0] isKindOfClass:NSClassFromString(@"PFUser")]) {
            
            //If the user is an anonymous user, we simply update the user accordningly and save
            PFObject *previousPartner = [arrayWithPreviousUser objectAtIndex:0];
            previousPartner[@"status"] = @"SINGLE";
            [previousPartner removeObjectForKey:@"partner"];
            
            [self.networkProvider saveWithPFObject:previousPartner
                                           success:^(id responseObject) {
                                               
                                               //Once saved successfully, we now set the new partner on the current user.
                                               [self setNewPartnerWithAnonymousUser:partner];
                                               
                                           } failure:^(NSError *error) {
                                               
                                               [self.presenter stopAnimatingActivitiyView];
                                               [self.presenter showErrorView:error.localizedDescription];

                                           }];

        }
        
        //This is called if the current partner is actually a user.
        else{
            
            NSLog(@"array contains pfuser");
            NSLog(@"Is a user");
            //TODO
        }
    }
    
    else{
        
        //This is called if the user has no partner at this time. Therefore just set the new partner on the current user.
        [self setNewPartnerWithAnonymousUser:partner];
        
    }
    
}

-(void)setNewPartnerWithAnonymousUser:(PFObject *)anonymousUser{
    
    //This is where we set the anonymous user as the current partner of the current user. and we also have to set the current user as the partner of the anonymous user since this is a 2 way relationship
    //But  we do it one after the other for now.
    
    anonymousUser[@"status"] = partnerStatus;
    NSArray *partnerArray = @[anonymousUser];
    
    PFUser *currentUser = [PFUser currentUser];
    NSArray *partnerArray2 = @[currentUser];
    currentUser[@"status"] = partnerStatus;
    [currentUser setObject:partnerArray forKey:@"partner"];
    [anonymousUser setObject:partnerArray2 forKey:@"partner"];
    
    [self.networkProvider saveWithPFObject:currentUser
                                   success:^(id responseObject) {
                                       
                                       NSNumber *number = responseObject;
                                       BOOL success = [number boolValue];
                                       if (success) {
                                           
                                           //This indicateds we has successfully set the partner of the current user, next we set the current user as the partner of the current partner
                                           [self setPartnerOnAnonymousUser:anonymousUser];
                                           [self updateStatusHistoryForUser:currentUser usingAnonymousUserAsPartner:anonymousUser];
                                       }
                                       
                                       else{
                                           
                                           
                                           [self.presenter stopAnimatingActivitiyView];
                                           [self.presenter showErrorView:@"Could Not Save At This Time Please Try Again Later"];

                                       }
                                       
                                   } failure:^(NSError *error) {
                                       
                                       [self.presenter stopAnimatingActivitiyView];
                                       [self.presenter showErrorView:error.localizedDescription];
                                       
                                   }];
    
}

-(void)setPartnerOnAnonymousUser:(PFObject *)anonymousObject{
    
    //Here we set the partner of the current partner as the current user. this balances out the relaionship between the 2 objects.
    [self.networkProvider saveWithPFObject:anonymousObject
                                   success:^(id responseObject) {
                                       
                                       [Defaults setPartnerFullName:partnerName];
                                       [Defaults setStatus:partnerStatus];
                                       [self.presenter stopAnimatingActivitiyView];
                                       [self.presenter dismissView];
                                       
                                   } failure:^(NSError *error) {

                                       [self.presenter stopAnimatingActivitiyView];
                                       [self.presenter showErrorView:error.localizedDescription];
                                       
                                   }];
}

-(void)updateStatusHistoryForUser:(PFUser  *)user usingAnonymousUserAsPartner:(PFObject*)anonymousUserPartner{
    
    PFQuery *query = [PFQuery queryWithClassName:@"StatusHistory"];
    [query whereKey:@"historyId" equalTo:user.objectId];
    [query orderByDescending:@"statusDate"];
    
    [self.networkProvider queryDatabaseWithQuery:query
                                         success:^(id responseObject) {
                                           
                                             NSArray *array = responseObject;
                                             if (array.count > 0) {
                                                 //User has a history, so send the end date of the last relationship
                                                 PFObject *object = [array objectAtIndex:0];
                                                 object[@"statusEndDate"] = [NSDate date];
                                                 [object saveInBackground];
                                                 
                                                 //Then create the new history
                                                 PFObject *statusHistoryObject = [PFObject objectWithClassName:@"StatusHistory"];
                                                 statusHistoryObject[@"historyId"] = user.objectId;
                                                 statusHistoryObject[@"statusType"] = user[@"status"];
                                                 statusHistoryObject[@"statusDate"] = [NSDate date];
                                                 statusHistoryObject[@"partnerId"] = anonymousUserPartner.objectId;
                                                 statusHistoryObject[@"partnerName"] = partnerName;
                                                 [statusHistoryObject saveInBackground];
                                                 
                                             }
                                             else{
                                                 
                                                 //User has no history so create history as normal
                                                 PFObject *statusHistoryObject = [PFObject objectWithClassName:@"StatusHistory"];
                                                 statusHistoryObject[@"historyId"] = user.objectId;
                                                 statusHistoryObject[@"statusType"] = user[@"status"];
                                                 statusHistoryObject[@"statusDate"] = [NSDate date];
                                                 statusHistoryObject[@"partnerId"] = anonymousUserPartner.objectId;
                                                 statusHistoryObject[@"partnerName"] = partnerName;
                                                 [statusHistoryObject saveInBackground];
                                             }
                                             
                                         } failure:^(NSError *error) {
                                             
                                         }];
    

}



-(NSString *)determinePartnerOfAnonymousUser:(PFObject *)anonymouseUser{
    
    NSArray *partner = anonymouseUser[@"partner"];
    
    if (partner.count == 0) {
        //no partner
        return @"No partner";
    }
    else{
        
        PFUser *userPartner = [partner objectAtIndex:0];
        return [userPartner objectId];
        
    }
}


@end
