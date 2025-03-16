/**
 * @description       : Opportunity Trigger Handler
 * @author            : Shahrukh Ahmed
 * @last modified on  : 16-03-2025
 * @last modified by  : Shahrukh Ahmed
 **/
public with sharing class OpportunityTriggerHandler extends TriggerHandler {
  public override void beforeInsert() {
    try {
      Set<Id> ownerIds = new Set<Id>();
      for (Opportunity opp : (List<Opportunity>) Trigger.new) {
        ownerIds.add(opp.OwnerId);
      }

      Set<Id> salesTeamUserIds = OpportunityValidationUtility.getSalesTeamUserIds(
        ownerIds
      );
      Map<Id, List<Opportunity>> ownerToOpps = OpportunityValidationUtility.groupOpportunitiesByOwner(
        Trigger.new,
        salesTeamUserIds
      );

      if (!ownerToOpps.isEmpty()) {
        Map<Id, Opportunity> existingOpenOpps = OpportunityValidationUtility.getExistingOpenOpportunities(
          ownerToOpps.keySet()
        );
        OpportunityValidationUtility.addOpportunityErrors(
          existingOpenOpps,
          ownerToOpps
        );
      }
    } catch (Exception e) {
      handleException(e, 'beforeInsert');
    }
  }

  public override void beforeUpdate() {
    try {
      List<Opportunity> newList = (List<Opportunity>) Trigger.new;
      Map<Id, Opportunity> oldMap = (Map<Id, Opportunity>) Trigger.oldMap;

      Set<Id> ownerIds = new Set<Id>();
      for (Opportunity opp : newList) {
        Opportunity oldOpp = oldMap.get(opp.Id);
        if (opp.OwnerId != oldOpp.OwnerId) {
          ownerIds.add(opp.OwnerId);
        }
      }

      Set<Id> salesTeamUserIds = OpportunityValidationUtility.getSalesTeamUserIds(
        ownerIds
      );
      Map<Id, List<Opportunity>> ownerToOpps = OpportunityValidationUtility.groupOpportunitiesByOwner(
        newList,
        salesTeamUserIds
      );

      if (!ownerToOpps.isEmpty()) {
        Map<Id, Opportunity> existingOpenOpps = OpportunityValidationUtility.getExistingOpenOpportunities(
          ownerToOpps.keySet()
        );
        OpportunityValidationUtility.addOpportunityErrors(
          existingOpenOpps,
          ownerToOpps
        );
      }
    } catch (Exception e) {
      handleException(e, 'beforeUpdate');
    }
  }

  private void handleException(Exception e, String context) {
    System.debug(
      'Critical error in ' +
        context +
        ': ' +
        e.getMessage() +
        '\nStack Trace: ' +
        e.getStackTraceString()
    );
    throw new OpportunityTriggerException(
      'System error during Opportunity validation'
    );
  }

  public class OpportunityTriggerException extends Exception {
  }
}
