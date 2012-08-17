@RestResource(urlMapping='/Account/*')
global with sharing class AccountResource {

  @HttpDelete
  global static void doDelete() {
      RestRequest req = RestContext.request;
      RestResponse res = RestContext.response;
      String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
      Account account = [SELECT Id FROM Account WHERE Id = :accountId];
      delete account;
  }

  @HttpGet
  global static List<Account> doGet() {
      RestRequest req = RestContext.request;
      RestResponse res = RestContext.response;
      String regex = '/Account/(.+)$';
      Matcher m = Pattern.compile(regex).matcher(req.requestURI);
      if(m.matches()) {
          String accountId = m.group(1);
          List<Account> result = [SELECT Id, Name, Phone, Website FROM Account WHERE Id = :accountId];
          return result;
      }
      else {
          List<Account> accounts = [SELECT Id, Name, Phone, Website from Account];
          return accounts;
      }
  }

  @HttpPost
  global static Account doPost(String name, String phone, String website) {
      Account account = new Account();
      account.name = name;
      account.phone = phone;
      account.website = website;
      insert account;
      return account;
  }

  @HttpPut
  global static Account doPut(String name, String phone, String website) {
      RestRequest req = RestContext.request;
      RestResponse res = RestContext.response;
      String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
      Account account = [SELECT Id, Name, Phone, Website  FROM Account WHERE Id = :accountId LIMIT 1];
      account.name = name;
      account.phone = phone;
      account.website = website;
      update account;
      return account;
  }
}
