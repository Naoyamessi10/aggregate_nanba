import { FormGroup, FormArray } from '@angular/forms';

export function validateForm(form: FormGroup, check_dirty = false, validationMessages = {}) {
  const formErrors = {};
  validateFormGroup(formErrors, form, check_dirty, validationMessages);
  return formErrors;
}

function validateFormGroup(formErrors = {}, form: FormGroup, check_dirty = false, validationMessages = {}) {
  Object.keys(form.controls).forEach((field) => {
    formErrors[field] = null;
    const control = form.get(field);
    let controlIsInvalid = !control.valid;
    const controlValue = control.value;
    const isRequired = (validationMessages[field] || {}).hasOwnProperty('required');
    const isStringControl = typeof controlValue === 'string' || controlValue instanceof String;
    if (control instanceof FormArray) {
      formErrors[field] = [];
      control.controls.forEach((obj, index) => {
        formErrors[field][index] = {};
        validateFormGroup(formErrors[field][index] || {}, <FormGroup>obj, check_dirty, validationMessages[field]);
      });
    } else {
      if (isRequired && isStringControl && controlValue.trim() === '') {
        controlIsInvalid = true;
        control.setErrors(Object.assign({required: true}, control.errors));
      }
      if (check_dirty) {
        controlIsInvalid = controlIsInvalid && control.dirty;
      }
      if (controlIsInvalid) {
        const messages = validationMessages[field];
        for (const key of Object.keys(control.errors)) {
          formErrors[field] = formErrors[field] || [];
          formErrors[field].push(messages[key]);
        }
      }
    }
  });
}
