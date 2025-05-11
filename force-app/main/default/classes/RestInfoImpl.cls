@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class RestInfoImpl implements RestService {
  String accountId { get; set; }
  String name { get; set; }
  List<OpportunityWrapper> opportunities { get; set; }

  public RestInfoImpl(Account account) {
    setGetResponse(account);
  }
  void setGetResponse(Account account) {
    this.accountId = account.Id;
    this.name = account.Name;
    this.opportunities = new List<OpportunityWrapper>();
    for (Opportunity opp : account.Opportunities__r) {
      OpportunityWrapper opportunityWrapper = new OpportunityWrapper();
      opportunityWrapper.oppId = opp.Id;
      opportunityWrapper.oppName = opp.Name;
      this.opportunities.add(opportunityWrapper);
    }
  }
  public String get() {
    return JSON.serialize(this);
  }
  public void post() {
    return;
  }
  public void patch() {
    Account account = [
      SELECT Id, Name
      FROM Account
      WHERE Id = :accountId
      LIMIT 1
    ];
    Map<Id, Opportunity> opps = new Map<Id, Opportunity>(
      [SELECT Id, Name FROM Opportunity WHERE AccountId = :accountId]
    );
    for (OpportunityWrapper opp : this.opportunities) {
      opps.get(opp.oppId).Name = opp.oppName;
    }
    account.Name = this.name;
    update account;
    update opps.values();
    return;
  }

  public void deleteRecords() {
    return;
  }
  public String getId() {
    return String.valueOf(account.Id);
  }

  class OpportunityWrapper {
    String oppName { get; set; }
    String oppId { get; set; }
  }
}
