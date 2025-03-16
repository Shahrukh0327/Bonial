/**
 * @description       : Opportunity Validation Utility
 * @author            : Shahrukh Ahmed
 * @last modified on  : 16-03-2025
 * @last modified by  : Shahrukh Ahmed
 **/
public with sharing class OpportunityValidationUtility {
  public static final String OPPORTUNITY_STAGENAME_CLOSED_WON = 'Closed Won';
  public static final String OPPORTUNITY_STAGENAME_CLOSED_LOST = 'Closed Lost';

  public static final String PERMISSIONSET_SALES_TEAM_MEMEBER = 'Sales_Team_Member';

  /**
   * Retrieves Sales Team User IDs based on Permission Set assignments.
   * @param ownerIds Set of User IDs to check.
   * @return Set of User IDs who are Sales Team Members.
   */
  public static Set<Id> getSalesTeamUserIds(Set<Id> ownerIds) {
    Set<Id> salesTeamUserIds = new Set<Id>();
    if (ownerIds.isEmpty())
      return salesTeamUserIds;

    for (PermissionSetAssignment psa : [
      SELECT AssigneeId
      FROM PermissionSetAssignment
      WHERE
        PermissionSet.Name = :OpportunityValidationUtility.PERMISSIONSET_SALES_TEAM_MEMEBER
        AND AssigneeId IN :ownerIds
    ]) {
      salesTeamUserIds.add(psa.AssigneeId);
    }
    return salesTeamUserIds;
  }

  /**
   * Groups Opportunities by OwnerId if they belong to Sales Team Members.
   * @param opportunities List of Opportunities to group.
   * @param salesTeamUserIds Set of Sales Team User IDs.
   * @return Map of OwnerId to list of their Opportunities.
   */
  public static Map<Id, List<Opportunity>> groupOpportunitiesByOwner(
    List<Opportunity> opportunities,
    Set<Id> salesTeamUserIds
  ) {
    Map<Id, List<Opportunity>> ownerToOpps = new Map<Id, List<Opportunity>>();
    for (Opportunity opp : opportunities) {
      if (salesTeamUserIds.contains(opp.OwnerId)) {
        if (!ownerToOpps.containsKey(opp.OwnerId)) {
          ownerToOpps.put(opp.OwnerId, new List<Opportunity>());
        }
        ownerToOpps.get(opp.OwnerId).add(opp);
      }
    }
    return ownerToOpps;
  }

  /**
   * Queries existing open Opportunities for the given Owners in the current week.
   * @param ownerIds Set of Owner IDs to check.
   * @return Map of OwnerId to the latest open Opportunity.
   */
  public static Map<Id, Opportunity> getExistingOpenOpportunities(
    Set<Id> ownerIds
  ) {
    if (ownerIds.isEmpty())
      return new Map<Id, Opportunity>();

    Date weekStart = Date.today().toStartOfWeek();
    Date weekEnd = weekStart.addDays(6);
    Map<Id, Opportunity> existingOpenOpps = new Map<Id, Opportunity>();

    Set<String> stageNames = new Set<String>{
      OPPORTUNITY_STAGENAME_CLOSED_WON,
      OPPORTUNITY_STAGENAME_CLOSED_LOST
    };

    List<Opportunity> existingOpps = [
      SELECT Id, OwnerId, Name, StageName
      FROM Opportunity
      WHERE
        OwnerId IN :ownerIds
        AND CreatedDate >= :weekStart
        AND CreatedDate <= :weekEnd
        AND StageName NOT IN :stageNames
      ORDER BY CreatedDate DESC
    ];

    for (Opportunity opp : existingOpps) {
      if (!existingOpenOpps.containsKey(opp.OwnerId)) {
        existingOpenOpps.put(opp.OwnerId, opp);
      }
    }
    return existingOpenOpps;
  }

  /**
   * Adds validation errors to Opportunities if existing open ones are found.
   * @param existingOpenOpps Map of existing open Opportunities by OwnerId.
   * @param ownerToOpps Map of OwnerId to their new/updated Opportunities.
   */
  public static void addOpportunityErrors(
    Map<Id, Opportunity> existingOpenOpps,
    Map<Id, List<Opportunity>> ownerToOpps
  ) {
    for (Id ownerId : ownerToOpps.keySet()) {
      Opportunity existingOpp = existingOpenOpps.get(ownerId);
      if (existingOpp != null) {
        String fullRecordURL =
          URL.getOrgDomainURL().toExternalForm() +
          '/' +
          existingOpp.Id;
        String errorMsg =
          'Sales Team Members can only have one Opportunity per week. ' +
          'Close this existing Opportunity first. ' +
          'Opportunity record: ' +
          fullRecordURL;
        for (Opportunity opp : ownerToOpps.get(ownerId)) {
          opp.addError(errorMsg, true);
        }
      }
    }
  }
}
