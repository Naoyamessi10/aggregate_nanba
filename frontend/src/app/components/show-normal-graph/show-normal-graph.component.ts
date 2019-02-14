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
    if (this.cookieService.get('user_id') == '' || this.cookieService.get('user_id') == 'undefined'){
      this.cookieService.deleteAll();
      window.location.href = this.googleUrl
    }
  }

  onReceiveDay(eventData) {
      this.change = false
      this.day = eventData;
  }

  onCreateParams(){
    var day_params = { day: this.day, type_flag: false, user_id: this.cookieService.get('user_id')}
    return day_params
  }

  onShowGraph(){
    this.change = false;
    if (this.day !== undefined){
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
