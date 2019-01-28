import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

import { Category } from '../category';
import { WorkTime } from '../work_time';
import { WorkTimesHour } from '../../shared/components/work_times_hour';
import { WorkTimesMinute } from '../../shared/components/work_times_minute';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class InputDateService {
  apiEndpoint = environment.apiEndpoint;
  googleUrl = environment.googleUrl;
  work_times_hour: WorkTimesHour;
  work_times_minute: WorkTimesMinute;
  data: string;

  constructor(private http: HttpClient) { }

  getCategories(user_id): Observable<Category> {
    const url = `${this.apiEndpoint}/categories/${user_id}`;
    return this.http.get<Category>(url);
  }

  createWorkTimes(params): Observable<WorkTime>{
    const url = `${this.apiEndpoint}/work_times`;
    return this.http.post<WorkTime>(url, params);
  }

  getWorkTimesHour(): Observable<WorkTimesHour> {
    const url = `${this.apiEndpoint}/work_times_hours`;
    return this.http.get<WorkTimesHour>(url);
  }

  getWorkTimesMinute(): Observable<WorkTimesMinute> {
    const url = `${this.apiEndpoint}/work_times_minutes`;
    return this.http.get<WorkTimesMinute>(url);
  }

  getGoogleCalendar(user_id: string): Observable<string>{
    const url = `${this.apiEndpoint}/work_times/import`;
    return this.http.post<string>(url, {user_id: user_id});
  }

  createCookie(code: string): Observable<string>{
    const url = `${this.apiEndpoint}/work_times/create_cookie`;
    return this.http.post<string>(url, {code: code});
  }

}