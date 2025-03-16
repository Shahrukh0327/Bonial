/**
 * @description       :
 * @author            : Shahrukh Ahmed
 * @last modified on  : 16-03-2025
 * @last modified by  : Shahrukh Ahmed
 **/
trigger OpportunityTrigger on Opportunity(
  before insert,
  after insert,
  before update,
  after update,
  before delete,
  after delete,
  after undelete
) {
  new OpportunityTriggerHandler().run();
}
