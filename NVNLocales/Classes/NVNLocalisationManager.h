//
//  NVNLocalisationManager.h
//  Pods
//
//  Created by Inigo Mato on 01/07/2016.
//
//

#import <Foundation/Foundation.h>

@interface NVNLocalisationManager : NSObject

@property (nonatomic, strong) NSString *languageIdentifier;
@property (nonatomic, strong) NSDictionary *languageDictionary;
@property (nonatomic, strong) NSMutableDictionary *missingTranslations;

+ (NVNLocalisationManager *)sharedInstance;

+ (NSDictionary *)missingTranslations;

- (void)languageSetup;
- (NSString *)languageIdentifierPreferred;
- (NSString *)languageIdentifierStored;
- (void)updateLanguageIdentifier:(NSString *)languageIdentifier;
- (void)updateLanguageIdentifier:(NSString *)languageIdentifier
               completionHandler:(void (^)(void))block;
- (NSArray *)allJSONFileNamesArray;

NSString *MIMTranslate(NSString *defaultString);

@end
