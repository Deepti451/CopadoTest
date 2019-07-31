@IsTest
public class chatterAssassin2test{
     public static testmethod void test2(){
     
      account acc = new account();
      acc.name = 'test';
      insert acc;
     
     FeedItem fi = new FeedItem();
     fi.Body = 'legal test';
     fi.ParentId = acc.id;
     insert fi;
     
     FeedComment fc = new FeedComment();
     fc.CommentBody ='test';
     fc.FeedItemId =fi.id;
     insert fc;
     
     chatterAssassin2  ca = new chatterAssassin2();
     //ca.delPost();
     //ca.delComment();
     ca.postID = 'testw';
     
     
     }
   }