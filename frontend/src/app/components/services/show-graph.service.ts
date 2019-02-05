import { Injectable } from '@angular/core';

import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

import { Category } from '../category';
import { WorkTime } from '../work_time';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ShowGraphService {
  apiEndpoint = environment.apiEndpoint;

  constructor(private http: HttpClient) { }

  getCategories(user_id): Observable<Category> {
    const url = `${this.apiEndpoint}/categories/${user_id}`;
    return this.http.get<Category>(url);
  }

  getWorkTimes(params: {}): Observable<WorkTime> {
    const url = `${this.apiEndpoint}/work_times`;
    return this.http.get<WorkTime>(url, {params: params});
  }

}
