import { Injectable } from '@angular/core';

import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

import { Category } from '../category';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class CreateCategoryService {
  apiEndpoint = environment.apiEndpoint;

  constructor(private http: HttpClient) { }

  createCategories(params): Observable<Category>{
    const url = `${this.apiEndpoint}/categories`;
    return this.http.post<Category>(url, params);
  }
}
