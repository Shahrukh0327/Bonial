/**
 * @description       : 
 * @author            : Shahrukh Ahmed 
 * @last modified on  : 15-03-2025
 * @last modified by  : Shahrukh Ahmed 
**/
import { LightningElement, api } from 'lwc';

import { ShowToastEvent } from "lightning/platformShowToastEvent";
export default class EditFormModal extends LightningElement {
    @api recordId;
    @api objectApiName;
    handleClose() {
        this.dispatchEvent(new CustomEvent('close'));
    }
    handleSubmitButtonClick() {
        this.template.querySelector('lightning-record-edit-form').submit();
    }

    handleSuccessClick(event) {
        console.log(event.detail.id);
        const success = new ShowToastEvent({
            title: 'Contact ',
            message: 'Record Updated Successfully',
            variant: 'success',
        });
        this.dispatchEvent(success);
        this.handleClose();
    }
}