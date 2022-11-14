import { ShowToastEvent } from 'lightning/platformShowToastEvent';
/**
 * Reduces one or more LDS errors into a string[] of error messages.
 * @param {FetchResponse|FetchResponse[]} errors
 * @return {String[]} Error messages
 */




function reduceErrors(errors) {
    if (!Array.isArray(errors)) {
        errors = [errors];
    }

    return (
        errors
            // Remove null/undefined items
            .filter((error) => !!error)
            // Extract an error message
            .map((error) => {
                // UI API read errors
                if (Array.isArray(error.body)) {
                    return error.body.map((e) => e.message);
                }
                // UI API DML, Apex and network errors
                else if (error.body && typeof error.body.message === 'string') {
                    return error.body.message;
                }
                // JS errors
                else if (typeof error.message === 'string') {
                    return error.message;
                }
                // Unknown error shape so try HTTP status text
                return error.statusText;
            })
            // Flatten
            .reduce((prev, curr) => prev.concat(curr), [])
            // Remove empty strings
            .filter((message) => !!message)
    );
}

function showError(cmp, errors, methodName) {
    if (errors) {
        
        console.log('%cError ', 'background: red', methodName, errors);
        reduceErrors(errors).forEach((error) => {
            // const evt = new ShowToastEvent({
            //     title: 'Error',
            //     message: error,
            //     variant: 'error',
            //     mode: 'dismissable'
            // });
            cmp.message = error;
            cmp.variant = 'error';
            cmp.template.querySelector('c-lwc-custom-toast').showCustomNotice();
            //cmp.dispatchEvent(evt);
        });
    }
}

export  {
    reduceErrors,
    showError,
}