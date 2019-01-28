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

  onShowGraph(){
    if (this.month !== undefined){
      this.showGraphService.getWorkTimes(this.onCreateParams()).subscribe((response) => {
        this.data = response;
        this.showGraphService.getUsrsLists(this.onCreateParams()).subscribe((response)=> {
          this.users = response;
          
          var users_lists = [];
          for (var item in this.users){
            users_lists.push(item+ ' : '+ this.users[item])
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
