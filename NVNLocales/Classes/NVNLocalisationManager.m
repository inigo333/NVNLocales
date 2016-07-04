//
//  NVNLocalisationManager.m
//  Pods
//
//  Created by Inigo Mato on 01/07/2016.
//
//

#import "NVNLocalisationManager.h"

#define MIMLanguageDictionaryKey @"MIMLanguageDictionary"
#define MIMLanguageIdentifierKey @"MIMLanguageIdentifier"


static NSMutableDictionary *_missingTranslations;

/////////////////////////////////////////////////
#pragma mark - Interface
/////////////////////////////////////////////////
@interface NVNLocalisationManager ()

@end

/////////////////////////////////////////////////
#pragma mark - Implementation
/////////////////////////////////////////////////

@implementation NVNLocalisationManager

//SINGLETON_GCD(NVNLocalisationManager);

+ (instancetype)sharedInstance
{
    static NVNLocalisationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        sharedInstance = [[NVNLocalisationManager alloc] init];
    });
    return sharedInstance;
}

/////////////////////////////////////////////////
#pragma mark - language Setup
/////////////////////////////////////////////////
- (void)languageSetup
{
    [self updateLanguageIdentifier:[self languageIdentifierPreferred]];
}

- (NSString *)languageIdentifierPreferred
{
    //Check if we have a language already chosen in the app settings
    NSString *languageIdentifier = [self languageIdentifierStored];
    
    //If not, take the device language
    if (!languageIdentifier)
    {
        languageIdentifier = [[NSLocale preferredLanguages] objectAtIndex:0];
    }
    
    //If we don't support the device language, then we go to default language: English
    NSString *languageJSONFileName = [languageIdentifier stringByAppendingString:@".json"];
    if(![[self allJSONFileNamesArray] containsObject: languageJSONFileName])
    {
        languageIdentifier = @"en";
    }
    
    return languageIdentifier;
}

- (NSString *)languageIdentifierStored
{
    NSString *languageIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:MIMLanguageIdentifierKey];
    
    return languageIdentifier;
}

- (NSDictionary *)languageDictionaryStored
{
    NSDictionary *languageDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:MIMLanguageDictionaryKey];
    
    return languageDictionary;
}

- (NSArray *)allJSONFileNamesArray
{
    NSArray *array = [self allFileNamesArray];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH[cd] '.json'"];
    NSArray *allJSONFileNamesArray = [array filteredArrayUsingPredicate:predicate];
    
    return allJSONFileNamesArray;
}

- (NSArray *)allFileNamesArray
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *directoryAndFileNames = [fm contentsOfDirectoryAtPath:path
                                                             error:&error];
    
    return directoryAndFileNames;
}

- (void)updateLanguageIdentifier:(NSString *)languageIdentifier
               completionHandler:(void (^)(void))block
{
    //We save the language identifier for next session
    [self saveObject:languageIdentifier forKey:MIMLanguageIdentifierKey];
    self.languageIdentifier = languageIdentifier;
    [self updateDictionaryWithLanguageIdentifier:languageIdentifier];
    
//#warning: hardcoded API call
    NSString *callUrlString = [NSString stringWithFormat: @"https://privatejet.aerofi.com/api/gettextstrings?language=%@&company_identifier=pA3zw2BYJZB6uBvuUVDAGNJXR2zytikeXWWmQy5vBsf7yZt4Al7uGxodr30kMm&os_name=iOS&app_type=FULL&module_ver=0.1&app_ver=1.0&access_uid=1D0B880E-8213-4E42-913E-7EF644C60F6B", languageIdentifier];
    
    NSURL *url = [NSURL URLWithString:callUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    __block typeof (self) weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error)
     {
         if(data && !error)
         {
             NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:kNilOptions
                                                                            error:&error];
             
             if([[jsonResponse objectForKey:@"result"] boolValue] == true)
             {
                 NSDictionary *languageDictionary = [jsonResponse valueForKeyPath:@"data.text_strings"];
                 [self saveObject:languageDictionary forKey:MIMLanguageDictionaryKey];
                 weakSelf.languageDictionary = languageDictionary;
             }
         }
         else
         {
             NSLog(@"MIMLocalisationManager connection error: %@", error);
         }
         
         if (block)
         {
             block();
         }
     }];
}

- (void)updateLanguageIdentifier:(NSString *)languageIdentifier
{
    [self updateLanguageIdentifier:languageIdentifier
                 completionHandler:nil];
}

- (void)updateDictionaryWithLanguageIdentifier:(NSString *)languageIdentifier
{
    //We save the language dictionary for next session
    NSString *filePath = [[NSBundle mainBundle] pathForResource:languageIdentifier
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    if (data)
    {
        NSDictionary *languageDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
        [self saveObject:languageDictionary forKey:MIMLanguageDictionaryKey];
        self.languageDictionary = languageDictionary;
    }
}

- (void)saveObject:(id)objectToSave forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:objectToSave forKey:key];
}

/////////////////////////////////////////////////
#pragma mark - Translation
/////////////////////////////////////////////////
NSString *MIMTranslate(NSString *defaultString)
{
    NSString *translatedString = [[NVNLocalisationManager sharedInstance] languageValueForKeyPath:defaultString];
    
    if (!translatedString || ![translatedString isKindOfClass:[NSString class]])
    {
        MIMRecordMissingTranslation(defaultString);
        translatedString = defaultString;
    }
    
    return translatedString;
}

- (id)languageValueForKeyPath:(NSString *)key
{
    return [self.languageDictionary valueForKeyPath:key];
}

void MIMRecordMissingTranslation(NSString *defaultString)
{
    //We must keep track of missing translations in order to create them afterwards
    if (!_missingTranslations)
    {
        _missingTranslations = [NSMutableDictionary dictionary];
    }
    
    [_missingTranslations setValue:defaultString forKeyPath:defaultString];
}

+ (NSDictionary *)missingTranslations
{
    return _missingTranslations;
}

@end
