import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { ActivatedRoute } from '@angular/router';
import { CookieService } from 'ngx-cookie-service';
import { ToastrService } from 'ngx-toastr';

import { InputDateService } from '../services/input-date.service';
import { Category } from '../category';
import { environment } from '../../../environments/environment'

@Component({
  selector: 'app-input-date',
  templateUrl: './input-date.component.html',
  styleUrls: ['./input-date.component.css'],
  providers: [InputDateService]
})

export class InputDateComponent implements OnInit {
  googleUrl = environment.googleUrl;
  categories: Category;
  form: FormGroup;
  change = false;
  access = false;
  google_data;

  constructor(private inputdateService: InputDateService,
              private route: ActivatedRoute,
              private cookieService: CookieService,
              private toastr: ToastrService) {
    this.form = new FormGroup({
      category_id: new FormControl(),
    });
  }

  ngOnInit() {
    window.onload = function(){
      (<HTMLInputElement> document.getElementById("aaa")).disabled = false;
    };
    this.getNewid();
    /*cookieにuser_idがあればカテゴリをとってくる*/
    if(this.cookieService.get('user_id') !== ''){
      this.inputdateService.getCategories().subscribe((response) => {
        this.categories = response;
        (<HTMLInputElement> document.getElementById("aaa")).disabled = false;
      })
    }
  }

  getNewid(){
    /*クエリが取れていたら*/
    if (this.route.snapshot.queryParams['error'] !== 'access_denied'){
      this.google_data = this.route.snapshot.queryParams['code'];
      /*code以下を使ってgoogleカレンダー認証*/
      if(this.google_data !== undefined && this.cookieService.get('user_id') == ''){
        /*code以下がある場合とってくる*/
        this.inputdateService.createCookie(this.google_data).subscribe((response) => {
          response = response;
          if (this.cookieService.get('user_id') !== response['cookie']){
            this.cookieService.set('user_id', response['user_id'])
            this.inputdateService.getGoogleCalendar(response['user_id']).subscribe((res) => {
              res = res;
            })
            this.inputdateService.getCategories().subscribe((response) => {
              this.categories = response;
            })
          }
        })
      } else {
        if (this.cookieService.get('user_id') == ''){
          window.location.href = this.googleUrl
        }
      }
      this.access = true;
    } else {
      this.access = false;
    }
  }

  google_calendar(){
    (<HTMLInputElement> document.getElementById("aaa")).disabled = true;
      this.inputdateService.getGoogleCalendar(this.cookieService.get('user_id')).subscribe((response) => {
        response = response;
        this.toastr.success('googleカレンダーから取得しました！');
        (<HTMLInputElement> document.getElementById("aaa")).disabled = false;
        if (this.cookieService.get('user_id') !== response['cookie']){
          this.cookieService.set('user_id', response['cookie'])
        }
      })
  }

}
