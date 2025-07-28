/**
 * @description       : Trigger Handler
 * @author            : Shahrukh Ahmed
 * @last modified on  : 16-03-2025
 * @last modified by  : Shahrukh Ahmed
 **/
public virtual class TriggerHandler {
  @TestVisible
  private static final String HANDLER_OUTSIDE_TRIGGER_MESSAGE = 'Trigger handler called outside of Trigger execution';

  @TestVisible
  private TriggerContext context;

  @TestVisible
  private Boolean isTriggerExecuting;

  public void run() {
    if (!validateRun()) {
      return;
    }
    switch on this.context {
      when BEFORE_INSERT {
        this.beforeInsert();
      }
      when BEFORE_UPDATE {
        this.beforeUpdate();
      }
    }
  }

  public TriggerHandler() {
    this.setTriggerContext();
  }

  protected virtual void beforeInsert() {
  }
  protected virtual void beforeUpdate() {
  }

  private Boolean validateRun() {
    if (!this.isTriggerExecuting) {
      throw new TriggerBaseException(HANDLER_OUTSIDE_TRIGGER_MESSAGE);
    }
    return true;
  }

  @TestVisible
  private void setTriggerContext() {
    this.setTriggerContext(null, false);
  }

  @TestVisible
  private void setTriggerContext(String ctx, Boolean testMode) {
    if (!Trigger.isExecuting && !testMode) {
      this.isTriggerExecuting = false;
      return;
    } else {
      this.isTriggerExecuting = true;
    }

    if (
      (Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) ||
      (ctx != null &&
      ctx == 'before insert')
    ) {
      this.context = TriggerContext.BEFORE_INSERT;
    } else if (
      (Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) ||
      (ctx != null &&
      ctx == 'before update')
    ) {
      this.context = TriggerContext.BEFORE_UPDATE;
    }
  }

  @TestVisible
  private enum TriggerContext {
    BEFORE_INSERT,
    BEFORE_UPDATE
  }

  public class TriggerBaseException extends Exception {
  }
}
