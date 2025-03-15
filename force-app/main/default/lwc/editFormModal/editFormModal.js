/**
 * @description       : 
 * @author            : Shahrukh Ahmed 
 * @last modified on  : 15-03-2025
 * @last modified by  : Shahrukh Ahmed 
**/
import { LightningElement, api } from 'lwc';

export default class EditFormModal extends LightningElement {
    @api recordId;
    @api objectApiName;
    handleClose() {
        this.dispatchEvent(new CustomEvent('close'));
    }
    handleSubmitButtonClick() {
        this.template.querySelector('lightning-record-edit-form').submit();
        this.dispatchEvent(new CustomEvent('close'));
    }
}