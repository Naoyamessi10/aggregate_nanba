import { Component, OnInit, Output, EventEmitter, Input } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';

import { ShowGraphService } from '../../../components/services/show-graph.service';
import { Category } from '../../../components/category';
import { CookieService } from 'ngx-cookie-service';

@Component({
  selector: 'app-select-date',
  templateUrl: './select-date.component.html',
  styleUrls: ['./select-date.component.css']
})
export class SelectDateComponent implements OnInit {
  form: FormGroup;
  categories: Category;
  all_month = [1,2,3,4,5,6,7,8,9,10,11,12]
  year = new Date().getFullYear()
  max_day;
  all_day = [];
  graph_flag = false;
  change = false;
  @Input() category_flag;
  @Output() eventCategory_id = new EventEmitter<String>();
  @Output() eventMonth = new EventEmitter<String>();
  @Output() eventDay = new EventEmitter<String>();

  constructor(private showGraphService: ShowGraphService,
              private cookieService: CookieService) { 
    this.form = new FormGroup({
      category: new FormControl(),
      month: new FormControl(),
      day: new FormControl(),
    });
  }

  ngOnInit() {
    if (this.category_flag){
      this.showGraphService.getCategories(this.cookieService.get('user_id')).subscribe((response) => {
        this.categories = response;
      })
    }
  }

  onSelectCategory($event){
    this.eventCategory_id.emit($event.target.value)
  }

  onChangeMonth($event){
    this.max_day = new Date(this.year, $event.target.value, 0).getDate()
    for (var i = 0; i < this.max_day; i++){
      this.all_day[i] = i + 1;
    }
    this.eventMonth.emit($event.target.value)
  }

  onChangeday($event){
    this.eventDay.emit($event.target.value)
  }

}
