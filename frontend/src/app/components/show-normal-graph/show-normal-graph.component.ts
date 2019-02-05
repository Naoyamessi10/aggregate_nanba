import { Component, OnInit } from '@angular/core';
import { CookieService } from 'ngx-cookie-service';
import { ToastrService } from 'ngx-toastr';

import { ShowGraphService } from '../services/show-graph.service'
import { environment } from '../../../environments/environment'

@Component({
  selector: 'app-show-normal-graph',
  templateUrl: './show-normal-graph.component.html',
  styleUrls: ['./show-normal-graph.component.css']
})
export class ShowNormalGraphComponent implements OnInit {
  googleUrl = environment.googleUrl;
  month;
  day;
  category_flag = false;
  change = false;
  type_flag = false;
  data;
  users;
  names;
  eventData;
  dateT = ["日","月","火","水","木","金","土"];

  constructor(private showGraphService: ShowGraphService,
              private cookieService: CookieService,
              private toastr: ToastrService) {}

  ngOnInit() {
    if (this.cookieService.get('user_id') == ''){
      window.location.href = this.googleUrl
    }
  }

  onReceiveMonth(eventData) {
    if (eventData !== null){
      this.change = false
      this.month = eventData
    }
  }

  onReceiveDay(eventData) {
      this.change = false
      this.day = eventData;
  }

  onCreateParams(){
    if (this.day == undefined || this.day == 'null'){
      var month_params = { month: this.month , type_flag: false, user_id: this.cookieService.get('user_id')}
      return month_params
    } else {
      var day_params = { month: this.month , day: this.day, type_flag: false, user_id: this.cookieService.get('user_id')}
      return day_params
    }
  }

  onShowWeekGraph(){
    var dt = new Date();
    var kako = dt.getDay() - 1;
    var dayday = dt.getDate() - kako;
    dt.setDate(dayday);
    var week_params = { year: dt.getFullYear(), month: dt.getMonth() + 1 , day: dt.getDate(), type_flag: false, week_type: true, user_id: this.cookieService.get('user_id')}
    this.showGraphService.getWorkTimes(week_params).subscribe((response) => {
      this.data = response;
      if (this.data['status'] == 404){
        this.toastr.error(this.data['message']);
      } else {
        this.change = true
      }
    })
  }

  onShowGraph(){
    if (this.month !== undefined){
      this.showGraphService.getWorkTimes(this.onCreateParams()).subscribe((response) => {
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
