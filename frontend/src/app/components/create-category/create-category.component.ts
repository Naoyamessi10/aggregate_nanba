import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { CookieService } from 'ngx-cookie-service';
import { ToastrService } from 'ngx-toastr';

import { CreateCategoryService } from  '../services/create-category.service';
import { validateForm } from '../../shared/functions/validate-form';
import { environment } from '../../../environments/environment'

@Component({
  selector: 'app-create-category',
  templateUrl: './create-category.component.html',
  styleUrls: ['./create-category.component.css'],
  providers: [CreateCategoryService]
})
export class CreateCategoryComponent implements OnInit {
  googleUrl = environment.googleUrl;
  form: FormGroup;
  formErrors: {[key: string]: Array<string>}= {};
  validationMessages = {
    'title': {
      'required': 'カテゴリを入力してください。',
    }
  };

  constructor(private CreateCategoryService: CreateCategoryService,
              private cookieService: CookieService,
              private toastr: ToastrService) { 
    this.form = new FormGroup({
      title: new FormControl(),
    });
  }

  ngOnInit() {
    if (this.cookieService.get('user_id') == '' || this.cookieService.get('user_id') == 'undefined'){
      window.location.href = this.googleUrl
    }
  }

  onSubmit() {
    if (this.form.valid) {
      this.formErrors =  validateForm(this.form, true, this.validationMessages);
      this.CreateCategoryService.createCategories(this.onCreateParams()).subscribe(response => {
        response = response;
        if(response['status'] == 400){
        this.toastr.error(response['message']);
        }
        if(response['status'] == 500){
          window.location.href = this.googleUrl
        }
        if(response['status'] == 200){
          this.toastr.success(response['message']);
        }
      })
    } else {
      this.formErrors =  validateForm(this.form, false, this.validationMessages);
    }
  }

  onCreateParams(){
    var data = { title: this.form.value['title'], user_id: this.cookieService.get('user_id') }
    return data
  }

}
