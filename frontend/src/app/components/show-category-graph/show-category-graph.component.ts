import { Component, OnInit } from '@angular/core';
import { CookieService } from 'ngx-cookie-service';
import { ToastrService } from 'ngx-toastr';

import { ShowGraphService } from '../services/show-graph.service'
import { Category } from '../category';
import { FormGroup, FormControl } from '@angular/forms';
import { environment } from '../../../environments/environment'

@Component({
  selector: 'app-show-category-graph',
  templateUrl: './show-category-graph.component.html',
  styleUrls: ['./show-category-graph.component.css']
})
export class ShowCategoryGraphComponent implements OnInit {
  googleUrl = environment.googleUrl;
  form: FormGroup
  categories: Category;
  category_id
  month;
  day;
  category_flag = true;
  change = false;
  type_flag = false;
  data;
  users;
  names;
  eventData;

  constructor(private showGraphService: ShowGraphService,
              private cookieService: CookieService,
              private toastr: ToastrService) {
    this.form = new FormGroup({
      day: new FormControl(),
      type_flag: new FormControl(),
      user_id: new FormControl()
    });
  }

  ngOnInit() {
    if (this.cookieService.get('user_id') == '' || this.cookieService.get('user_id') == 'undefined'){
      this.cookieService.deleteAll();
      window.location.href = this.googleUrl
    }
    this.form['user_id'] = this.cookieService.get('user_id')
  }

  onReceiveCategory_id(eventData) {
    if (eventData !== null){
      this.change = false
      this.category_id = eventData;
      this.form['category_id'] = eventData
    }
  }

  onReceiveDay(eventData) {
    this.change = false
    this.day = eventData;
    this.form['day'] = eventData
  }

  onShowGraph(){
    if(this.form['day'] == undefined){
      this.toastr.error('表示する期間を選択してください。');
    }
    if(this.form['category_id'] == undefined){
      this.toastr.error('カテゴリを選択してください。');
    }
    this.change = false;
    this.form['type_flag'] = 'category'
    if (this.form['category_id'] !== undefined && this.form['day'] !== undefined){
      this.showGraphService.getWorkTimes(this.form).subscribe((response) => {
        this.data = response;
        if (this.data['status'] == 404){
          this.toastr.error(this.data['message']);
        } else {
          this.change = true
        }
      })
    }
  }

}
