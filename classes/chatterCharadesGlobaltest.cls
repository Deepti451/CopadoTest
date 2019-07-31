@IsTest
public class chatterCharadesGlobaltest{
     public static testmethod void testchater(){
    Profile testProfile = [SELECT Id 
                           FROM profile
                           WHERE Name = 'System Administrator' 
                           LIMIT 1];
     User usr = new User();
    
     usr.LastName = 'test user 1'; 
     usr.Username = 'test.user.1@example.com'; 
     usr.Email = 'test.1@example.com'; 
     usr.Alias = 'testu1';
     usr.TimeZoneSidKey = 'GMT'; 
     usr.ProfileId = testProfile.Id; 
     usr.LocaleSidKey= 'en_US';
     usr.TimeZoneSidKey = 'America/Denver';
     usr.EmailEncodingKey  = 'UTF-8';
     usr.LanguageLocaleKey = 'en_US';
                   
     insert usr;                    
                             
                            
        }
        }