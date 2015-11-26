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
                                           
                                           //On successful anonymous user creation, we now set the newly created anonymous user as the partner of the current user
                                           [self setNewPartnerWithAnonymousUser:partner];

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
                                           
                                           //This indicateds we has successfully set the partner of the current user
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
    NSLog(@"This is the anonymoua partner id %@", anonymousUserPartner.objectId);
    NSLog(@"This is the main user  id %@", user.objectId);

    
    PFQuery *query = [PFQuery queryWithClassName:@"StatusHistory"];
    [query whereKey:@"historyId" equalTo:user.objectId];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"StatusHistory"];
    [query2 whereKey:@"historyId" equalTo:anonymousUserPartner.objectId];
    
    PFQuery *compoundQuery = [PFQuery orQueryWithSubqueries:@[query, query2]];
    [compoundQuery orderByDescending:@"statusDate"];
    [compoundQuery includeKey:@"StatusHistory.partnerId"];
    compoundQuery.limit = 20;
    
    [self.networkProvider queryDatabaseWithQuery:compoundQuery
                                         success:^(id responseObject) {
                                           
                                             NSArray *array = responseObject;
                                             if (array.count > 0) {
                                                 NSLog(@"THis is the response array %@", responseObject);
                                                 //User has a history, so send the end date of the last relationship
                                                 for (PFObject *object in array) {
                                                     
                                                     object[@"statusEndDate"] = [NSDate date];
                                                     [object saveInBackground];

                                                 }
                                                 
                                                 //Then create the new history
                                                 PFObject *statusHistoryObject = [PFObject objectWithClassName:@"StatusHistory"];
                                                 statusHistoryObject[@"historyId"] = user.objectId;
                                                 statusHistoryObject[@"fullName"] = user[@"fullName"];
                                                 statusHistoryObject[@"statusType"] = user[@"status"];
                                                 statusHistoryObject[@"statusDate"] = [NSDate date];
                                                 statusHistoryObject[@"partnerId"] = anonymousUserPartner.objectId;
                                                 statusHistoryObject[@"partnerName"] = partnerName;
                                                 [statusHistoryObject saveInBackground];
                                                 
                                                 PFObject *statusHistoryObject2 = [PFObject objectWithClassName:@"StatusHistory"];
                                                 statusHistoryObject2[@"historyId"] = anonymousUserPartner.objectId;
                                                 statusHistoryObject2[@"fullName"] = anonymousUserPartner[@"fullName"];
                                                 statusHistoryObject2[@"statusType"] = anonymousUserPartner[@"status"];
                                                 statusHistoryObject2[@"statusDate"] = [NSDate date];
                                                 statusHistoryObject2[@"partnerId"] = user.objectId;
                                                 statusHistoryObject2[@"partnerName"] = user[@"fullName"];
                                                 [statusHistoryObject2 saveInBackground];
                                                 
                                             }
                                             else{
                                                 
                                                 //User has no history so create history as normal
                                                 PFObject *statusHistoryObject = [PFObject objectWithClassName:@"StatusHistory"];
                                                 statusHistoryObject[@"historyId"] = user.objectId;
                                                 statusHistoryObject[@"fullName"] = user[@"fullName"];
                                                 statusHistoryObject[@"statusType"] = user[@"status"];
                                                 statusHistoryObject[@"statusDate"] = [NSDate date];
                                                 statusHistoryObject[@"partnerId"] = anonymousUserPartner.objectId;
                                                 statusHistoryObject[@"partnerName"] = partnerName;
                                                 [statusHistoryObject saveInBackground];
                                                 
                                                 PFObject *statusHistoryObject2 = [PFObject objectWithClassName:@"StatusHistory"];
                                                 statusHistoryObject2[@"historyId"] = anonymousUserPartner.objectId;
                                                 statusHistoryObject2[@"fullName"] = anonymousUserPartner[@"fullName"];
                                                 statusHistoryObject2[@"statusType"] = anonymousUserPartner[@"status"];
                                                 statusHistoryObject2[@"statusDate"] = [NSDate date];
                                                 statusHistoryObject2[@"partnerId"] = user.objectId;
                                                 statusHistoryObject2[@"partnerName"] = user[@"fullName"];
                                                 [statusHistoryObject2 saveInBackground];
                                             }
                                             
                                         } failure:^(NSError *error) {
                                             
                                         }];
    

}



@end
