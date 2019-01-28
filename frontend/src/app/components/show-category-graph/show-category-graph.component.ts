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
      month: new FormControl(),
      day: new FormControl(),
      type_flag: new FormControl(),
      user_id: new FormControl()
    });
   }

  ngOnInit() {
    if (this.cookieService.get('user_id') == ''){
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

  onReceiveMonth(eventData) {
    if (eventData !== null){
      this.change = false
      this.month = eventData;
      this.form['month'] = eventData
    }
  }

  onReceiveDay(eventData) {
    this.change = false
    this.day = eventData;
    this.form['day'] = eventData
  }

  onShowGraph(){
    this.form['type_flag'] = 'category'
    if (this.form['category_id'] !== undefined && this.form['month'] !== undefined){
      this.showGraphService.getWorkTimes(this.form).subscribe((response) => {
        this.data = response;
        this.showGraphService.getUsrsLists(this.form).subscribe((response)=> {
          this.users = response;
          
          var users_lists = [];
          for (var item in this.users){
            users_lists.push(this.users[item])
          }
          this.names = users_lists

        })
        if (this.data['status'] == 404){
          this.toastr.error(this.data['message']);
        } else {
          this.change = true
        }
      })
    }
  }

}
